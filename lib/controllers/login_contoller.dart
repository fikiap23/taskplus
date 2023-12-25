// login_controller.dart

import 'package:flutter/material.dart';
// import 'package:taskplus/services/user_service.dart';

class LoginController {
  final FocusNode focusNodePassword = FocusNode();
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  bool obscurePassword = true;
  // final UserService _userService = UserService();

  void dispose() {
    focusNodePassword.dispose();
    controllerUsername.dispose();
    controllerPassword.dispose();
  }
}
