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

List<NoteModel> sampleNotes = [
  NoteModel(
    id: 0,
    title: 'Tugas PAM',
    content: 'Bikin aplikasi menggunakan flutter, kemudian deploy ke playstore',
    modifiedTime: DateTime(2022, 1, 1, 3, 45),
  ),
  NoteModel(
    id: 1,
    title: 'Tugas Database',
    content: 'Desain dan implementasikan skema database untuk proyek',
    modifiedTime: DateTime(2022, 1, 2, 9, 30),
  ),
  NoteModel(
    id: 2,
    title: 'Tugas UI/UX',
    content: 'Rancang antarmuka pengguna yang menarik dan responsif',
    modifiedTime: DateTime(2022, 1, 3, 12, 15),
  ),
  NoteModel(
    id: 3,
    title: 'Tugas Testing',
    content:
        'Bangun dan jalankan rangkaian uji untuk memastikan aplikasi berfungsi dengan baik',
    modifiedTime: DateTime(2022, 1, 4, 14, 0),
  ),
  NoteModel(
    id: 4,
    title: 'Tugas Dokumentasi',
    content: 'Dokumentasikan setiap bagian dari proyek secara lengkap',
    modifiedTime: DateTime(2022, 1, 5, 16, 45),
  ),
];
