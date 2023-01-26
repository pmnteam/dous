class DoUsColumns {
  // Heleper Attributes for inserting column names
  static const String id = 'id';
  static const String username = 'usernameColumn';
  static const String title = 'titleColumn';
  static const String created = 'createdColumn';
  static const String dueDate = 'dueDateColumn';
  static const String done = 'doneColumn';
  static const String important = 'importantColumn';
}

class DoUsTask {
  // Table Name
  static const String dousTable = 'dous';

  final int? id;
  final String userName;
  final String title;
  final DateTime created;
  final DateTime dueDate;
  bool done;
  bool important;

  DoUsTask({
    this.id,
    required this.userName,
    required this.title,
    required this.created,
    required this.dueDate,
    this.done = false,
    this.important = false,
  });

  // This will convert our data model to a map
  // that is suitable for creating a database table
  Map<String, dynamic> toMap() {
    return {
      DoUsColumns.username: userName,
      // Task title
      DoUsColumns.title: title,
      // sqflite doesn't not accepet booleans
      DoUsColumns.done: done ? 1 : 0,
      DoUsColumns.important: important ? 1 : 0,
      // Convert time to suitable format
      DoUsColumns.created: created.toIso8601String(),
      DoUsColumns.dueDate: dueDate.toIso8601String(),
    };
  }

  // This will convert a map from database to a DoUsTask
  static DoUsTask fromMap(Map<String, dynamic> map) {
    return DoUsTask(
      id: map[DoUsColumns.id] as int,
      userName: map[DoUsColumns.username] as String,
      title: map[DoUsColumns.title] as String,
      done: map[DoUsColumns.done] == 1 ? true : false,
      important: map[DoUsColumns.important] == 1 ? true : false,
      created: DateTime.parse(map[DoUsColumns.created].toString()),
      dueDate: DateTime.parse(map[DoUsColumns.dueDate].toString()),
    );
  }
}
