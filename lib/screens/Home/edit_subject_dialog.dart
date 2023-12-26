import 'package:flutter/material.dart';
import 'package:taskplus/services/subject_service.dart';

class EditSubjectDialog extends StatefulWidget {
  final String subjectId;
  final String subjectName;
  final String teacher;

  EditSubjectDialog(
      {required this.subjectId,
      required this.subjectName,
      required this.teacher});

  @override
  _EditSubjectDialogState createState() => _EditSubjectDialogState();
}

class _EditSubjectDialogState extends State<EditSubjectDialog> {
  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController teacherNameController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    subjectNameController.text = widget.subjectName;
    teacherNameController.text = widget.teacher;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Edit Subject'),
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
              // Add other fields as needed
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
            onPressed: isLoading
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });

                    String subjectName = subjectNameController.text;
                    String teacherName = teacherNameController.text;

                    Map<String, dynamic> updatedSubjectData = {
                      'name': subjectName,
                      'dosen': teacherName,
                      // Add other updated subject details as needed
                    };

                    SubjectService subjectService = SubjectService();

                    try {
                      // Call the updateSubject method
                      bool success = await subjectService.updateSubject(
                          widget.subjectId, updatedSubjectData);

                      if (success) {
                        print('Subject updated successfully');
                        // Perform any additional actions or update UI as needed
                      } else {
                        print('Subject update failed');
                        // Handle subject update failure
                      }
                    } catch (error) {
                      print('Error updating subject: $error');
                      // Handle error, display an error message, or perform other actions
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }

                    Navigator.of(context).pop();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  },
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  )
                : Text('Update Subject'),
          ),
        ],
      ),
    );
  }
}
