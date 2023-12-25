// home_controller.dart

import 'package:flutter/material.dart';
import 'package:taskplus/services/user_data.dart';

class HomeController {
  final ScrollController scrollController = ScrollController();
  Map<String, dynamic> userData = {};

  HomeController() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    userData = await UserData.getUserData() ?? {};
    // print("User data loaded: $userData");
  }

  void dispose() {
    scrollController.dispose();
  }
}
