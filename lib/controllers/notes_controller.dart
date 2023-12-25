import 'dart:math';

import 'package:flutter/material.dart';

import 'package:taskplus/common/constants/colors.dart';
import 'package:taskplus/models/note_model.dart';
import 'package:taskplus/screens/Notes/edit_note_screen.dart';

class NotesController {
  List<NoteModel> filteredNotes = [];
  bool sorted = false;

  NotesController() {
    filteredNotes = sampleNotes;
  }

  List<NoteModel> sortNotesByModifiedTime(List<NoteModel> notes) {
    if (sorted) {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      notes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }

    sorted = !sorted;

    return notes;
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  void onSearchTextChanged(String searchText) {
    filteredNotes = sampleNotes
        .where((note) =>
            note.content.toLowerCase().contains(searchText.toLowerCase()) ||
            note.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  void deleteNote(int index) {
    NoteModel note = filteredNotes[index];
    sampleNotes.remove(note);
    filteredNotes.removeAt(index);
  }

  Future<void> editNote(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            EditScreen(note: filteredNotes[index]),
      ),
    );

    if (result != null) {
      int originalIndex = sampleNotes.indexOf(filteredNotes[index]);

      sampleNotes[originalIndex] = NoteModel(
        id: sampleNotes[originalIndex].id,
        title: result[0],
        content: result[1],
        modifiedTime: DateTime.now(),
      );

      filteredNotes[index] = NoteModel(
        id: filteredNotes[index].id,
        title: result[0],
        content: result[1],
        modifiedTime: DateTime.now(),
      );
    }
  }

  Future<void> addNote(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const EditScreen(),
      ),
    );

    if (result != null) {
      sampleNotes.add(NoteModel(
        id: sampleNotes.length,
        title: result[0],
        content: result[1],
        modifiedTime: DateTime.now(),
      ));
      filteredNotes = sampleNotes;
    }
  }

  Future<bool?> confirmDialog(BuildContext context) {
    return showDialog<bool>(
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
                onPressed: () {
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
    );
  }
}
