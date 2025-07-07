import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool isLoading = false;

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    isLoading = true;
    notifyListeners();

    // Simulate loading delay or load from DB
    await Future.delayed(const Duration(milliseconds: 500));

    isLoading = false;
    notifyListeners();
  }

  Future<void> addTaskWithDescription(String title, String description) async {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
    );

    _tasks.add(newTask);
    notifyListeners();

    // TODO: Save to persistent storage here if needed
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();

      // TODO: Update persistent storage here if needed
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();

    // TODO: Delete from persistent storage here if needed
  }

  Future<void> toggleTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      notifyListeners();

      // TODO: Update persistent storage here if needed
    }
  }
}
