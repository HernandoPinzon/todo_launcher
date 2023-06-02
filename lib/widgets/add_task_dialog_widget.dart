import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../services/task_service.dart';

class AddTaskDialog extends StatelessWidget {
  final TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: TextField(
        controller: _taskController,
        decoration: const InputDecoration(
          hintText: 'Enter the task',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String taskTitle = _taskController.text;
            if (taskTitle.isNotEmpty) {
              TaskProvider taskProvider = context.read<TaskProvider>();
              taskProvider.addTask(Task(title: taskTitle));
            }
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
