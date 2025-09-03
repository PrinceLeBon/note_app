import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:note_app/services/sync_service.dart';

part 'sync_state.dart';

class SyncCubit extends Cubit<SyncState> {
  final SyncService _syncService;
  StreamSubscription<SyncStatus>? _syncStatusSubscription;
  StreamSubscription<int>? _pendingCountSubscription;
  
  SyncCubit({required SyncService syncService}) 
      : _syncService = syncService,
        super(SyncInitial()) {
    _listenToSyncStatus();
    _listenToPendingCount();
  }
  
  void _listenToSyncStatus() {
    _syncStatusSubscription = _syncService.syncStatus.listen((status) {
      switch (status) {
        case SyncStatus.syncing:
          emit(SyncInProgress());
          break;
        case SyncStatus.upToDate:
          emit(const SyncCompleted(successCount: 0, failureCount: 0));
          break;
        case SyncStatus.hasErrors:
          _syncService.getFailedOperations().then((failedOps) {
            emit(SyncCompleted(successCount: 0, failureCount: failedOps.length));
          });
          break;
        case SyncStatus.offline:
          emit(SyncOffline());
          break;
        case SyncStatus.idle:
          // Do nothing
          break;
      }
    });
  }
  
  void _listenToPendingCount() {
    _pendingCountSubscription = _syncService.pendingOperationsCount.listen((count) {
      if (state is! SyncInProgress && count > 0) {
        emit(SyncPending(pendingCount: count));
      }
    });
  }
  
  Future<void> performManualSync() async {
    emit(SyncInProgress());
    try {
      await _syncService.performSync(isManual: true);
    } catch (e) {
      emit(SyncFailed(error: e.toString()));
    }
  }
  
  Future<void> retryFailedSync() async {
    emit(SyncInProgress());
    try {
      await _syncService.retryFailedOperations();
    } catch (e) {
      emit(SyncFailed(error: e.toString()));
    }
  }
  
  @override
  Future<void> close() {
    _syncStatusSubscription?.cancel();
    _pendingCountSubscription?.cancel();
    return super.close();
  }
}
