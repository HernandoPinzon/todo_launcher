import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_apps/device_apps.dart';

/*save and get app list from shared preferences and get installed apps, verify
if the 2 lists are the same and if not, update the shared preferences list

*/
class AppListService {
  static Future<List<LocalAppWithIcon>> getApps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? appList = prefs.getStringList('appList');
    if (appList == null) {
      List<LocalAppWithIcon> installedApps = await getInstalledApps();
      saveApps(installedApps);
      return getInstalledApps();
    } else {
      Timer.periodic(const Duration(seconds: 20), (timer) {
        getInstalledApps().then((value) {
          if (value.toString() != appList.toString()) {
            saveApps(value);
          }
        });
      });
      List<Future<LocalAppWithIcon>> list = appList.map((e) async {
        List<String> app = e.split(':::');
        //get icons
        final path = await _localPath;
        Uint8List icon = await File('$path/icons/${app[1]}').readAsBytes();
        return LocalAppWithIcon(app[0], app[1], icon);
      }).toList();
      return Future.wait(list);
    }
  }

  static void saveApps(List<LocalAppWithIcon> appList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('appList', appList.map((e) => e.toString()).toList());
    //save icons
    for (LocalAppWithIcon app in appList) {
      saveIcon(iconBytes: app.icon, packageName: app.packageName);
    }
  }

  static Future<List<LocalAppWithIcon>> getInstalledApps(
      {withIcons = true}) async {
    Future<List<Application>> apps = DeviceApps.getInstalledApplications(
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
        includeAppIcons: true);
    return appsFromDeviceToLocalAppsWithIcon(await apps);
  }

  static void saveIcon(
      {required Uint8List iconBytes, required String packageName}) async {
    final path = await _localPath;
    File imageFile = File('$path/icons/$packageName');
    if (!await imageFile.exists()) {
      imageFile = await imageFile.create(recursive: true);
    }
    imageFile.writeAsBytes(iconBytes);
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<Uint8List> getIcon({required String packageName}) async {
    final path = await _localPath;
    File imageFile = File('$path/icons/$packageName');
    //verify if the icon is saved, if not, return an empty list
    if (!await imageFile.exists()) {
      return Uint8List(0);
    }
    return imageFile.readAsBytesSync();
  }
}

//trasform the list of installed apps in a list of LocalApp
List<LocalAppWithIcon> appsFromDeviceToLocalAppsWithIcon(
    List<Application> apps) {
  return apps.map((e) {
    return LocalAppWithIcon(
        e.appName, e.packageName, (e as ApplicationWithIcon).icon);
  }).toList();
}

//interface for the application that will be saved in the shared preferences
class LocalApp {
  String appName;
  String packageName;
  LocalApp(this.appName, this.packageName);

  @override
  String toString() {
    return '$appName:::$packageName';
  }
}

class LocalAppWithIcon extends LocalApp {
  Uint8List icon;
  LocalAppWithIcon(String name, String packageName, this.icon)
      : super(name, packageName);
}
