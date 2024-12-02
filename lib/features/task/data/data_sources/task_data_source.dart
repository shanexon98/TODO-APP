import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

abstract class TaskDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> saveTasks(List<TaskModel> tasks);
}

class TaskDataSourceImpl implements TaskDataSource {
  final SharedPreferences sharedPreferences;
  static const String _tasksKey = 'TASKS';

  TaskDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TaskModel>> getTasks() async {
    final tasksJson = sharedPreferences.getString(_tasksKey);
    if (tasksJson != null) {
      final List<dynamic> tasksList = jsonDecode(tasksJson);
      return tasksList.map((task) => TaskModel.fromJson(task)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    await sharedPreferences.setString(_tasksKey, jsonEncode(tasksJson));
  }
}
