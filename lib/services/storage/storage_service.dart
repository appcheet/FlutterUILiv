import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service for handling local data persistence using SharedPreferences and Hive
class StorageService {
  final SharedPreferences _prefs;
  Box? _hiveBox;

  StorageService(this._prefs);

  /// Initialize Hive storage
  Future<void> initHive() async {
    await Hive.initFlutter();
    _hiveBox = await Hive.openBox('app_storage');
  }

  /// SharedPreferences Methods
  /// Save string value
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// Get string value
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Save integer value
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// Get integer value
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Save boolean value
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// Get boolean value
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Save double value
  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  /// Get double value
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// Save list of strings
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  /// Get list of strings
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  /// Save object as JSON string
  Future<bool> setObject(String key, Map<String, dynamic> object) async {
    final jsonString = json.encode(object);
    return await _prefs.setString(key, jsonString);
  }

  /// Get object from JSON string
  Map<String, dynamic>? getObject(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  /// Save list of objects as JSON string
  Future<bool> setObjectList(String key, List<Map<String, dynamic>> objects) async {
    final jsonString = json.encode(objects);
    return await _prefs.setString(key, jsonString);
  }

  /// Get list of objects from JSON string
  List<Map<String, dynamic>>? getObjectList(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString != null) {
      final decoded = json.decode(jsonString) as List;
      return decoded.map((e) => e as Map<String, dynamic>).toList();
    }
    return null;
  }

  /// Remove value
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// Clear all values
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Get all keys
  Set<String> getAllKeys() {
    return _prefs.getKeys();
  }

  /// Hive Methods (for complex objects and better performance)
  /// Save value to Hive
  Future<void> setHive<T>(String key, T value) async {
    await _hiveBox?.put(key, value);
  }

  /// Get value from Hive
  T? getHive<T>(String key) {
    return _hiveBox?.get(key) as T?;
  }

  /// Remove value from Hive
  Future<void> removeHive(String key) async {
    await _hiveBox?.delete(key);
  }

  /// Clear all Hive values
  Future<void> clearHive() async {
    await _hiveBox?.clear();
  }

  /// Check if Hive key exists
  bool containsHiveKey(String key) {
    return _hiveBox?.containsKey(key) ?? false;
  }

  /// Get all Hive keys
  Iterable<dynamic> getAllHiveKeys() {
    return _hiveBox?.keys ?? [];
  }

  /// Watch Hive key for changes
  Stream<BoxEvent> watchHive({String? key}) {
    return _hiveBox?.watch(key: key) ?? const Stream.empty();
  }

  /// Close Hive box
  Future<void> closeHive() async {
    await _hiveBox?.close();
  }
}

/// Storage keys constants
class StorageKeys {
  static const String userToken = 'user_token';
  static const String userProfile = 'user_profile';
  static const String isDarkMode = 'is_dark_mode';
  static const String appSettings = 'app_settings';
  static const String todos = 'todos';
  static const String lastSync = 'last_sync';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String notificationSettings = 'notification_settings';
  static const String cachedUsers = 'cached_users';
}

/// Extension for type-safe storage operations
extension StorageServiceExtension on StorageService {
  /// User-specific methods
  Future<bool> saveUserToken(String token) =>
      setString(StorageKeys.userToken, token);

  String? getUserToken() => getString(StorageKeys.userToken);

  Future<bool> saveUserProfile(Map<String, dynamic> profile) =>
      setObject(StorageKeys.userProfile, profile);

  Map<String, dynamic>? getUserProfile() => getObject(StorageKeys.userProfile);

  Future<bool> setDarkMode(bool isDark) => setBool(StorageKeys.isDarkMode, isDark);

  bool isDarkMode() => getBool(StorageKeys.isDarkMode) ?? false;

  Future<bool> setOnboardingCompleted(bool completed) =>
      setBool(StorageKeys.onboardingCompleted, completed);

  bool isOnboardingCompleted() =>
      getBool(StorageKeys.onboardingCompleted) ?? false;
}