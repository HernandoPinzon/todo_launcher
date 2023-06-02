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

  void addTask(Task task) {
    _tasks.add(task);
    TaskService.saveTasks(_tasks);
    notifyListeners();
  }

  void updateTask(int index, {bool? isComplete, bool? isVisible}) {
    if (index >= 0 && index < _tasks.length) {
      Task task = _tasks[index];
      if (isComplete != null) {
        task.isComplete = isComplete;
        if (isComplete) {
          Timer(const Duration(seconds: 1), () {
            updateTask(index, isVisible: false);
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

  void completeTask(int index, bool isComplete) {
    updateTask(index, isComplete: isComplete);
  }

  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      TaskService.saveTasks(_tasks);
      notifyListeners();
    }
  }
}
