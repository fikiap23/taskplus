import 'package:flutter/material.dart';
import 'package:taskplus/screens/AddNewTask/add_new_task_screeen.dart';
import 'package:taskplus/screens/Tasks/detail_task_screen.dart';
import 'package:taskplus/screens/Tasks/task_card.dart';
import 'package:taskplus/services/task_service.dart';

class TaskSubjectList extends StatefulWidget {
  final String subjectID;

  TaskSubjectList({required this.subjectID});

  @override
  _TaskSubjectListState createState() => _TaskSubjectListState();
}

class _TaskSubjectListState extends State<TaskSubjectList> {
  final TaskService _taskService = TaskService();

  Future<List<Map<String, dynamic>>?> _fetchData() async {
    try {
      return await _taskService.getTasksBySubject(subjectId: widget.subjectID);
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> taskDataList = snapshot.data ?? [];

            if (taskDataList.isEmpty) {
              return Center(
                child: Text(
                  'No tasks for this subject.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subject: ${taskDataList[0]['subjectData']['subjectName']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Teacher: ${taskDataList[0]['subjectData']['dosen']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: taskDataList.length,
                    itemBuilder: (context, index) {
                      final taskData = taskDataList[index];
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
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTask(),
            ),
          );
        },
        tooltip: 'Create Subject',
        child: Icon(Icons.add),
      ),
    );
  }
}
