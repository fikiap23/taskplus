class NoteModel {
  int id;
  String title;
  String description;
  DateTime modifiedTime;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.modifiedTime,
  });
}
