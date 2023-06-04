import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class OptionsDialog extends StatelessWidget {
  const OptionsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Options'),
      actions: [
        TextButton(
          onPressed: () {
            DeviceApps.openApp('com.android.settings');
            Navigator.of(context).pop();
          },
          child: const Text('Android Options'),
        ),
        TextButton(
          onPressed: () {
            //TODO: Implement app options
            Navigator.of(context).pop();
          },
          child: const Text('Launcher Options'),
        ),
      ],
    );
  }
}
