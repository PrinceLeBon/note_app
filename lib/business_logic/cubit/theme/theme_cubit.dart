import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeMode: ThemeMode.system)) {
    _loadTheme();
  }

  void _loadTheme() async {
    final box = await Hive.openBox('settings');
    final themeModeIndex = box.get('themeMode', defaultValue: 2);
    final themeMode = ThemeMode.values[themeModeIndex];
    emit(ThemeState(themeMode: themeMode));
  }

  void changeTheme(ThemeMode themeMode) async {
    emit(ThemeState(themeMode: themeMode));
    final box = await Hive.openBox('settings');
    await box.put('themeMode', themeMode.index);
  }
}
