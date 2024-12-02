import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/features/task/presentation/bloc/task_filter.dart';
import 'package:to_do/features/task/presentation/widgets/task_item.dart';
import 'package:to_do/features/task/presentation/widgets/text_defaut.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import 'task_form_page.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.task_alt,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 8),
            FadeInLeft(
              child: const Text(
                'Tareas Pendientes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        actions: [
          FadeInRight(
            child: PopupMenuButton<TaskFilter>(
              icon: const Icon(
                Icons.filter_list,
                color: Colors.white,
                size: 28,
              ),
              tooltip: 'Filtrar tareas',
              onSelected: (filter) {
                // Enviar evento para actualizar el filtro seleccionado
                BlocProvider.of<TaskBloc>(context)
                    .add(FilterTasksEvent(filter: filter));
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: TaskFilter.all,
                  child: Row(
                    children: [
                      Icon(Icons.list_alt, color: Colors.black54),
                      SizedBox(width: 8),
                      Text(
                        'Todas las tareas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: TaskFilter.pending,
                  child: Row(
                    children: [
                      Icon(Icons.radio_button_unchecked, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Tareas pendientes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: TaskFilter.completed,
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Tareas completadas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 169, 168, 167), Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              if (state.tasks.isEmpty) {
                return const Center(
                  child: TextDefault(
                    text: 'No hay tareas disponibles',
                    sizeText: 18,
                    fontWeight: FontWeight.bold,
                    colorText: Colors.white,
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return BounceInDown(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TaskItemWidget(task: task),
                  ));
                },
              );
            } else if (state is TaskError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FadeInLeft(
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskFormPage()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
