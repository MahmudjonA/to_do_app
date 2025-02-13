import 'package:flutter/material.dart';
import 'package:to_do/features/services/todo_storage.dart';
import 'models/todo.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoStorage _storage = TodoStorage();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await _storage.readTodos();
    setState(() {
      _todos = todos;
    });
  }

  Future<void> _addTodo(String title) async {
    setState(() {
      _todos.add(Todo(title: title));
    });
    await _storage.saveTodos(_todos);
  }

  Future<void> _toggleTodo(int index) async {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
    await _storage.saveTodos(_todos);
  }

  Future<void> _deleteTodo(int index) async {
    setState(() {
      _todos.removeAt(index);
    });
    await _storage.saveTodos(_todos);
  }

  void _showAddTodoDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Todo', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter todo...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addTodo(controller.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Todo List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (context, index) {
            final todo = _todos[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                leading: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Checkbox(
                    key: ValueKey(todo.isCompleted),
                    value: todo.isCompleted,
                    onChanged: (_) => _toggleTodo(index),
                    shape: const CircleBorder(),
                    activeColor: Colors.green,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTodo(index),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: Colors.purpleAccent,
        shape: const CircleBorder(),
        elevation: 10,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
