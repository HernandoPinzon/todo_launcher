import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_launcher/widgets/stream_status_widget.dart';
import 'package:todo_launcher/widgets/task_item_widget.dart';
import '../providers/channel_streaming_info.dart';
import '../providers/task_provider.dart';
import '../services/task_service.dart';

class NotificationsWidget extends StatelessWidget {
  static List<Widget> notifications = [];
  const NotificationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener el provider de TaskProvider
    TaskProvider taskProvider = context.watch<TaskProvider>();

    // Clear notifications
    NotificationsWidget.notifications.clear();

    // Agregar StreamStatusWidget si el canal está en streaming
    ChannelStreaming channelStreaming =
        context.watch<ChannelStreamingInfo>().channelStreaming;
    if (channelStreaming.isStreaming) {
      NotificationsWidget.notifications.add(const StreamStatusWidget());
    }

    // Agregar TaskItemWidget para cada tarea en la lista de tareas
    for (Task task in taskProvider.tasks) {
      if (task.isVisible) {
        NotificationsWidget.notifications.add(
          TaskItemWidget(
            title: task.title,
            isComplete: task.isComplete,
          ),
        );
      }
    }

    return NotificationsWidget.notifications.isEmpty
        ? const SizedBox()
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: const Color.fromARGB(45, 129, 129, 129),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              itemCount: NotificationsWidget.notifications.length,
              itemBuilder: (context, index) {
                return NotificationsWidget.notifications[index];
              },
            ),
          );
  }
}
