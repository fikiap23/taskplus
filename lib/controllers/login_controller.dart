// login_controller.dart

import 'package:flutter/material.dart';
import 'package:taskplus/screens/Home/home_screen.dart';
import 'package:taskplus/services/user_service.dart';
import 'package:taskplus/services/user_data.dart';
import 'package:taskplus/common/widgets/loader.dart';

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
    showDialog(
      context: context,
      barrierDismissible: false, // Disallow tapping outside the dialog to close
      builder: (context) => const Loader(), // Show loading indicator
    );

    final requestData = {
      "identifier": controllerIdentifier.text,
      "password": controllerPassword.text,
    };

    try {
      final response = await _userService.login(requestData);
      if (response != null) {
        // Successful login
        print('Login successful: $response');

        // Save user data to SharedPreferences
        await UserData.saveUserData(response);

        // Close loading indicator
        Navigator.pop(context);

        // Navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const HomeScreen();
            },
          ),
        );
      } else {
        // Handle error
        print('Login failed');

        // Close loading indicator
        Navigator.pop(context);
      }
    } catch (error) {
      print('Error during login request: $error');

      // Close loading indicator
      Navigator.pop(context);
    }
  }
}
