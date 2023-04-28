import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/channel_streaming_info.dart';

class StreamStatusWidget extends StatelessWidget {
  const StreamStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ChannelStreaming channelStreaming =
        context.watch<ChannelStreamingInfo>().channelStreaming;
    return Text('${channelStreaming.name} is currently streaming');
  }
}
