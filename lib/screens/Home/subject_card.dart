import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskplus/screens/Home/edit_subject_dialog.dart';
import 'package:taskplus/services/subject_service.dart';

class SubjectCard extends StatelessWidget {
  SubjectCard(
      {Key? key,
      required this.subjectName,
      required this.teacher,
      required this.subjectId})
      : super(key: key);

  final String subjectId;
  final String subjectName;
  final String teacher;
  final SubjectService _subjectService = SubjectService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: 70,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 123, 0, 245),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: const Icon(Icons.assignment, color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      subjectName,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      teacher,
                      style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                Expanded(child: Container()),
                _buildPopupMenuButton(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: Colors.grey), // Three-dot icon
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 0,
          child: Text('Edit'),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Text('Delete'),
        ),
      ],
      onSelected: (value) {
        if (value == 0) {
          // Show EditSubjectDialog when "Edit" is selected
          showDialog(
            context: context,
            builder: (context) => EditSubjectDialog(
                subjectId: subjectId,
                subjectName: subjectName,
                teacher: teacher),
          );
        } else if (value == 1) {
          _showDeleteConfirmationDialog(context);
        }
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    bool isLoading = false; // Track loading state

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Delete Subject'),
              content: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text('Are you sure you want to delete this subject?'),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          // Set loading to true to show the loading indicator
                          setState(() {
                            isLoading = true;
                          });

                          // TODO: Implement logic to delete the subject
                          bool deleteResult =
                              await _subjectService.deleteSubject(subjectId);

                          // Set loading to false to hide the loading indicator
                          setState(() {
                            isLoading = false;
                          });

                          if (deleteResult) {
                            // Delete successful
                            Navigator.of(context).pop();

                            Navigator.pushNamedAndRemoveUntil(
                                context, '/home', (route) => false);
                          } else {
                            // Delete failed
                            // Optionally, show an error message or handle the failure
                          }
                        },
                  child: Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
