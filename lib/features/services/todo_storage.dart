import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/todo.dart';

class TodoStorage {
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todos.json');
  }

  Future<List<Todo>> readTodos() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      return todoFromJson(contents);
    } catch (e) {
      return [];
    }
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final file = await _localFile;
    await file.writeAsString(todoToJson(todos));
  }
}
