import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities/src/extensions/logger/logger.dart';

class LocalPreferences {
  static final LocalPreferences _instance = LocalPreferences._internal();
  late SharedPreferences _prefs;

  factory LocalPreferences() {
    return _instance;
  }

  LocalPreferences._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setAuth(bool value) async {
    await _prefs.setBool(PreferenceKey.isAuth, value);
    logger.i("isAuth stored: ${_prefs.getBool(PreferenceKey.isAuth)}");
  }

  bool get isAuth => _prefs.getBool(PreferenceKey.isAuth) ?? false;

  Future<void> setUserId(int id) async {
    await _prefs.setInt(PreferenceKey.userId, id);
    logger.i("userId stored: ${_prefs.getInt(PreferenceKey.userId)}");
  }

  int? get userId => _prefs.getInt(PreferenceKey.userId);

  Future<void> clear() async {
    await _prefs.clear();
  }
}

class PreferenceKey {
  static const String isAuth = "isAuth";
  static const String userId = "userId"; // ✅ renamed
}
