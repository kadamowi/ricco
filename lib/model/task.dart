class Task {
  String id;
  int status;
  DateTime executed;
  String name;
  String author;
  String who;
  int changes;

  Task({
    required this.id,
    required this.status,
    required this.executed,
    required this.name,
    required this.author,
    required this.who,
    required this.changes,
  });

  factory Task.fromJson(Map<String, dynamic> parsedJson, String id) {
    return Task(
      id: id,
      status: parsedJson['Status'],
      executed: DateTime.parse(parsedJson['Data'].toDate().toString()),
      name: parsedJson['Tytuł'],
      author: parsedJson['Zlecający'],
      who: parsedJson['Wykonujący'],
      changes: 0,
    );
  }
}
