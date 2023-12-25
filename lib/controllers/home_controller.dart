// home_controller.dart

import 'package:flutter/material.dart';
import 'package:taskplus/services/subject_service.dart';
import 'package:taskplus/services/user_data.dart';

class HomeController {
  final ScrollController scrollController = ScrollController();
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>>? subjectData;
  final SubjectService _subjectService = SubjectService();

  HomeController() {
    _loadUserData();
    loadSubjectData();
  }

  Future<void> _loadUserData() async {
    userData = await UserData.getUserData() ?? {};
    // print("User data loaded: $userData");
  }

  Future<void> loadSubjectData() async {
    subjectData = await _subjectService.getSubjects();
    print("subjectData loaded: $subjectData");
  }

  void dispose() {
    scrollController.dispose();
  }
}
