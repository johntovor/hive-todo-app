// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:hive_flutter/hive_flutter.dart';

part 'todo_item.g.dart';

@HiveType(typeId: 1)
class TodoItem {
  @HiveField(0)
  final String title;

  @HiveField(1, defaultValue: false)
  bool isCompleted;

  TodoItem({
    required this.title,
    required this.isCompleted,
  });
}
