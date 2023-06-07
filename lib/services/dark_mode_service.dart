import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final darkModeProvider = StateNotifierProvider<DarkModeService, bool>((ref) {
  return DarkModeService();
});

class DarkModeService extends StateNotifier<bool> {
  DarkModeService() : super(false) {
    init();
  }

  init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final darkMode = sharedPreferences.getBool("darkMode");
    state = darkMode ?? false;
  }

  switchTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool("darkMode", !state);
    state = !state;
  }
}
