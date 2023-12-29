import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskplus/screens/AddNewTask/SubjectList.dart';
import 'package:taskplus/services/notif_service.dart';
import 'package:taskplus/services/task_service.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({Key? key}) : super(key: key);

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  late TextEditingController _Titlecontroller;
  late TextEditingController _DescriptionController;
  late TextEditingController _Datecontroller;
  late TextEditingController _Time;
  bool isCreatingTask = false;
  final TaskService _taskService = TaskService();
  ReminderFrequency frequency = ReminderFrequency.minute;
  int interval = 1;

  String selectedValue = '1 menit';
  List<String> options = [
    '1 menit',
    '1 jam',
    '3 jam',
    '6 jam',
    '12 jam',
    '1 hari',
    '2 hari'
  ];

  DateTime SelectedDate = DateTime.now();
  String selectedSubjectId = '';

  @override
  void initState() {
    super.initState();
    // listenToNotifications();
    _Titlecontroller = TextEditingController();
    _DescriptionController = TextEditingController();
    _Datecontroller = TextEditingController(
        text: '${DateFormat('EEE, MMM d, ' 'yy').format(this.SelectedDate)}');
    // Menggunakan format 24 jam
    _Time = TextEditingController(
      text: '${DateFormat.Hm().format(DateTime.now())}',
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: SelectedDate,
      firstDate: DateTime(2005),
      lastDate: DateTime(2030),
    );
    if (selected != null && selected != SelectedDate) {
      setState(() {
        SelectedDate = selected;
        _Datecontroller.text =
            '${DateFormat('EEE, MMM d, ' 'yy').format(selected)}';
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        _Time.text = _formatTime(result);
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    // Format waktu menjadi "HH:mm:ss"
    String formattedTime = DateFormat('HH:mm:ss').format(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          time.hour, time.minute),
    );

    return formattedTime;
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

  DateTime combineDateAndTimeForNotification(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  TimeOfDay _getTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute =
        int.parse(parts[1].substring(0, 2)); // Removing AM/PM if present
    return TimeOfDay(hour: hour, minute: minute);
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
          color: Colors.blue,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
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
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        "Create New Task",
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
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: TextFormField(
                    controller: _Titlecontroller,
                    cursorColor: Colors.white,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      labelText: "Title",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: Colors.white,
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: TextFormField(
                    controller: _Datecontroller,
                    cursorColor: Colors.white,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Dateline",
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: Colors.white,
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: TextField(
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    readOnly: true,
                    controller: _Time,
                    decoration: InputDecoration(
                      labelText: "Time",
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: Icon(
                          Icons.alarm,
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: Colors.white,
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: TextFormField(
                    controller: _DescriptionController,
                    keyboardType: TextInputType.multiline,
                    minLines: 1, // Specify the minimum number of lines to show
                    maxLines:
                        null, // Set maxLines to null for an unlimited number of lines
                    cursorColor: Colors.white,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      labelText: "Description",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: Colors.white,
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.white30,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Reminder me every:',
                        style: TextStyle(
                            color: Colors.white), // warna teks untuk label
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        value: selectedValue,
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue = newValue!;

                            switch (selectedValue) {
                              case '1 menit':
                                frequency = ReminderFrequency.minute;
                                interval = 1;
                                break;
                              case '1 jam':
                                frequency = ReminderFrequency.hour;
                                interval = 1;
                                break;
                              case '3 jam':
                                frequency = ReminderFrequency.hour;
                                interval = 3;
                                break;
                              case '6 jam':
                                frequency = ReminderFrequency.hour;
                                interval = 6;
                                break;
                              case '12 jam':
                                frequency = ReminderFrequency.hour;
                                interval = 12;
                                break;
                              case '1 hari':
                                frequency = ReminderFrequency.day;
                                interval = 1;
                                break;
                              case '2 hari':
                                frequency = ReminderFrequency.day;
                                interval = 2;
                                break;
                              default:
                                break;
                            }
                          });
                        },
                        items: options
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: Colors
                                      .white), // warna teks untuk opsi dropdown
                            ),
                          );
                        }).toList(),
                        style: TextStyle(
                            color: Colors
                                .white), // warna teks untuk teks terpilih dropdown
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Opsi yang dipilih: $selectedValue',
                        style: TextStyle(
                            color: Colors.white), // warna teks untuk teks hasil
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Task Category",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 20,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            subjectListWidget,
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          String combinedDateTime = combineDateAndTime(
                              SelectedDate, _getTimeOfDay(_Time.text));

                          DateTime combinedDateTimeForNoti =
                              combineDateAndTimeForNotification(
                                  SelectedDate, _getTimeOfDay(_Time.text));

                          // Create a map with task details
                          Map<String, dynamic> taskData = {
                            'title': _Titlecontroller.text,
                            'description': _DescriptionController.text,
                            'dueDate': combinedDateTime,
                            // Add other task details as needed
                          };

                          // Set the loading state to true
                          setState(() {
                            isCreatingTask = true;
                          });

                          try {
                            // Call the createTask method
                            Map<String, dynamic>? response = await _taskService
                                .createTask(taskData, selectedSubjectId);

                            // Map<String, dynamic>? response = null;
                            // print(frequency);
                            // print(interval);

                            if (response != null) {
                              LocalNotifications.scheduleNotification(
                                title: taskData['title'],
                                body: taskData['description'],
                                payload: taskData['dueDate'],
                                deadline: combinedDateTimeForNoti,
                                frequency:
                                    frequency, // Atur frekuensi pengingat
                                interval: interval, // Atur interval pengingat
                              );
                              // print(response);
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/tasks', (route) => false);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Failed to create task"),
                              ));
                            }
                          } finally {
                            // Set the loading state to false, whether the task creation succeeds or fails
                            setState(() {
                              isCreatingTask = false;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                          ),
                          alignment: Alignment.center,
                          child: isCreatingTask
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  "Create Task",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                        ),
                      )
                    ],
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
