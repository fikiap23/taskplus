import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskplus/services/task_service.dart';
import 'update_task.dart';

class DetailTaskScreen extends StatefulWidget {
  final String subjectId;
  final String subjectName;
  final String teacher;
  final String taskId;
  final String title;
  final String description;
  final String deadline;
  final bool isCompleted; // New field for status

  DetailTaskScreen({
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
  _DetailTaskScreenState createState() => _DetailTaskScreenState();
}

class _DetailTaskScreenState extends State<DetailTaskScreen> {
  final TaskService _taskService = TaskService();
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    String formattedDeadline = _formatDeadline(widget.deadline);

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
              _buildDetailItem('Task Title', widget.title),
              _buildDetailItem('Subject', widget.subjectName),
              _buildDetailItemWithIcon(Icons.person, 'Teacher', widget.teacher),
              _buildDetailItemWithIcon(
                  Icons.description, 'Description', widget.description),
              _buildDetailItemWithIcon(
                  Icons.schedule, 'Deadline', formattedDeadline),
              _buildDetailItemWithIcon(
                  Icons.info,
                  'Status',
                  widget.isCompleted
                      ? 'Completed'
                      : 'Not Completed'), // Display the status with an icon
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(Icons.done, 'Done', Colors.green, () {
                    // Implement your logic for marking the task as done
                    // You can use this onPressed callback to update the task status
                  }, context),
                  _buildActionButton(Icons.update, 'Update', Colors.orange, () {
                    // Implement your logic for updating the task
                    // You can navigate to a form screen or show a modal bottom sheet for editing
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UpdateTask(
                          taskId: widget.taskId,
                          title: widget.title,
                          description: widget.description,
                          dueDate: widget.deadline,
                          subjectId: widget.subjectId);
                    }));
                  }, context),
                  _buildDeleteButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return _isDeleting
        ? CircularProgressIndicator() // Show loading indicator
        : _buildActionButton(Icons.delete, 'Delete', Colors.red, () async {
            // Implement your logic for deleting the task
            // You can use this onPressed callback to delete the task
            setState(() {
              _isDeleting = true;
            });

            bool result =
                await _taskService.deleteTask(widget.subjectId, widget.taskId);
            setState(() {
              _isDeleting = false;
            });

            if (result) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Task deleted successfully"),
              ));
              Navigator.pushNamedAndRemoveUntil(
                  context, '/tasks', (route) => false);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Failed to delete task"),
              ));
            }
          }, context);
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
              Icon(widget.isCompleted ? Icons.check_circle : Icons.cancel,
                  color: widget.isCompleted ? Colors.green : Colors.red),
            SizedBox(width: 8),
            Expanded(
              // Ensure the description takes up available space
              child: Text(
                value,
                style: TextStyle(fontSize: 18, color: Colors.black),
                overflow: TextOverflow
                    .ellipsis, // You can customize the overflow behavior
                maxLines: 1000, // You can customize the maximum number of lines
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color,
      VoidCallback onPressed, BuildContext context) {
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
