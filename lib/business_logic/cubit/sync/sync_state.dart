part of 'sync_cubit.dart';

@immutable
abstract class SyncState {
  const SyncState();
}

class SyncInitial extends SyncState {}

class SyncInProgress extends SyncState {}

class SyncCompleted extends SyncState {
  final int successCount;
  final int failureCount;

  const SyncCompleted({
    required this.successCount,
    required this.failureCount,
  });
}

class SyncFailed extends SyncState {
  final String error;

  const SyncFailed({required this.error});
}

class SyncOffline extends SyncState {}

class SyncPending extends SyncState {
  final int pendingCount;

  const SyncPending({required this.pendingCount});
}
