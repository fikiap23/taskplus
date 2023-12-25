// signup_controller.dart

import 'package:flutter/material.dart';
import 'package:taskplus/screens/Auth/login_screen.dart';
import 'package:taskplus/services/user_service.dart';

class SignupController {
  final FocusNode focusNodeUsername = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();

  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerConfirmPassword =
      TextEditingController();

  final UserService _userService = UserService();

  void dispose() {
    focusNodePassword.dispose();
    // controllerNama.dispose();
    controllerUsername.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerConfirmPassword.dispose();
  }

  Future<void> signupUser(BuildContext context) async {
    final requestData = {
      "name": "tes",
      "username": controllerUsername.text,
      "email": controllerEmail.text,
      "password": controllerPassword.text,
      "repassword": controllerConfirmPassword.text,
    };

    try {
      final response = await _userService.signup(requestData);
      if (response != null) {
        // Successful signup
        print('Signup successful: $response');
        // Navigate to login screen upon successful signup
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        // Handle error
        print('Signup failed');
      }
    } catch (error) {
      print('Error during signup request: $error');
    }
  }
}
