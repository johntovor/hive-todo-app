import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'todo_item.dart';
import 'todo_service.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoItemAdapter());
  runApp(const MyApp());
}

final _todoService = TodoService();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App With Hive',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _todoService.getItems(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TodoItem>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return TodoListPage();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoListPage extends StatelessWidget {
  TodoListPage({Key? key}) : super(key: key);
  final _todoService = TodoService();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<TodoItem>('todoBox').listenable(),
        builder: (context, Box<TodoItem> box, _) {
          return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                var todo = box.getAt(index);
                return ListTile(
                  title: Text(todo!.title),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (val) {
                      _todoService.updateTodo(todo, index);
                    },
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      _todoService.deleteTodoItem(index);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Add Todo"),
                  content: TextField(controller: titleController),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        await _todoService.addItem(
                          TodoItem(
                            title: titleController.text,
                            isCompleted: false,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text("Add"),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
