import 'dart:async';

import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:note_app/data/models/sync_operation.dart';
import 'package:note_app/data/providers/firestore.dart';
import 'package:note_app/services/connectivity_service.dart';

enum SyncStatus {
  idle,
  syncing,
  upToDate,
  hasErrors,
  offline,
}

class SyncService {
  final FirestoreAPI _firestoreAPI;
  final ConnectivityService _connectivityService;
  final Logger _logger = Logger();

  StreamSubscription? _connectivitySubscription;
  Timer? _periodicSyncTimer;
  bool _isSyncing = false;

  // Stream controller for sync status
  final StreamController<SyncStatus> _syncStatusController =
      StreamController<SyncStatus>.broadcast();

  Stream<SyncStatus> get syncStatus => _syncStatusController.stream;

  // Stream controller for pending operations count
  final StreamController<int> _pendingCountController =
      StreamController<int>.broadcast();

  Stream<int> get pendingOperationsCount => _pendingCountController.stream;

  SyncService({
    required FirestoreAPI firestoreAPI,
    required ConnectivityService connectivityService,
  })  : _firestoreAPI = firestoreAPI,
        _connectivityService = connectivityService;

  void initialize() {
    _logger.i("Initializing SyncService...");

    // Listen for connectivity changes
    _connectivitySubscription =
        _connectivityService.connectionStatus.listen((isOnline) {
      if (isOnline) {
        _logger.i("🔄 Auto-sync triggered: Internet connection restored");
        performSync();
      } else {
        _syncStatusController.add(SyncStatus.offline);
      }
    });

    // Set up periodic sync every 5 minutes when online
    _startPeriodicSync();

    // Initial sync if online
    _connectivityService.checkConnection().then((isOnline) {
      if (isOnline) {
        performSync();
      } else {
        _syncStatusController.add(SyncStatus.offline);
      }
    });

    // Update pending count periodically
    _updatePendingCount();
  }

  void _startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) async {
      if (await _connectivityService.checkConnection()) {
        _logger.i("⏰ Periodic sync triggered");
        performSync();
      }
    });
  }

  void _updatePendingCount() async {
    final Box syncBox = await Hive.openBox('sync_queue');

    // Listen to box changes
    syncBox.listenable().addListener(() {
      final pendingOps = syncBox.values
          .where((op) => op is SyncOperation && !op.synced && !op.failed)
          .length;
      _pendingCountController.add(pendingOps);
    });

    // Initial count
    final pendingOps = syncBox.values
        .where((op) => op is SyncOperation && !op.synced && !op.failed)
        .length;
    _pendingCountController.add(pendingOps);
  }

  Future<void> performSync({bool isManual = false}) async {
    if (_isSyncing) {
      _logger.i("🚫 Sync already in progress, skipping...");
      return;
    }

    // Check connectivity first
    if (!await _connectivityService.checkConnection()) {
      _logger.i("📵 No internet connection, skipping sync");
      _syncStatusController.add(SyncStatus.offline);
      return;
    }

    _isSyncing = true;
    _syncStatusController.add(SyncStatus.syncing);

    try {
      final Box syncBox = await Hive.openBox('sync_queue');
      final pendingOps = syncBox.values
          .where((op) => op is SyncOperation && !op.synced && !op.failed)
          .toList()
          .cast<SyncOperation>();

      if (pendingOps.isEmpty) {
        _logger.i("✅ No pending operations to sync");
        _syncStatusController.add(SyncStatus.upToDate);
        _isSyncing = false;
        return;
      }

      _logger.i("🔄 Syncing ${pendingOps.length} pending operations...");

      int successCount = 0;
      int failCount = 0;

      for (var operation in pendingOps) {
        try {
          await _executeSyncOperation(operation);

          // Mark as synced
          final syncedOp = operation.copyWith(synced: true);
          await syncBox.put(operation.id, syncedOp);
          successCount++;

          // Remove old synced operations (older than 7 days)
          if (operation.timestamp
              .isBefore(DateTime.now().subtract(const Duration(days: 7)))) {
            await syncBox.delete(operation.id);
          }
        } catch (e) {
          _logger.e("❌ Failed to sync operation ${operation.id}: $e");
          failCount++;

          // Increment retry count
          final updatedOp = operation.copyWith(
            retryCount: operation.retryCount + 1,
            error: e.toString(),
          );

          // If too many retries, mark as failed
          if (updatedOp.retryCount > 5) {
            await syncBox.put(operation.id, updatedOp.copyWith(failed: true));
          } else {
            await syncBox.put(operation.id, updatedOp);
          }
        }
      }

      _logger
          .i("✅ Sync completed: $successCount successful, $failCount failed");

      if (failCount > 0) {
        _syncStatusController.add(SyncStatus.hasErrors);
      } else {
        _syncStatusController.add(SyncStatus.upToDate);
      }
    } catch (e) {
      _logger.e("❌ Sync error: $e");
      _syncStatusController.add(SyncStatus.hasErrors);
    } finally {
      _isSyncing = false;
      _updatePendingCount();
    }
  }

  Future<void> _executeSyncOperation(SyncOperation operation) async {
    _logger.i("Executing ${operation.type} for ${operation.collection}...");

    switch (operation.type) {
      case 'create':
        // For create operations, we need to update the local ID with the Firestore ID
        final docId = operation.documentId ?? operation.data['id'];
        await _firestoreAPI.addDocs(
          operation.collection,
          operation.data,
          operation.data['userId'],
        );
        break;

      case 'update':
        if (operation.documentId == null) {
          throw Exception('Document ID is required for update operation');
        }
        await _firestoreAPI.updateDocs(
          operation.collection,
          operation.documentId!,
          operation.data,
          operation.data['userId'],
        );
        break;

      case 'delete':
        if (operation.documentId == null) {
          throw Exception('Document ID is required for delete operation');
        }
        await _firestoreAPI.deleteDocs(
          operation.collection,
          operation.documentId!,
        );
        break;

      default:
        throw Exception('Unknown operation type: ${operation.type}');
    }
  }

  // Add operation to sync queue
  Future<void> addToSyncQueue({
    required String type,
    required String collection,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    final Box syncBox = await Hive.openBox('sync_queue');

    final operation = SyncOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      collection: collection,
      data: data,
      timestamp: DateTime.now(),
      synced: false,
      documentId: documentId,
    );

    await syncBox.put(operation.id, operation);
    _logger.i(
        "📝 Added operation to sync queue: ${operation.type} ${operation.collection}");

    // Update pending count
    _updatePendingCount();

    // Try to sync immediately if online
    if (await _connectivityService.checkConnection()) {
      // Delay slightly to allow UI to update
      Future.delayed(const Duration(milliseconds: 500), () {
        performSync();
      });
    }
  }

  // Get failed operations for retry or display
  Future<List<SyncOperation>> getFailedOperations() async {
    final Box syncBox = await Hive.openBox('sync_queue');
    return syncBox.values
        .where((op) => op is SyncOperation && op.failed)
        .toList()
        .cast<SyncOperation>();
  }

  // Clear all synced operations
  Future<void> clearSyncedOperations() async {
    final Box syncBox = await Hive.openBox('sync_queue');
    final syncedOps = syncBox.values
        .where((op) => op is SyncOperation && op.synced)
        .toList()
        .cast<SyncOperation>();

    for (var op in syncedOps) {
      await syncBox.delete(op.id);
    }

    _updatePendingCount();
  }

  // Manual retry for failed operations
  Future<void> retryFailedOperations() async {
    final Box syncBox = await Hive.openBox('sync_queue');
    final failedOps = syncBox.values
        .where((op) => op is SyncOperation && op.failed)
        .toList()
        .cast<SyncOperation>();

    for (var op in failedOps) {
      // Reset failed flag and retry count
      final retryOp = op.copyWith(
        failed: false,
        retryCount: 0,
        error: null,
      );
      await syncBox.put(op.id, retryOp);
    }

    // Trigger sync
    performSync();
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _periodicSyncTimer?.cancel();
    _syncStatusController.close();
    _pendingCountController.close();
  }
}
