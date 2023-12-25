// user_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

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
        // Successful login
        return jsonDecode(response.body);
      } else {
        // Handle error
        print('Login failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error during login request: $error');
      return null;
    }
  }
}
