import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:todo_launcher/extencions/diacritics_aware_string.dart';
import 'package:provider/provider.dart';

import '../providers/app_info.dart';
import '../services/app_list.dart';
import '../widgets/dialogs/app_options_dialog.dart';
import '../widgets/dialogs/options_dialog_widget.dart';

class AppListPage extends StatefulWidget {
  const AppListPage({
    Key? key,
    required this.pageController,
    required this.searchingController,
  }) : super(key: key);

  final PageController pageController;
  final TextEditingController searchingController;

  @override
  State<AppListPage> createState() => _AppListPageState();
}

class _AppListPageState extends State<AppListPage> {
  List<LocalAppWithIcon> apps = [];

  @override
  void initState() {
    super.initState();
    widget.searchingController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.searchingController.dispose();
    super.dispose();
  }

  List<LocalAppWithIcon> getApps(AppInfo appListInfo) {
    if (apps.isEmpty) {
      return appListInfo.appList;
    } else {
      return apps;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppInfo appListInfo = context.watch<AppInfo>();
    return Column(
      children: [
        Container(
          color: Colors.black,
          child: TextField(
            decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintText: ' Search',
              hintStyle: const TextStyle(color: Colors.white),
              suffixIcon: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const OptionsDialog(),
                  );
                },
                child: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            controller: widget.searchingController,
            onChanged: (value) {
              setState(() {
                apps = orderList(apps, value);
                apps = orderList(apps, value);
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: getApps(appListInfo).length,
            itemBuilder: (context, index) {
              LocalAppWithIcon app = getApps(appListInfo)[index];
              return GestureDetector(
                onLongPress: () {
                  //TODO: add a dialog
                  showAppOptionsDialog(context, app.packageName);
                },
                child: ListTile(
                  onTap: () {
                    widget.searchingController.text = '';
                    setState(() {
                      apps = [];
                    });
                    DeviceApps.openApp(app.packageName);
                    //exec with delay to avoid the app to be closed
                    widget.pageController.animateToPage(0,
                        duration: const Duration(milliseconds: 1),
                        curve: Curves.easeIn);
                  },
                  title: Text(
                    app.appName,
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Image.memory(app.icon, width: 35, height: 35),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

//TODO: refactor this 2 functions
List<LocalAppWithIcon> orderList(List<LocalAppWithIcon> list, String text) {
  list.sort((a, b) {
    String aName = a.appName.toLowerCase().withoutDiacriticalMarks.trim();
    String bName = b.appName.toLowerCase().withoutDiacriticalMarks.trim();
    int aRatio = partialRatio(aName, text);
    int bRatio = partialRatio(bName, text);
    if (aName.contains(text.toLowerCase())) {
      if (aName.startsWith(text.toLowerCase())) {
        aRatio = 1000;
      } else {
        aRatio = 100;
      }
    }
    if (bName.contains(text.toLowerCase())) {
      if (bName.startsWith(text.toLowerCase())) {
        bRatio = 1000;
      } else {
        bRatio = 100;
      }
    }
    return bRatio.compareTo(aRatio);
  });
  return list;
}

List<LocalAppWithIcon> filterApps(AppInfo appListInfo, String value) {
  return appListInfo.appList
      .where((app) =>
          partialRatio(app.appName.toLowerCase().withoutDiacriticalMarks.trim(),
                  value.toLowerCase()) >
              50 ||
          partialRatio(app.packageName.split('.').last.toLowerCase(),
                  value.toLowerCase()) >
              50 ||
          app.packageName
              .split('.')
              .last
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          app.appName
              .toLowerCase()
              .withoutDiacriticalMarks
              .trim()
              .contains(value.toLowerCase()))
      .toList();
}

void showOptionsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => const OptionsDialog(),
  );
}

void showAppOptionsDialog(BuildContext context, String packageName) {
  showDialog(
    context: context,
    builder: (BuildContext context) =>
        AppOptionsDialog(packageName: packageName),
  );
}
