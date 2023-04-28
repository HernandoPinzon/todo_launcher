import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/app_list.dart';

class AppInfo with ChangeNotifier {
  List<LocalAppWithIcon> _appList = [];

  AppInfo() {
    getApps().then((value) {
      appList = value;
      notifyListeners();
    });
  }

  List<LocalAppWithIcon> get appList => _appList;

  set appList(List<LocalAppWithIcon> appList) {
    _appList = appList;
    notifyListeners();
  }

  getApps() async {
    return await AppListService.getApps();
  }
}