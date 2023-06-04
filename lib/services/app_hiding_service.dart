import 'package:shared_preferences/shared_preferences.dart';

class AppHidingService {
  static const String hiddenAppsKey = 'hiddenApps';

  static Future<List<HiddenAppData>> getHiddenApps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? hiddenAppsData = prefs.getStringList(hiddenAppsKey);
    if (hiddenAppsData == null) {
      return [];
    } else {
      List<HiddenAppData> hiddenApps = hiddenAppsData.map((appDataString) {
        List<String> appData = appDataString.split(':::');
        return HiddenAppData(
          keyName: appData[0],
          packageName: appData[1],
        );
      }).toList();
      return hiddenApps;
    }
  }

  static Future<void> saveHiddenApps(List<HiddenAppData> hiddenApps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> hiddenAppsData = hiddenApps.map((appData) {
      return '${appData.keyName}:::${appData.packageName}';
    }).toList();
    prefs.setStringList(hiddenAppsKey, hiddenAppsData);
  }
}

class HiddenAppData {
  String keyName;
  String packageName;

  HiddenAppData({required this.keyName, required this.packageName});

  @override
  String toString() {
    return 'HiddenAppData{keyName: $keyName, packageName: $packageName}';
  }
}
