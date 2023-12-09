import 'package:shared_preferences/shared_preferences.dart';

// final storageHelper = Provider<StorageHelper>((ref) {
//   return StorageHelperImpl(sharedPreferences: sharedPreferences);
// });

abstract class StorageHelper {
  String? getString(String key);

  Future<bool> setString(String key, String value);

  int? getInt(String key);

  Future<bool> setInt(String key, int value);

  bool? getBool(String key);

  Future<bool> setBool(String key, bool value);

  Future<bool> remove(String key);

  bool contains(String key);
}

class StorageHelperImpl extends StorageHelper {
  final SharedPreferences sharedPreferences;

  StorageHelperImpl({required this.sharedPreferences});

  @override
  String? getString(String key) {
    return sharedPreferences.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) {
    return sharedPreferences.setString(key, value);
  }

  @override
  int? getInt(String key) {
    return sharedPreferences.getInt(key);
  }

  @override
  Future<bool> setInt(String key, int value) {
    return sharedPreferences.setInt(key, value);
  }

  @override
  bool? getBool(String key) {
    return sharedPreferences.getBool(key);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    return sharedPreferences.setBool(key, value);
  }

  @override
  Future<bool> remove(String key) {
    return sharedPreferences.remove(key);
  }

  @override
  bool contains(String key) {
    return sharedPreferences.containsKey(key);
  }
}
