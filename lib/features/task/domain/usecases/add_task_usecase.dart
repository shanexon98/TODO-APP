import 'package:to_do/features/task/data/models/task_model.dart';

import '../repositories/task_repository.dart';

class AddTaskUseCase {
  final TaskRepository repository;

  AddTaskUseCase({required this.repository});

  Future<void> call(TaskModel taskModel) {
    return repository.addTask(taskModel);
  }
}
