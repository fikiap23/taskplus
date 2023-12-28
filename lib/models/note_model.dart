class NoteModel {
  int id;
  String title;
  String content;
  DateTime modifiedTime;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
  });
}
