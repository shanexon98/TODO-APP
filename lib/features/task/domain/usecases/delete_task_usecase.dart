import '../repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase({required this.repository});

  Future<void> call(String id) {
    return repository.deleteTask(id);
  }
}
