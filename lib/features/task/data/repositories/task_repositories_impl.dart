import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../data_sources/task_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource taskDataSource;

  TaskRepositoryImpl({required this.taskDataSource});

  @override
  Future<List<Task>> getTasks() async {
    final tasks = await taskDataSource.getTasks();
    return tasks;
  }

  @override
  Future<void> addTask(Task task) async {
    final tasks = await taskDataSource.getTasks();
    final updatedTasks = List<TaskModel>.from(tasks)
      ..add(TaskModel(
          id: task.id, title: task.title, isCompleted: task.isCompleted));
    await taskDataSource.saveTasks(updatedTasks);
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await taskDataSource.getTasks();
    final updatedTasks = tasks.where((task) => task.id != id).toList();
    await taskDataSource.saveTasks(updatedTasks);
  }

  @override
  Future<void> updateTask(Task task) async {
    final tasks = await taskDataSource.getTasks();
    final updatedTasks = tasks.map((t) {
      if (t.id == task.id) {
        return TaskModel(
          id: task.id,
          title: task.title,
          isCompleted: task.isCompleted,
        );
      }
      return t;
    }).toList();
    await taskDataSource.saveTasks(updatedTasks);
  }
}
