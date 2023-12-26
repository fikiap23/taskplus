import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskplus/services/user_data.dart';

class SubjectService {
  static const String baseUrl =
      'https://taskplus-backend.vercel.app/v1/api/subjects';

  Future<Map<String, dynamic>?> createSubject(
      Map<String, dynamic> requestData) async {
    const String apiUrl = '$baseUrl/create';
    try {
      String? token = await UserData.getToken();
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(requestData),
        headers: {
          'Content-Type': 'application/json',
          'auth-token': ' $token',
        },
      );

      if (response.statusCode == 201) {
        // Successful subject creation
        final result = jsonDecode(response.body);
        return result;
      } else {
        // Handle error
        print('Subject creation failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error during subject creation request: $error');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getSubjects() async {
    const String apiUrl = '$baseUrl/list';
    try {
      String? token = await UserData.getToken();
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'auth-token': ' $token',
        },
      );

      if (response.statusCode == 200) {
        // Successful retrieval of subjects
        final List<dynamic> result = jsonDecode(response.body);
        final List<Map<String, dynamic>> subjects =
            List<Map<String, dynamic>>.from(result);
        return subjects;
      } else {
        // Handle error
        print('Failed to get subjects. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error during get subjects request: $error');
      return null;
    }
  }

  Future<bool> deleteSubject(String subjectId) async {
    final String apiUrl = '$baseUrl/$subjectId';
    try {
      String? token = await UserData.getToken();
      final http.Response response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'auth-token': ' $token',
        },
      );

      if (response.statusCode == 200) {
        // Successful subject deletion
        print('Subject deleted successfully');
        return true;
      } else {
        // Handle error
        print('Failed to delete subject. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error during delete subject request: $error');
      return false;
    }
  }
}
