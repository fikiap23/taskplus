import 'package:flutter/material.dart';
import 'package:taskplus/services/subject_service.dart';
// Sesuaikan dengan path yang sesuai

class CreateProjectDialog extends StatelessWidget {
  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController teacherNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Create Subject'),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Subject Name:'),
              TextField(
                controller: subjectNameController,
                decoration: InputDecoration(hintText: 'Enter subject name'),
              ),
              SizedBox(height: 16),
              Text('Teacher:'),
              TextField(
                controller: teacherNameController,
                decoration: InputDecoration(hintText: 'Enter teacher name'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Implement your logic for creating the subject
              String subjectName = subjectNameController.text;
              String teacherName = teacherNameController.text;

              // Create a map with subject details
              Map<String, dynamic> subjectData = {
                'name': subjectName,
                'dosen': teacherName,
                // Add other subject details as needed
              };

              // Create an instance of SubjectService
              SubjectService subjectService = SubjectService();

              // Call the createSubject method
              Map<String, dynamic>? result =
                  await subjectService.createSubject(subjectData);

              if (result != null) {
                // Successful subject creation
                print('Subject created successfully: $result');
                // Perform any additional actions or update UI as needed
              } else {
                // Handle subject creation failure
                print('Subject creation failed');
                // Display an error message or perform other actions
              }

              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Create Subject'),
          ),
        ],
      ),
    );
  }
}
