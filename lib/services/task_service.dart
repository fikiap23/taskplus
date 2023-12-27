import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskplus/services/user_data.dart';

class TaskService {
  static const String baseUrl =
      'https://taskplus-backend.vercel.app/v1/api/tasks';

  Future<Map<String, dynamic>?> createTask(
      Map<String, dynamic> requestData, String subjectId) async {
    String apiUrl = '$baseUrl/$subjectId/create';
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
        // Successful task creation
        final result = jsonDecode(response.body);
        return result;
      } else {
        // Handle error
        print('Task creation failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error during task creation request: $error');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getTasks() async {
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
        // Successful retrieval of tasks
        final List<dynamic> result = jsonDecode(response.body);
        final List<Map<String, dynamic>> tasks =
            List<Map<String, dynamic>>.from(result);
        return tasks;
      } else {
        // Handle error
        print('Failed to get tasks. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error during get tasks request: $error');
      return null;
    }
  }

  Future<bool> deleteTask(String subjectId, String taskId) async {
    final String apiUrl = '$baseUrl/$subjectId/$taskId';
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
        // Successful task deletion
        print('Task deleted successfully');
        return true;
      } else {
        // Handle error
        print('Failed to delete task. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error during delete task request: $error');
      return false;
    }
  }

  Future<bool> updateTask(
      String taskId, String subjectId, Map<String, dynamic> updatedData) async {
    final String apiUrl = '$baseUrl/$subjectId/$taskId';
    try {
      String? token = await UserData.getToken();
      final http.Response response = await http.put(
        Uri.parse(apiUrl),
        body: jsonEncode(updatedData),
        headers: {
          'Content-Type': 'application/json',
          'auth-token': ' $token',
        },
      );

      if (response.statusCode == 200) {
        // Successful task update
        print('Task updated successfully');
        return true;
      } else {
        // Handle error
        print('Failed to update task. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error during update task request: $error');
      return false;
    }
  }
}
