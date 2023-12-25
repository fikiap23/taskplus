// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserData {
  static const String _userDataKey = 'user_data';

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String jsonData = jsonEncode(userData);
      await prefs.setString(_userDataKey, jsonData);
    } catch (e) {
      print('Error saving user data to SharedPreferences: $e');
    }
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? jsonData = prefs.getString(_userDataKey);
      if (jsonData != null) {
        return jsonDecode(jsonData);
      }
      return null;
    } catch (e) {
      print('Error getting user data from SharedPreferences: $e');
      return null;
    }
  }

  static Future<dynamic> getUserDataValue(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? jsonData = prefs.getString(_userDataKey);

      if (jsonData != null) {
        final Map<String, dynamic> userData = jsonDecode(jsonData);
        return userData[key];
      }

      return null;
    } catch (e) {
      print('Error getting user data value from SharedPreferences: $e');
      return null;
    }
  }

  static Future<bool> deleteUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
      // print(await UserData.getUserData());
      return true;
    } catch (e) {
      print('Error deleting user data from SharedPreferences: $e');
      return false;
    }
  }

  static const String _tokenKey = 'token';

  static Future<void> saveToken(String token) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('Error saving token to SharedPreferences: $e');
    }
  }

  static Future<String?> getToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Error getting token from SharedPreferences: $e');
      return null;
    }
  }
}
