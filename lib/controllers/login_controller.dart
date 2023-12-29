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
        // Save user data to SharedPreferences
        await UserData.saveUserData(response);

        // Close loading indicator
        // ignore: use_build_context_synchronously
        Navigator.pop(context);

        // Navigate to the home screen
        // ignore: use_build_context_synchronously
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
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Login failed. Please check your credentials.',
            ),
          ),
        );

        // Close loading indicator
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (error) {
      print('Error during login request: $error');

      // Close loading indicator
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }
}
