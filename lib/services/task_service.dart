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
        bool isVisible = true; // Establecer por defecto en true
        if (taskData.length > 2) {
          isVisible = taskData[2] == 'true';
        }
        return Task(
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
      return '${task.title}:::${task.isComplete}:::${task.isVisible}';
    }).toList();
    prefs.setStringList('taskList', taskList);
  }
}

class Task {
  String title;
  bool isComplete;
  bool isVisible;

  Task({required this.title, this.isComplete = false, this.isVisible = true});

  @override
  String toString() {
    return 'Task{title: $title, isComplete: $isComplete, isVisible: $isVisible}';
  }
}
