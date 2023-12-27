import 'package:flutter/material.dart';

class DetailTaskScreen extends StatelessWidget {
  final String subjectId;
  final String subjectName;
  final String description;
  final String deadline;

  const DetailTaskScreen({
    Key? key,
    required this.subjectId,
    required this.subjectName,
    required this.description,
    required this.deadline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Task Details', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Subject ID', subjectId),
            _buildDetailItem('Subject Name', subjectName),
            _buildDetailItem('Description', description),
            _buildDetailItem('Deadline', deadline),
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
    );
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
