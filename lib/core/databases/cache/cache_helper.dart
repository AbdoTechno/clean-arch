import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  // Singleton
  static final CacheHelper _instance = CacheHelper._internal();

  factory CacheHelper() => _instance;

  CacheHelper._internal();

  static late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // String
  Future<bool> setString({required String key, required String value}) async {
    return await _sharedPreferences.setString(key, value);
  }

  String? getString({required String key}) {
    return _sharedPreferences.getString(key);
  }

  // Bool
  Future<bool> setBool({required String key, required bool value}) async {
    return await _sharedPreferences.setBool(key, value);
  }

  bool? getBool({required String key}) {
    return _sharedPreferences.getBool(key);
  }

  // Int
  Future<bool> setInt({required String key, required int value}) async {
    return await _sharedPreferences.setInt(key, value);
  }

  int? getInt({required String key}) {
    return _sharedPreferences.getInt(key);
  }

  // Delete specific key
  Future<bool> remove({required String key}) async {
    return await _sharedPreferences.remove(key);
  }

  // Delete all cached data
  Future<bool> clear() async {
    return await _sharedPreferences.clear();
  }
}
