import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/todo_list_tile.dart';
import 'package:todolist/todo_model.dart';
import 'custom_floating_action_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _todoBox = Hive.box<TodoModel>('todos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Todo List'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: _todoBox.listenable(),
        builder: (context, Box<TodoModel> box, _) {
          if (box.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final todo = box.getAt(index)!;
                  return TodoListTile(
                    todo: todo,
                    index: index,
                    onDelete: _deleteTodo,
                    onUpdate: _updateTodo,
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text("Press the \"+\" button to add a todo."),
            );
          }
        },
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: _addTodo,
      ),
    );
  }

  void _addTodo(String description) {
    final todo = TodoModel(description: description);
    _todoBox.add(todo);
  }

  void _deleteTodo(int index) {
    _todoBox.deleteAt(index);
  }

  void _updateTodo(int index, String newDescription, bool newIsDone, DateTime? newDueDateTime) {
    final updatedTodo = TodoModel(
      description: newDescription,
      isDone: newIsDone,
      dueDateTime: newDueDateTime,
    );
    _todoBox.putAt(index, updatedTodo);
  }
}