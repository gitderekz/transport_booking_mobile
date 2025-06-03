import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_booking/models/user.dart';

class LocalStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<void> setUser(User user) async {
    await _secureStorage.write(key: 'user', value: jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    final userJson = await _secureStorage.read(key: 'user');
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  Future<void> setTheme(String themeMode) async {
    await _prefs?.setString('theme', themeMode);
  }

  Future<String?> getTheme() async {
    return _prefs?.getString('theme');
  }

  Future<void> setLanguage(String languageCode) async {
    await _prefs?.setString('language', languageCode);
  }

  Future<String?> getLanguage() async {
    return _prefs?.getString('language');
  }

  Future<void> saveLanguagePreference(String languageCode) => setLanguage(languageCode);
  Future<String?> getLanguagePreference() => getLanguage();

  Future<void> clear() async {
    await _secureStorage.deleteAll();
    await _prefs?.clear();
  }

  // // 🌙 Theme Preference
  // Future<void> saveThemePreference(bool isDarkMode) async {
  //   await _prefs?.setBool('isDarkMode', isDarkMode);
  // }
  //
  // Future<bool?> getThemePreference() async {
  //   return _prefs?.getBool('isDarkMode');
  // }

  // 🌙 Theme Preference using 'light', 'dark', 'system'
  Future<void> saveThemePreference(String themeMode) async {
    await _prefs?.setString('themeMode', themeMode); // saves 'light', 'dark', 'system'
  }

  Future<String?> getThemePreference() async {
    return _prefs?.getString('themeMode');
  }

  // // 🌍 Language Preference
  // Future<void> saveLanguagePreference(String languageCode) async {
  //   await _prefs?.setString('languageCode', languageCode);
  // }
  //
  // Future<String?> getLanguagePreference() async {
  //   return _prefs?.getString('languageCode');
  // }
}




// import 'dart:convert';
//
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../models/user.dart';
//
// class LocalStorage {
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
//   final SharedPreferences? _prefs;
//
//   LocalStorage([this._prefs]);
//
//   Future<void> init() async {
//     if (_prefs == null) {
//       await SharedPreferences.getInstance();
//     }
//   }
//
//   Future<void> setToken(String token) async {
//     await _secureStorage.write(key: 'token', value: token);
//   }
//
//   Future<String?> getToken() async {
//     return await _secureStorage.read(key: 'token');
//   }
//
//   Future<void> setUser(User user) async {
//     await _secureStorage.write(key: 'user', value: user.toJson().toString());
//   }
//
//   Future<User?> getUser() async {
//     final userJson = await _secureStorage.read(key: 'user');
//     if (userJson == null) return null;
//     return User.fromJson(jsonDecode(userJson));
//   }
//
//   Future<void> setTheme(String themeMode) async {
//     await _prefs?.setString('theme', themeMode);
//   }
//
//   Future<String?> getTheme() async {
//     return _prefs?.getString('theme');
//   }
//
//   Future<void> setLanguage(String languageCode) async {
//     await _prefs?.setString('language', languageCode);
//   }
//
//   Future<String?> getLanguage() async {
//     return _prefs?.getString('language');
//   }
//   Future<void> saveLanguagePreference(String languageCode) => setLanguage(languageCode);
//   Future<String?> getLanguagePreference() => getLanguage();
//
//   Future<void> clear() async {
//     await _secureStorage.deleteAll();
//     await _prefs?.clear();
//   }
// }