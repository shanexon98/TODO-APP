import 'package:to_do/features/task/presentation/bloc/task_filter.dart';
import '../../domain/entities/task.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded({required this.tasks});
}

class TaskFilteredState extends TaskState {
  final List<Task> filteredTasks;
  final TaskFilter filter;

  TaskFilteredState({
    required this.filteredTasks,
    required this.filter,
  });
}

class TaskError extends TaskState {
  final String message;

  TaskError({required this.message});
}
