import 'package:flutter/material.dart';
import 'package:taskplus/screens/Tasks/task_card.dart';
import 'package:taskplus/services/task_service.dart';

import 'detail_task_screen.dart';

class TaskListWidget extends StatefulWidget {
  final String? filterDate;

  TaskListWidget({this.filterDate});

  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  final TaskService _taskService = TaskService();

  Future<List<Map<String, dynamic>>?> _fetchData() async {
    if (widget.filterDate != null) {
      print('filterDate: ${widget.filterDate}');
      return await _taskService.getTasks(filterDate: widget.filterDate);
    } else {
      return await _taskService.getTasks();
    }
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

          if (taskDataList.isEmpty) {
            // Display a message when there are no tasks for the given date
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text('No tasks for the selected date.',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: taskDataList.map((taskData) {
              final subjectData = taskData['subjectData'];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailTaskScreen(
                        subjectId: subjectData['subjectId'],
                        subjectName: subjectData['subjectName'],
                        teacher: subjectData['dosen'],
                        description: taskData['description'],
                        deadline: taskData['dueDate'],
                        title: taskData['title'],
                        taskId: taskData['_id'],
                        isCompleted: taskData['completed'],
                      ),
                    ),
                  );
                },
                child: TaskCard(
                  subjectId: subjectData['subjectId'],
                  subjectName: taskData['title'],
                  description: taskData['description'],
                  deadline: taskData['dueDate'],
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
