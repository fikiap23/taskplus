import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskplus/common/constants/colors.dart';
import 'package:taskplus/screens/Notes/edit_note_screen.dart';
import 'package:taskplus/common/widgets/drawer_menu.dart';
import 'package:taskplus/services/notes_service.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NotesService _notesService = NotesService();
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>>? sampleNotes = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget initializes
  }

  Future<void> fetchData() async {
    sampleNotes = await _notesService.getNotes();
    sampleNotes ??= [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TaskPlus")),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              style: const TextStyle(fontSize: 16, color: Colors.white),
              controller: searchController,
              onChanged: (query) {
                // Trigger search when the text in the TextField changes
                _performSearch(query);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: "Search notes...",
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                fillColor: Colors.blue,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                future: searchController.text.isEmpty
                    ? _notesService.getNotes()
                    : _notesService.searchNotes(searchController.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null ||
                      (snapshot.data as List).isEmpty) {
                    return const Center(child: Text('No notes available.'));
                  } else {
                    // Data has been fetched successfully
                    sampleNotes = snapshot.data;
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 30),
                      itemCount: sampleNotes!.length,
                      itemBuilder: (context, index) {
                        // print(sampleNotes![index]);
                        Color bgColor = getRandomColor();
                        return Card(
                          margin: const EdgeInsets.only(bottom: 20),
                          color: bgColor,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              onTap: () async {
                                // Handle onTap
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditNoteScreen(
                                            color: bgColor,
                                            noteId: sampleNotes![index]['_id'],
                                            title: sampleNotes![index]['title'],
                                            description: sampleNotes![index]
                                                ['description'])));
                              },
                              title: RichText(
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: "${sampleNotes![index]['title']}\n",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    height: 1.5,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          "${sampleNotes![index]['description']} ",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Edited: ${_formatTime(sampleNotes![index]['updatedAt'])}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  // Handle delete
                                  confirmDialog(
                                      context, sampleNotes![index]['_id']);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const EditNoteScreen(),
            ),
          );
        },
        elevation: 10,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          size: 38,
        ),
      ),
    );
  }

  void _performSearch(String query) async {
    // Trigger the search with the provided query
    sampleNotes = await _notesService.searchNotes(query);
    setState(() {
      // Use setState to rebuild the UI when the search query changes
      // sampleNotes = await _notesService.searchNotes(query);
    });
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  String _formatTime(String time) {
    DateTime parsedTime = DateTime.parse(time);
    return DateFormat('yyyy-MM-dd HH:mm').format(parsedTime);
  }

  Future<void> confirmDialog(BuildContext context, String noteId) async {
    bool confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade900,
              icon: const Icon(
                Icons.info,
                color: Colors.grey,
              ),
              title: const Text(
                'Are you sure you want to delete?',
                style: TextStyle(color: Colors.white),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const SizedBox(
                      width: 60,
                      child: Text(
                        'Yes',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const SizedBox(
                      width: 60,
                      child: Text(
                        'No',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ) ??
        false;

    if (confirm) {
      // User confirmed, initiate the delete operation
      await _deleteNoteAndNavigate(context, noteId);
    }
  }

  Future<void> _deleteNoteAndNavigate(
      BuildContext context, String noteId) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        barrierDismissible: false,
      );

      // Perform the delete operation
      await _notesService.deleteNote(noteId);

      // Hide loading indicator
      Navigator.pop(context);

      // Navigate back to the notes screen
      Navigator.pushNamedAndRemoveUntil(context, '/notes', (route) => false);
      print("Note deleted successfully");
    } catch (error) {
      // Handle error
      // You can display an error message or take appropriate action
      print("Error deleting note: $error");

      // Hide loading indicator
      Navigator.pop(context);
    }
  }
}
