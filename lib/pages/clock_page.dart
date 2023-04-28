import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_launcher/widgets/stream_status_widget.dart';

import '../providers/app_info.dart';
import '../services/app_list.dart';
import '../widgets/notifications_widget.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({
    super.key,
  });

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  String systemTime = getSystemTime();
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          systemTime = getSystemTime();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppInfo appListInfo = context.watch<AppInfo>();
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            //max width
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    LocalAppWithIcon app = appListInfo.appList.singleWhere(
                        (e) =>
                            e.packageName.contains("clock") &&
                            e.packageName.contains("android"));
                    if (app != null) {
                      DeviceApps.openApp(app.packageName);
                    }
                  },
                  child: Text(
                    systemTime.split(' ').first,
                    style: const TextStyle(color: Colors.white, fontSize: 80),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    LocalAppWithIcon app = appListInfo.appList.firstWhere((e) =>
                        e.packageName.contains("calendar") &&
                        e.packageName.contains("android"));
                    if (app != null) {
                      DeviceApps.openApp(app.packageName);
                    }
                  },
                  child: Text(
                    systemTime.split(' ').last,
                    style: const TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ),
                const SizedBox(height: 20),
                const NotificationsWidget()
              ],
            ),
          ),
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  LocalAppWithIcon app = appListInfo.appList.singleWhere((e) =>
                      e.packageName.contains("dialer") &&
                      e.packageName.contains("android"));
                  if (app != null) {
                    DeviceApps.openApp(app.packageName);
                  }
                },
                child: const Icon(
                  Icons.call,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              GestureDetector(
                onTap: () {
                  LocalAppWithIcon app = appListInfo.appList.singleWhere((e) =>
                      e.packageName.contains("camera") &&
                      e.packageName.contains("android"));
                  if (app != null) {
                    DeviceApps.openApp(app.packageName);
                  }
                },
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

String getSystemTime() {
  var now = DateTime.now();
  return DateFormat('hh:mm dd/MM').format(now);
}
