// signup_controller.dart

import 'package:flutter/material.dart';
import 'package:taskplus/common/widgets/loader.dart';
import 'package:taskplus/screens/Auth/login_screen.dart';
import 'package:taskplus/services/user_service.dart';

class SignupController {
  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeUsername = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();

  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerConfirmPassword =
      TextEditingController();

  final UserService _userService = UserService();

  void dispose() {
    focusNodePassword.dispose();
    controllerName.dispose();
    controllerUsername.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerConfirmPassword.dispose();
  }

  Future<void> signupUser(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Loader(), // Show loading indicator
    );

    final requestData = {
      "name": controllerName.text,
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
        // Close loading indicator
        Navigator.pop(context);
        // Navigate to login screen upon successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        // Handle error
        print('Signup failed');
        // Close loading indicator
        Navigator.pop(context);
      }
    } catch (error) {
      print('Error during signup request: $error');
      // Close loading indicator
      Navigator.pop(context);
    }
  }
}
