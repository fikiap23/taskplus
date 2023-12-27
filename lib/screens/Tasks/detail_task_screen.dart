import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'update_task.dart';

class DetailTaskScreen extends StatelessWidget {
  final String subjectId;
  final String subjectName;
  final String teacher;
  final String taskId;
  final String title;
  final String description;
  final String deadline;
  final bool isCompleted; // New field for status

  const DetailTaskScreen({
    Key? key,
    required this.subjectId,
    required this.subjectName,
    required this.description,
    required this.deadline,
    required this.title,
    required this.taskId,
    required this.teacher,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDeadline = _formatDeadline(deadline);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Task Details', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Task Title', title),
              _buildDetailItem('Subject', subjectName),
              _buildDetailItemWithIcon(Icons.person, 'Teacher', teacher),
              _buildDetailItemWithIcon(
                  Icons.description, 'Description', description),
              _buildDetailItemWithIcon(
                  Icons.schedule, 'Deadline', formattedDeadline),
              _buildDetailItemWithIcon(
                  Icons.info,
                  'Status',
                  isCompleted
                      ? 'Completed'
                      : 'Not Completed'), // Display the status with an icon
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(Icons.done, 'Done', Colors.green, () {
                    // Implement your logic for marking the task as done
                    // You can use this onPressed callback to update the task status
                  }),
                  _buildActionButton(Icons.update, 'Update', Colors.orange, () {
                    // Implement your logic for updating the task
                    // You can navigate to a form screen or show a modal bottom sheet for editing
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UpdateTask(
                          taskId: taskId,
                          title: title,
                          description: description,
                          dueDate: deadline,
                          subjectId: subjectId);
                    }));
                  }),
                  _buildActionButton(Icons.delete, 'Delete', Colors.red, () {
                    // Implement your logic for deleting the task
                    // You can show a confirmation dialog before deletion
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDeadline(String deadline) {
    DateTime parsedDeadline = DateTime.parse(deadline);
    return DateFormat('yyyy-MM-dd HH:mm').format(parsedDeadline);
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDetailItemWithIcon(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blueGrey),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          children: [
            if (icon == Icons.info) // Display status with an icon
              Icon(isCompleted ? Icons.check_circle : Icons.cancel,
                  color: isCompleted ? Colors.green : Colors.red),
            SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: color,
          ),
          icon: Icon(icon, color: Colors.white),
          label: Text(label, style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
