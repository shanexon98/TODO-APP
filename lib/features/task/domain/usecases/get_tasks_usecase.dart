import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase({required this.repository});

  Future<List<Task>> call() {
    return repository.getTasks();
  }
}
