import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/business_logic/cubit/sync/sync_cubit.dart';
import 'package:note_app/presentation/widgets/google_text.dart';

class SyncStatusBadge extends StatelessWidget {
  const SyncStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncCubit, SyncState>(
      builder: (context, state) {
        if (state is SyncInProgress) {
          return _buildBadge(
            context: context,
            icon: SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            text: "Sync...",
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            textColor: Theme.of(context).colorScheme.primary,
          );
        } else if (state is SyncPending) {
          return GestureDetector(
            onTap: () {
              // Trigger manual sync
              context.read<SyncCubit>().performManualSync();
            },
            child: _buildBadge(
              context: context,
              icon: Icon(
                Icons.cloud_off,
                size: 16,
                color: Colors.orange,
              ),
              text: "${state.pendingCount} en attente",
              backgroundColor: Colors.orange.withOpacity(0.2),
              textColor: Colors.orange,
            ),
          );
        } else if (state is SyncFailed) {
          return GestureDetector(
            onTap: () {
              // Show error details or retry
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: GoogleText(text: state.error),
                  action: SnackBarAction(
                    label: "Réessayer",
                    onPressed: () {
                      context.read<SyncCubit>().retryFailedSync();
                    },
                  ),
                ),
              );
            },
            child: _buildBadge(
              context: context,
              icon: Icon(
                Icons.error_outline,
                size: 16,
                color: Colors.red,
              ),
              text: "Erreur",
              backgroundColor: Colors.red.withOpacity(0.2),
              textColor: Colors.red,
            ),
          );
        } else if (state is SyncCompleted && state.failureCount > 0) {
          return GestureDetector(
            onTap: () {
              // Retry failed operations
              context.read<SyncCubit>().retryFailedSync();
            },
            child: _buildBadge(
              context: context,
              icon: Icon(
                Icons.warning,
                size: 16,
                color: Colors.orange,
              ),
              text: "${state.failureCount} échec(s)",
              backgroundColor: Colors.orange.withOpacity(0.2),
              textColor: Colors.orange,
            ),
          );
        } else if (state is SyncOffline) {
          return _buildBadge(
            context: context,
            icon: Icon(
              Icons.cloud_off,
              size: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            text: "Hors ligne",
            backgroundColor: Theme.of(context).colorScheme.surface,
            textColor: Theme.of(context).textTheme.bodySmall?.color,
          );
        }
        
        // All synced - show checkmark
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Icons.cloud_done,
            size: 20,
            color: Colors.green,
          ),
        );
      },
    );
  }

  Widget _buildBadge({
    required BuildContext context,
    required Widget icon,
    required String text,
    required Color? backgroundColor,
    required Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 4),
          GoogleText(
            text: text,
            fontSize: 12,
            color: textColor,
          ),
        ],
      ),
    );
  }
}
