import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/business_logic/cubit/theme/theme_cubit.dart';
import 'package:note_app/presentation/widgets/google_text.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const GoogleText(
          text: "Paramètres",
          fontWeight: true,
          fontSize: 20,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, "Apparence"),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(
                Icons.palette_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const GoogleText(
                text: "Thème de l'application",
                fontSize: 16,
              ),
              subtitle: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  String themeName = _getThemeName(state.themeMode);
                  return GoogleText(
                    text: themeName,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  );
                },
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).iconTheme.color,
              ),
              onTap: () => _showThemeDialog(context),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, "À Propos"),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const GoogleText(
                text: "Version de l'application",
                fontSize: 16,
              ),
              subtitle: const GoogleText(
                text: "1.0.0",
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return "Clair";
      case ThemeMode.dark:
        return "Sombre";
      case ThemeMode.system:
        return "Système";
    }
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: GoogleText(
        text: title.toUpperCase(),
        fontSize: 12,
        fontWeight: true,
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final themeCubit = BlocProvider.of<ThemeCubit>(context);
        return BlocBuilder<ThemeCubit, ThemeState>(
          bloc: themeCubit,
          builder: (context, currentState) {
            return AlertDialog(
              title: const GoogleText(
                text: "Choisir un thème",
                fontWeight: true,
                fontSize: 20,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<ThemeMode>(
                    title: const GoogleText(text: "Clair"),
                    value: ThemeMode.light,
                    groupValue: currentState.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeCubit.changeTheme(value);
                        Navigator.of(dialogContext).pop();
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const GoogleText(text: "Sombre"),
                    value: ThemeMode.dark,
                    groupValue: currentState.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeCubit.changeTheme(value);
                        Navigator.of(dialogContext).pop();
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const GoogleText(text: "Système"),
                    value: ThemeMode.system,
                    groupValue: currentState.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeCubit.changeTheme(value);
                        Navigator.of(dialogContext).pop();
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: GoogleText(
                    text: "Annuler",
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
