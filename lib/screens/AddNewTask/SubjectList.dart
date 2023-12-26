import 'package:flutter/material.dart';
import 'package:taskplus/screens/AddNewTask/category_card.dart';
import 'package:taskplus/services/subject_service.dart';

class SubjectListWidget extends StatefulWidget {
  SubjectListWidget({super.key});

  @override
  State<SubjectListWidget> createState() => _SubjectListWidgetState();
}

class _SubjectListWidgetState extends State<SubjectListWidget> {
  final SubjectService _subjectService = SubjectService();
  String _selectedSubject = '';
  _setSelectSubject(String selectSubject) {
    this.setState(() {
      this._selectedSubject = selectSubject;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _subjectService.getAllNameSubjects(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>> subjectList =
              (snapshot.data as List<dynamic>).cast<Map<String, dynamic>>();

          return Wrap(
            alignment: WrapAlignment.spaceEvenly,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: subjectList.map((subject) {
              String subjectName = subject['subjectName'].toString();
              return GestureDetector(
                onTap: () {
                  _setSelectSubject(subjectName);
                  // You can perform any additional actions here
                },
                child: Categorcard(
                  CategoryText: subjectName,
                  isActive: _selectedSubject == subjectName,
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
