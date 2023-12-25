// login_controller.dart

import 'package:flutter/material.dart';
import 'package:taskplus/screens/Home/home_screen.dart';
import 'package:taskplus/services/user_service.dart';

class LoginController {
  final FocusNode focusNodePassword = FocusNode();
  final TextEditingController controllerIdentifier = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  bool obscurePassword = true;
  final UserService _userService = UserService();

  void dispose() {
    focusNodePassword.dispose();
    controllerIdentifier.dispose();
    controllerPassword.dispose();
  }

  Future<void> loginUser(BuildContext context) async {
    final requestData = {
      "identifier": controllerIdentifier.text,
      "password": controllerPassword.text,
    };

    try {
      final response = await _userService.login(requestData);
      if (response != null) {
        // Successful login
        print('Login successful: $response');
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const HomePage();
            },
          ),
        );
      } else {
        // Handle error
        print('Login failed');
      }
    } catch (error) {
      print('Error during login request: $error');
    }
  }
}
