import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:taskplus/screens/AddNewTask/add_new_task_screeen.dart';
import 'package:taskplus/common/widgets/drawer_menu.dart';
import 'package:taskplus/screens/Tasks/TaskListWidget.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  DateTime _selectedDate = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool isDatePickerEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  void _onDateChange(DateTime date) {
    setState(() {
      _selectedDate = date;
      formattedDate = DateFormat('yyyy-MM-dd').format(date);
      isDatePickerEnabled = true;
    });
  }

  // Function to show all tasks
  void _showAllTasks() {
    setState(() {
      formattedDate = '';
      isDatePickerEnabled = false; // Disable DatePicker
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TaskPlus")),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(242, 244, 255, 1),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My tasks',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${DateFormat('MMM, d').format(_selectedDate)}',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddNewTask(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  Text(
                                    "Add task",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      DatePicker(
                        DateTime.now(),
                        initialSelectedDate: _selectedDate,
                        selectionColor:
                            isDatePickerEnabled ? Colors.blue : Colors.grey,
                        onDateChange: _onDateChange,
                        height: 90,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _showAllTasks,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      child: Text('Show All Tasks'),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 25),
                  child: TaskListWidget(filterDate: formattedDate),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
