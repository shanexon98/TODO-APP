import 'package:to_do/features/task/data/models/task_model.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase({required this.repository});

  Future<void> call(TaskModel taskModel) {
    return repository.updateTask(taskModel);
  }
}
