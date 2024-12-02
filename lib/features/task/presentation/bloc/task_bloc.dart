import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/features/task/data/models/task_model.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/entities/task.dart';
import 'task_event.dart';
import 'task_state.dart';
import 'package:to_do/features/task/presentation/bloc/task_filter.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;

  List<Task> _allTasks = []; // Lista original de todas las tareas
  TaskFilter _currentFilter = TaskFilter.all; // Filtro actual

  TaskBloc({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.deleteTaskUseCase,
    required this.updateTaskUseCase,
  }) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<FilterTasksEvent>(_onFilterTasks);
  }

  Future<void> _onLoadTasks(
      LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      _allTasks = await getTasksUseCase.call(); // Cargar todas las tareas
      _applyFilter(
          emit); // Aplica el filtro actual (por defecto: TaskFilter.all)
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      try {
        await addTaskUseCase.call(event.task);
        _allTasks.add(event.task); // Añadir tarea a la lista original
        _applyFilter(emit); // Actualizar la lista filtrada
      } catch (e) {
        emit(TaskError(message: e.toString()));
      }
    }
  }

  Future<void> _onDeleteTask(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      try {
        await deleteTaskUseCase.call(event.taskId);
        _allTasks
            .removeWhere((task) => task.id == event.taskId); // Eliminar tarea
        _applyFilter(emit); // Actualizar la lista filtrada
      } catch (e) {
        emit(TaskError(message: e.toString()));
      }
    }
  }

  Future<void> _onUpdateTask(
      UpdateTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      try {
        // Convierte la tarea de tipo Task (entidad) a TaskModel (modelo)
        final taskModel = TaskModel.fromEntity(event.task);

        // Llama al caso de uso con TaskModel, no Task
        await updateTaskUseCase.call(taskModel);

        // Actualiza la tarea en la lista original `_allTasks`
        final index = _allTasks.indexWhere((task) => task.id == event.task.id);
        if (index != -1) {
          // Actualiza la lista de tareas con el Task actualizado
          _allTasks[index] = event.task;
        }

        // Aplica el filtro después de actualizar
        _applyFilter(emit);
      } catch (e) {
        print('Error en actualización de tarea: $e');
        emit(TaskError(message: e.toString()));
      }
    }
  }

  void _onFilterTasks(FilterTasksEvent event, Emitter<TaskState> emit) {
    _currentFilter = event.filter; // Actualizar el filtro seleccionado
    _applyFilter(emit); // Aplicar el filtro
  }

  void _applyFilter(Emitter<TaskState> emit) {
    // Inicializa filteredTasks con una lista vacía por si ocurre un caso inesperado
    List<Task> filteredTasks = [];

    // Generar la lista de tareas filtradas según el filtro actual
    if (_currentFilter == TaskFilter.all) {
      filteredTasks = _allTasks;
    } else if (_currentFilter == TaskFilter.pending) {
      filteredTasks = _allTasks.where((task) => !task.isCompleted).toList();
    } else if (_currentFilter == TaskFilter.completed) {
      filteredTasks = _allTasks.where((task) => task.isCompleted).toList();
    }

    // Emitir el estado actualizado con las tareas originales y filtradas
    emit(TaskLoaded(tasks: filteredTasks));
  }
}
