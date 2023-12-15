import 'package:hive/hive.dart';

import 'todo_item.dart';

class TodoService {
  final String _boxName = "todoBox";
  Future<Box<TodoItem>> get _box async =>
      await Hive.openBox<TodoItem>(_boxName);

  Future<void> addItem(TodoItem item) async {
    var box = await _box;
    await box.add(item);
  }

  Future<List<TodoItem>> getItems() async {
    var box = await _box;
    return box.values.toList();
  }

  Future<void> deleteTodoItem(int index) async {
    var box = await _box;
    await box.deleteAt(index);
  }

  Future<void> updateTodo(TodoItem todoItem, int index) async {
    var box = await _box;
    todoItem.isCompleted = !todoItem.isCompleted;
    await box.putAt(index, todoItem);
  }
}
