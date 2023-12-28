// user_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskplus/services/user_data.dart';

class UserService {
  static const String baseUrl =
      'https://taskplus-backend.vercel.app/v1/api/users';

  Future<Map<String, dynamic>?> signup(Map<String, dynamic> requestData) async {
    const String apiUrl = '$baseUrl/signup';
    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Successful signup
        return jsonDecode(response.body);
      } else {
        // Handle error
        print('Signup failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error during signup request: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> login(Map<String, dynamic> requestData) async {
    const String apiUrl = '$baseUrl/login';
    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        // print('ini response login: ${result["token"]}');

        // Save token to SharedPreferences
        await UserData.saveToken(result["token"]);

        // print(await UserData.getToken());

        // Successful login
        return jsonDecode(response.body);
      } else {
        // Handle error
        // print('Login failed. Status code: ${response.statusCode}');
        // print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      // print('Error during login request: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateProfile(
    String userId,
    Map<String, dynamic> requestData,
  ) async {
    final String apiUrl = '$baseUrl/update/$userId';
    try {
      String? token = await UserData.getToken();
      // print(token);
      final http.Response response = await http
          .put(Uri.parse(apiUrl), body: jsonEncode(requestData), headers: {
        'Content-Type': 'application/json',
        'auth-token': ' $token',
      });

      if (response.statusCode == 200) {
        // Profil berhasil diperbarui
        print("Sukses update profile");
        final resultNewData = jsonDecode(response.body);
        UserData.saveUserData(resultNewData);
        print(await UserData.getUserData());
        return resultNewData;
      } else {
        // Handle error
        print('Gagal memperbarui profil. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error saat permintaan pembaruan profil: $error');
      return null;
    }
  }
}
