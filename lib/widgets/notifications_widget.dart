import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_launcher/widgets/stream_status_widget.dart';
import '../providers/channel_streaming_info.dart';

class NotificationsWidget extends StatelessWidget {
  static List<Widget> notifications = [];
  const NotificationsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    notifications.clear();
    ChannelStreaming channelStreaming =
        context.watch<ChannelStreamingInfo>().channelStreaming;
    if (channelStreaming.isStreaming) {
      notifications.add(const StreamStatusWidget());
    }
    return notifications.isEmpty
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
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return notifications[index];
              },
            ),
          );
  }
}
