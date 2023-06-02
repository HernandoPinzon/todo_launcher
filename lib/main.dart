import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:provider/provider.dart';

import 'providers/app_info.dart';
import 'providers/channel_streaming_info.dart';
import 'providers/task_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppInfo>(create: (_) => AppInfo()),
          ChangeNotifierProvider<ChannelStreamingInfo>(create: (_) => ChannelStreamingInfo()),
          ChangeNotifierProvider<TaskProvider>(create: (_) => TaskProvider()),
        ],
        builder: (context, _) {
          return MaterialApp(
            title: 'todo_launcher',
            theme: ThemeData.dark(),
            initialRoute: 'home',
            routes: {
              'home': (context) => const HomePage(),
            },
          );
        });
  }
}
