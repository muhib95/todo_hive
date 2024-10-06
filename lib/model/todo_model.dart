import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 1) // The typeId must be unique for each model
class Todo extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  DateTime createdAt;

  Todo({
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
  });
}
