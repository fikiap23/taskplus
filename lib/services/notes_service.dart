import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskplus/services/user_data.dart';

class NotesService {
  static const String baseUrl =
      'https://taskplus-backend.vercel.app/v1/api/notes';

  Future<Map<String, dynamic>?> createNote(
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
        // Successful note creation
        final result = jsonDecode(response.body);
        return result;
      } else {
        // Handle error
        print('Note creation failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error during note creation request: $error');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getNotes() async {
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
        // Successful retrieval of notes
        final List<dynamic> result = jsonDecode(response.body);
        final List<Map<String, dynamic>> notes =
            List<Map<String, dynamic>>.from(result);
        print(notes);
        return notes;
      } else {
        // Handle error
        print('Failed to get notes. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error during get notes request: $error');
      return null;
    }
  }

  Future<bool> deleteNote(String noteId) async {
    final String apiUrl = '$baseUrl/$noteId';
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
        // Successful note deletion
        print('Note deleted successfully');
        return true;
      } else {
        // Handle error
        print('Failed to delete note. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error during delete note request: $error');
      return false;
    }
  }

  Future<bool> updateNote(
      String noteId, Map<String, dynamic> updatedData) async {
    final String apiUrl = '$baseUrl/$noteId';
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
        // Successful note update
        print('Note updated successfully');
        return true;
      } else {
        // Handle error
        print('Failed to update note. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error during update note request: $error');
      return false;
    }
  }

  // Mencari catatan berdasarkan title atau description
  Future<List<Map<String, dynamic>>?> searchNotes(String query) async {
    final String apiUrl = '$baseUrl/search/$query';
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
        // Successful search of notes
        final List<dynamic> result = jsonDecode(response.body);
        final List<Map<String, dynamic>> notes =
            List<Map<String, dynamic>>.from(result);
        print(notes);
        return notes;
      } else {
        // Handle error
        print('Failed to search notes. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error during search notes request: $error');
      return null;
    }
  }
}
