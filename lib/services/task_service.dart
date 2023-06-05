import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  static Future<List<Task>> getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('taskList');
    if (taskList == null) {
      return [];
    } else {
      List<Task> tasks = taskList.map((taskString) {
        List<String> taskData = taskString.split(':::');
        String title = taskData[0];
        bool isComplete = taskData[1] == 'true';
        bool isVisible = taskData[2] == 'true';
        String id;
        if (taskData.length > 3) {
          isVisible = taskData[2] == 'true';
          id = taskData[3];
        } else {
          id = Random().nextInt(9999999).toString();
        }
        return Task(
          id: id,
          title: title,
          isComplete: isComplete,
          isVisible: isVisible,
        );
      }).toList();
      return tasks;
    }
  }

  static void saveTasks(List<Task> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = tasks.map((task) {
      return '${task.title}:::${task.isComplete}:::${task.isVisible}:::${task.id}';
    }).toList();
    prefs.setStringList('taskList', taskList);
  }
}

class Task {
  String id;
  String title;
  bool isComplete;
  bool isVisible;

  Task({
    required this.id,
    required this.title,
    this.isComplete = false,
    this.isVisible = true,
  });

  @override
  String toString() {
    return 'Task{id: $id, title: $title, isComplete: $isComplete, isVisible: $isVisible}';
  }
}
