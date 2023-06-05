import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  TaskProvider() {
    loadTasks();
  }

  List<Task> get tasks => _tasks;

  set tasks(List<Task> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  void loadTasks() async {
    List<Task> loadedTasks = await TaskService.getTasks();
    tasks = loadedTasks;
  }

  void addTask({required String title}) {
    Task task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    _tasks.add(task);
    TaskService.saveTasks(_tasks);
    notifyListeners();
  }

  void updateTask(String taskId, {bool? isComplete, bool? isVisible}) {
    int index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      Task task = _tasks[index];
      if (isComplete != null) {
        task.isComplete = isComplete;
        if (isComplete) {
          Timer(const Duration(seconds: 1), () {
            updateTask(taskId, isVisible: false);
          });
        }
      }
      if (isVisible != null) {
        task.isVisible = isVisible;
      }
      TaskService.saveTasks(_tasks);
      notifyListeners();
    }
  }

  void completeTask(String taskId, bool isComplete) {
    updateTask(taskId, isComplete: isComplete);
  }

  void deleteTask(String taskId) {
    int index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks.removeAt(index);
      TaskService.saveTasks(_tasks);
      notifyListeners();
    }
  }
}
