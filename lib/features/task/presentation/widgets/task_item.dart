import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/features/task/data/models/task_model.dart';
import 'package:to_do/features/task/presentation/widgets/text_defaut.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;

  const TaskItemWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              task.isCompleted
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(2, 4),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icono de estado de la tarea
            IconButton(
              icon: Icon(
                task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                size: 28,
                color: task.isCompleted ? Colors.green : Colors.grey,
              ),
              onPressed: () {
                BlocProvider.of<TaskBloc>(context).add(UpdateTaskEvent(
                  task: TaskModel(
                    id: task.id,
                    title: task.title,
                    isCompleted: !task.isCompleted,
                  ),
                ));
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextDefault(
                    text: task.title,
                    overflow: TextOverflow.fade,
                    sizeText: 16,
                    fontWeight: FontWeight.bold,
                    colorText: task.isCompleted ? Colors.white : Colors.white,
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.isCompleted ? "Completada" : "Pendiente",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color:
                          task.isCompleted ? Colors.green : Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Botón de eliminar tarea
            IconButton(
              icon: const Icon(Icons.delete_forever_outlined,
                  color: Color.fromARGB(255, 230, 137, 137)),
              onPressed: () async {
                bool? confirmDelete =
                    await _showDeleteConfirmationDialog(context);
                if (confirmDelete == true) {
                  BlocProvider.of<TaskBloc>(context)
                      .add(DeleteTaskEvent(taskId: task.id));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          'Confirmación',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const TextDefault(
          sizeText: 15,
          text: '¿Estás seguro de eliminar esta tarea?',
          colorText: Colors.black,
          overflow: TextOverflow.fade,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text(
              'CANCELAR',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const TextDefault(
              sizeText: 15,
              text: "ELIMINAR",
              colorText: Colors.white,
            ),
          ),
        ],
      );
    },
  );
}
