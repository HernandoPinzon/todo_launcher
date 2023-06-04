import 'package:flutter/foundation.dart';

import '../services/app_hiding_service.dart';

class AppHidingProvider with ChangeNotifier {
  List<HiddenAppData> _hiddenApps = [];

  List<HiddenAppData> get hiddenApps => _hiddenApps;

  void loadHiddenApps() async {
    List<HiddenAppData> loadedHiddenApps = await AppHidingService.getHiddenApps();
    _hiddenApps = loadedHiddenApps;
    notifyListeners();
  }

  void hideApp(String keyName, String packageName) {
    HiddenAppData appData = HiddenAppData(keyName: keyName, packageName: packageName);
    _hiddenApps.add(appData);
    AppHidingService.saveHiddenApps(_hiddenApps);
    notifyListeners();
  }

  void unhideApp(String packageName) {
    _hiddenApps.removeWhere((appData) => appData.packageName == packageName);
    AppHidingService.saveHiddenApps(_hiddenApps);
    notifyListeners();
  }
}
