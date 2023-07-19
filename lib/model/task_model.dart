import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  String dueDate;
  @HiveField(4)
  String status;

  TaskModel({required this.id, required this.title, required this.description, required this.dueDate, required this.status});
}