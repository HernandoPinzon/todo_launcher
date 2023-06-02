import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';

class TaskItemWidget extends StatelessWidget {
  final String title;
  final bool isComplete;

  const TaskItemWidget(
      {super.key, required this.title, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
        trailing: IconButton(
          icon: isComplete
              ? Icon(Icons.check_circle, color: Colors.green)
              : Icon(Icons.radio_button_unchecked),
          onPressed: () {
            TaskProvider taskProvider = context.read<TaskProvider>();
            int taskIndex =
                taskProvider.tasks.indexWhere((task) => task.title == title);
            if (taskIndex != -1) {
              bool newIsComplete = !isComplete;
              taskProvider.completeTask(taskIndex, newIsComplete);
            }
          },
        ),
      ),
    );
  }
}
