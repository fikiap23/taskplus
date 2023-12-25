// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';

class AccessToken {
  static Future<void> saveToken(String token) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', token);
    } catch (e) {
      print('Error saving token to SharedPreferences: $e');
    }
  }

  static Future<String?> getToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('accessToken');
    } catch (e) {
      print('Error get token from SharedPreferences: $e');
      return e.toString();
    }
  }

  static Future<bool> deleteToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      return true;
    } catch (e) {
      print('Error saving token to SharedPreferences: $e');
      return false;
    }
  }
}
