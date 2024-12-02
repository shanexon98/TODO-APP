import 'package:to_do/features/task/data/models/task_model.dart';

import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(TaskModel taskModel);
  Future<void> deleteTask(String id);
  Future<void> updateTask(TaskModel taskModel);
}
