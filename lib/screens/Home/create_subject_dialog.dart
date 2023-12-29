import 'package:flutter/material.dart';
import 'package:taskplus/services/subject_service.dart';

class CreateSubjectDialog extends StatefulWidget {
  @override
  _CreateSubjectDialogState createState() => _CreateSubjectDialogState();
}

class _CreateSubjectDialogState extends State<CreateSubjectDialog> {
  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController teacherNameController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: const Color.fromARGB(255, 64, 124, 177),
        title:
            const Text('Create Subject', style: TextStyle(color: Colors.white)),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Subject Name:',
                  style: TextStyle(color: Colors.white)),
              TextField(
                controller: subjectNameController,
                decoration:
                    const InputDecoration(hintText: 'Enter subject name'),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text('Teacher:', style: TextStyle(color: Colors.white)),
              TextField(
                controller: teacherNameController,
                decoration:
                    const InputDecoration(hintText: 'Enter teacher name'),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    // Set loading to true to show the loading indicator
                    setState(() {
                      isLoading = true;
                    });

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

                    try {
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
                    } catch (error) {
                      print('Error creating subject: $error');
                      // Handle error, display an error message, or perform other actions
                    } finally {
                      // Set loading to false to hide the loading indicator
                      setState(() {
                        isLoading = false;
                      });
                    }

                    Navigator.of(context).pop();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  },
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  )
                : const Text('Create Subject'),
          ),
        ],
      ),
    );
  }
}
