import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeBox = 'themeBox';
  static const String _themeKey = 'themeType';

  EidThemeType _currentTheme = EidThemeType.fitr;

  EidThemeType get currentTheme => _currentTheme;
  ThemeData get themeData => AppTheme.getTheme(_currentTheme);
  bool get isFitr => _currentTheme == EidThemeType.fitr;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final box = await Hive.openBox(_themeBox);
    final themeIndex = box.get(_themeKey, defaultValue: EidThemeType.fitr.index);
    _currentTheme = EidThemeType.values[themeIndex];
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _currentTheme = _currentTheme == EidThemeType.fitr
        ? EidThemeType.adha
        : EidThemeType.fitr;
    notifyListeners();

    final box = await Hive.openBox(_themeBox);
    await box.put(_themeKey, _currentTheme.index);
  }
}
