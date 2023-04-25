import 'package:flutter/material.dart';
import 'package:todo_launcher/providers/applist_info.dart';
import 'pages/home_page.dart';
import 'package:provider/provider.dart';

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
          ChangeNotifierProvider<AppListInfo>(create: (_) => AppListInfo()),
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
