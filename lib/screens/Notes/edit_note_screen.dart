import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taskplus/common/constants/colors.dart';
import 'package:taskplus/services/notes_service.dart';

class EditNoteScreen extends StatefulWidget {
  final String? noteId;
  final String? title;
  final String? description;
  final Color? color;

  const EditNoteScreen({
    Key? key,
    this.noteId,
    this.title,
    this.description,
    this.color,
  }) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final NotesService _notesService = NotesService();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool isLoading = false;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.description ?? '');

    super.initState();
  }

  Future<void> _saveNote() async {
    final noteId = widget.noteId;
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (noteId == null || noteId.isEmpty) {
      // If noteId is empty or null, it means this is a new note, so create it
      setState(() {
        isLoading = true;
      });
      final result = await _notesService.createNote({
        'title': title,
        'description': description,
      });

      setState(() {
        isLoading = false;
      });

      if (result != null) {
        // Note created successfully
        Navigator.pushNamedAndRemoveUntil(context, '/notes', (route) => false);
      } else {
        // Handle error
        // Show an error message or take appropriate action
      }
    } else {
      setState(() {
        isLoading = true;
      });
      // If noteId is not empty, it means this is an existing note, so update it
      final result = await _notesService.updateNote(noteId, {
        'title': title,
        'description': description,
      });

      setState(() {
        isLoading = false;
      });

      if (result) {
        // Note updated successfully
        Navigator.pushNamedAndRemoveUntil(context, '/notes', (route) => false);
      } else {
        // Handle error
        // Show an error message or take appropriate action
      }
    }
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color ?? getRandomColor(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.all(0),
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [
                      TextField(
                        controller: _titleController,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 30),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 30),
                        ),
                      ),
                      Divider(color: Colors.blue, thickness: 1),
                      TextField(
                        controller: _descriptionController,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type something here',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNote,
        elevation: 10,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.save),
      ),
    );
  }
}
