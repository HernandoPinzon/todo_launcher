import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';

class TaskItemWidget extends StatelessWidget {
  final String title;
  final bool isComplete;
  final String id;

  const TaskItemWidget(
      {super.key, required this.title, required this.isComplete, required this.id});

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
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.radio_button_unchecked),
          onPressed: () {
            TaskProvider taskProvider = context.read<TaskProvider>();
            bool newIsComplete = !isComplete;
            taskProvider.completeTask(id, newIsComplete);
          },
        ),
      ),
    );
  }
}
