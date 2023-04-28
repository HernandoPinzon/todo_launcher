import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/twitch_channel_status.dart';

class ChannelStreamingInfo with ChangeNotifier {
  final ChannelStreaming _channelStreaming = ChannelStreaming();

  ChannelStreamingInfo() {
    //TODO: make this more dynamic and get the name from preferences
    _channelStreaming.name = 'midudev';
    checkIfUserIsStreaming(_channelStreaming.name).then((value) {
      channelStreaming.isStreaming = value;
      notifyListeners();
    });
    Timer.periodic(const Duration(seconds: 10), (_) async {
      channelStreaming.isStreaming =
          await checkIfUserIsStreaming(_channelStreaming.name);
      notifyListeners();
    });
  }

  ChannelStreaming get channelStreaming => _channelStreaming;

  updateChannelStreaming(String name) async {
    channelStreaming.name = name;
  }
}

class ChannelStreaming {
  String name = '';
  bool isStreaming = false;
}
