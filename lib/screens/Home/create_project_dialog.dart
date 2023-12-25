// create_project_dialog.dart

import 'package:flutter/material.dart';

class CreateProjectDialog extends StatelessWidget {
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Create Project'),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Project Name:'),
              TextField(
                controller: projectNameController,
                decoration: InputDecoration(hintText: 'Enter project name'),
              ),
              SizedBox(height: 16),
              Text('Description:'),
              TextField(
                controller: projectDescriptionController,
                decoration:
                    InputDecoration(hintText: 'Enter project description'),
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
            onPressed: () {
              // Implement your logic for creating the project
              String projectName = projectNameController.text;
              String projectDescription = projectDescriptionController.text;

              // Process the project details as needed
              print('Project Name: $projectName');
              print('Description: $projectDescription');

              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Create Project'),
          ),
        ],
      ),
    );
  }
}
