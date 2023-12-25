// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

class UserService {
  Future<Map<String, dynamic>?> signup(Map<String, dynamic> requestData) async {
    const String apiUrl =
        'https://taskplus-backend.vercel.app/v1/api/users/signup';
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
}
