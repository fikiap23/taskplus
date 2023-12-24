class User {
  String id;
  String name;
  String username;
  String email;
  String password;
  String profilePic;
  List<Subject> subjects;
  List<Note> notes;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.profilePic,
    required this.subjects,
    required this.notes,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      profilePic: json['profilePic'],
      subjects: (json['subjects'] as List<dynamic>)
          .map((subject) => Subject.fromJson(subject))
          .toList(),
      notes: (json['notes'] as List<dynamic>)
          .map((note) => Note.fromJson(note))
          .toList(),
    );
  }
}

class Subject {
  String name;
  String dosen;
  String typeSubject;
  List<Task> tasks;
  List<Note> notes;

  Subject({
    required this.name,
    required this.dosen,
    required this.typeSubject,
    required this.tasks,
    required this.notes,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      dosen: json['dosen'],
      typeSubject: json['type_subject'],
      tasks: (json['tasks'] as List<dynamic>)
          .map((task) => Task.fromJson(task))
          .toList(),
      notes: (json['notes'] as List<dynamic>)
          .map((note) => Note.fromJson(note))
          .toList(),
    );
  }
}

class Task {
  String title;
  String description;
  String type;
  String subjectName;
  DateTime dueDate;
  bool completed;

  Task({
    required this.title,
    required this.description,
    required this.type,
    required this.subjectName,
    required this.dueDate,
    required this.completed,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      type: json['type'],
      subjectName: json['subjectName'],
      dueDate: DateTime.parse(json['dueDate']),
      completed: json['completed'],
    );
  }
}

class Note {
  String title;
  String content;
  String subject;

  Note({
    required this.title,
    required this.content,
    required this.subject,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'],
      content: json['content'],
      subject: json['subject'],
    );
  }
}
