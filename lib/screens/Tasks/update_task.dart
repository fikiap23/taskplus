import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskplus/screens/AddNewTask/SubjectList.dart';
import 'package:taskplus/services/task_service.dart';

class UpdateTask extends StatefulWidget {
  final String taskId;
  final String title;
  final String description;
  final String dueDate;
  final String subjectId;

  const UpdateTask({
    Key? key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.subjectId,
  }) : super(key: key);

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  bool isUpdatingTask = false;

  final TaskService _taskService = TaskService();

  DateTime selectedDate = DateTime.now();
  String selectedSubjectId = '';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    selectedDate = DateTime.parse(widget.dueDate); // Use widget.dueDate
    _dateController = TextEditingController(
      text: '${DateFormat('EEE, MMM d, ' 'yy').format(selectedDate)}',
    );
    _timeController = TextEditingController(
      text: '${DateFormat.Hm().format(selectedDate)}',
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2005),
      lastDate: DateTime(2030),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        _dateController.text =
            '${DateFormat('EEE, MMM d, ' 'yy').format(selected)}';
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        _timeController.text = _formatTime(result);
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    String formattedTime = DateFormat('HH:mm:ss').format(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          time.hour, time.minute),
    );

    return formattedTime;
  }

  TimeOfDay _getTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute =
        int.parse(parts[1].substring(0, 2)); // Removing AM/PM if present
    return TimeOfDay(hour: hour, minute: minute);
  }

  String combineDateAndTime(DateTime date, TimeOfDay time) {
    DateTime combinedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return combinedDateTime.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    final SubjectListWidget subjectListWidget = SubjectListWidget(
      onSubjectSelected: (String subject) {
        setState(() {
          selectedSubjectId = subject;
        });
      },
    );
    return Material(
      child: SafeArea(
        child: Container(
          color: const Color.fromRGBO(130, 0, 255, 1),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back,
                            size: 30, color: Colors.white),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Text(
                        "Update Task",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: _titleController,
                    cursorColor: Colors.white,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    minLines: 3, // Specify the minimum number of lines to show
                    maxLines:
                        null, // Set maxLines to null for an unlimited number of lines
                    cursorColor: Colors.white,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: _dateController,
                    cursorColor: Colors.white,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Due Date",
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                      ),
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: _timeController,
                    cursorColor: Colors.white,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Time",
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: const Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                      ),
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      String combinedDateTime = combineDateAndTime(
                          selectedDate, _getTimeOfDay(_timeController.text));
                      Map<String, dynamic> updatedData = {
                        'title': _titleController.text,
                        'description': _descriptionController.text,
                        'dueDate': combinedDateTime,
                        // Add other task details as needed
                      };

                      try {
                        setState(() {
                          isUpdatingTask = true;
                        });
                        bool result = await _taskService.updateTask(
                            widget.taskId, widget.subjectId, updatedData);

                        if (result) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Task updated successfully"),
                          ));
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/tasks', (route) => false);
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Failed to update task"),
                          ));
                        }
                      } finally {
                        setState(() {
                          isUpdatingTask = false;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromRGBO(130, 0, 255, 1),
                      ),
                      alignment: Alignment.center,
                      child: isUpdatingTask
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              "Update Task",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
