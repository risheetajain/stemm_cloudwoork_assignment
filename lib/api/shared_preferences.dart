import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<bool> setLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(loginStatus, true);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginStatus) ?? false;
  }
}

String loginStatus = "loginStatus";
