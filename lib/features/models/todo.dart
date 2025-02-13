import 'dart:convert';

class Todo {
  String title;
  bool isCompleted;

  Todo({required this.title, this.isCompleted = false});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}

List<Todo> todoFromJson(String str) =>
    List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
