import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/features/task/data/data_sources/task_data_source.dart';
import 'package:to_do/features/task/data/models/task_model.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late TaskDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = TaskDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('TaskDataSourceImpl', () {
    const String _tasksKey = 'TASKS';

    test(
        'getTasks debe devolver una lista de TaskModel cuando hay tareas almacenadas',
        () async {
      // Arrange
      final List<Map<String, dynamic>> taskJsonList = [
        {"id": "1", "title": "Task 1", "isCompleted": false},
        {"id": "2", "title": "Task 2", "isCompleted": true},
      ];
      when(() => mockSharedPreferences.getString(_tasksKey))
          .thenReturn(jsonEncode(taskJsonList));

      // Act
      final tasks = await dataSource.getTasks();

      // Assert
      expect(tasks, isA<List<TaskModel>>());
      expect(tasks.length, 2);
      expect(tasks[0].title, "Task 1");
      expect(tasks[1].isCompleted, true);
    });

    test(
        'getTasks debe devolver una lista vacía cuando no hay tareas almacenadas',
        () async {
      // Arrange
      when(() => mockSharedPreferences.getString(_tasksKey)).thenReturn(null);

      // Act
      final tasks = await dataSource.getTasks();

      // Assert
      expect(tasks, isA<List<TaskModel>>());
      expect(tasks, isEmpty);
    });

    test('saveTasks debe almacenar las tareas en SharedPreferences', () async {
      // Arrange
      final List<TaskModel> tasks = [
        TaskModel(id: "1", title: "Task 1", isCompleted: false),
        TaskModel(id: "2", title: "Task 2", isCompleted: true),
      ];
      final expectedJson =
          jsonEncode(tasks.map((task) => task.toJson()).toList());

      when(() => mockSharedPreferences.setString(_tasksKey, expectedJson))
          .thenAnswer((_) async => true);

      // Act
      await dataSource.saveTasks(tasks);

      // Assert
      verify(() => mockSharedPreferences.setString(_tasksKey, expectedJson))
          .called(1);
    });
  });
}
