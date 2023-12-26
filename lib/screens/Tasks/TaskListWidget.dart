import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskplus/screens/Home/subject_card.dart';
import 'package:taskplus/screens/Tasks/task_card.dart';
import 'package:taskplus/services/task_service.dart';

class TaskListWidget extends StatefulWidget {
  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  final TaskService _taskService = TaskService();

  Future<List<Map<String, dynamic>>?> _fetchData() async {
    return await _taskService.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>> taskDataList = snapshot.data ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: taskDataList.map((taskData) {
              print(taskData);
              final subjectData = taskData['subjectData'];
              return TaskCard(
                subjectId: subjectData['subjectId'],
                subjectName: taskData['title'],
                description: taskData['description'],
                deadline: taskData['dueDate'],
                // // You can customize the remaining fields based on your needs
                // title: taskData['title'],
                // description: taskData['description'],
                // dueDate: taskData['dueDate'],
                // completed: taskData['completed'],
              );
            }).toList(),
          );
        }
      },
    );
  }
}
