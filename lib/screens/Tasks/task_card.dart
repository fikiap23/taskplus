import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskplus/services/subject_service.dart';

class TaskCard extends StatelessWidget {
  TaskCard({
    Key? key,
    required this.subjectName,
    required this.description,
    required this.subjectId,
    required this.deadline,
  }) : super(key: key);

  final String subjectId;
  final String subjectName;
  final String description;
  final String deadline; // Updated to String
  final SubjectService _subjectService = SubjectService();

  final List<IconData> randomIcons = [
    Icons.assignment,
    Icons.assignment_ind,
    Icons.assignment_late,
    Icons.assignment_turned_in,
    // Add more icons as needed
  ];

  final List<Color> randomColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    // Add more colors as needed
  ];

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final randomIcon = randomIcons[random.nextInt(randomIcons.length)];
    final randomColor = randomColors[random.nextInt(randomColors.length)];

    // Convert ISO 8601 string to DateTime
    DateTime parsedDeadline = DateTime.parse(deadline);

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Card(
        color: randomColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: randomColor,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Icon(randomIcon, color: Colors.white),
          ),
          title: Text(
            subjectName,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                maxLines: 3,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Deadline: ${DateFormat('MMM dd, yyyy HH:mm').format(parsedDeadline)}',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          trailing: _buildPopupMenuButton(context),
        ),
      ),
    );
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: Colors.grey),
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
          // TODO: Implement edit logic
        } else if (value == 1) {
          _showDeleteConfirmationDialog(context);
        }
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Delete Task'),
              content: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text('Are you sure you want to delete this task?'),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
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

                          // TODO: Implement logic to delete the task
                          bool deleteResult =
                              await _subjectService.deleteSubject(subjectId);

                          setState(() {
                            isLoading = false;
                          });

                          if (deleteResult) {
                            Navigator.of(context).pop();

                            // TODO: Navigate or update UI accordingly
                          } else {
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
