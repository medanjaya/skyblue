import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode mode = ThemeMode.dark;
  late bool isOn;

  ThemeProvider() {
    init();
  }
  
  void init() async {
    final prefs = await SharedPreferences.getInstance();
    
    isOn = prefs.getBool('mode') ?? true;
    mode = isOn ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  void toggle() async {
    final prefs = await SharedPreferences.getInstance();
    
    isOn = !isOn;
    mode = isOn ? ThemeMode.dark : ThemeMode.light;
    prefs.setBool('mode', isOn);
    
    notifyListeners();
  }
}