import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class AppOptionsDialog extends StatelessWidget {
  final String packageName;

  const AppOptionsDialog({required this.packageName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('App Options'),
      actions: [
        TextButton(
          onPressed: () {
            DeviceApps.openAppSettings(packageName);
            Navigator.of(context).pop();
          },
          child: const Text('Android Options'),
        ),
        TextButton(
          onPressed: () {
            // Add your code to open launcher options
            // ...
            Navigator.of(context).pop();
          },
          child: const Text('Launcher Options'),
        ),
      ],
    );
  }
}
