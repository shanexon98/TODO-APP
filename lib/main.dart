import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/features/task/data/data_sources/task_data_source.dart';
import 'package:to_do/features/task/data/repositories/task_repositories_impl.dart';
import 'package:to_do/features/task/domain/repositories/task_repository.dart';
import 'package:to_do/features/task/presentation/bloc/task_event.dart';
import 'package:to_do/features/task/presentation/screens/task_screen.dart';
import 'features/task/presentation/bloc/task_bloc.dart';
import 'features/task/domain/usecases/get_tasks_usecase.dart';
import 'features/task/domain/usecases/add_task_usecase.dart';
import 'features/task/domain/usecases/delete_task_usecase.dart';
import 'features/task/domain/usecases/update_task_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  final taskRepository = TaskRepositoryImpl(
    taskDataSource: TaskDataSourceImpl(sharedPreferences: sharedPreferences),
  );

  runApp(MyApp(taskRepository: taskRepository));
}

class MyApp extends StatelessWidget {
  final TaskRepository taskRepository;

  const MyApp({super.key, required this.taskRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskBloc(
            getTasksUseCase: GetTasksUseCase(repository: taskRepository),
            addTaskUseCase: AddTaskUseCase(repository: taskRepository),
            deleteTaskUseCase: DeleteTaskUseCase(repository: taskRepository),
            updateTaskUseCase: UpdateTaskUseCase(repository: taskRepository),
          )..add(LoadTasksEvent()),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        home: TaskPage(),
      ),
    );
  }
}
