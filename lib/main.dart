import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:device_apps/device_apps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getInstalledApps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Application> appList = snapshot.data!;
            return MaterialApp(
              title: 'todo_launcher',
              theme: ThemeData.dark(),
              home: HomePage(appList: appList),
            );
          } else {
            return MaterialApp(
              title: 'todo_launcher',
              theme: ThemeData(
                primarySwatch: Colors.grey,
              ),
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }
}

Future<List<Application>> getInstalledApps({withIcons = true}) async {
  return DeviceApps.getInstalledApplications(
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
      includeAppIcons: true);
}
