import 'package:to_do/features/task/data/models/task_model.dart';
import 'package:to_do/features/task/presentation/bloc/task_filter.dart';
import 'package:to_do/features/task/domain/entities/task.dart';

abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final TaskModel task;

  AddTaskEvent({required this.task});
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  DeleteTaskEvent({required this.taskId});
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  UpdateTaskEvent({required this.task});
}

class FilterTasksEvent extends TaskEvent {
  final TaskFilter filter;

  FilterTasksEvent({required this.filter});
}
