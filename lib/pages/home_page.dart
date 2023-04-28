import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:provider/provider.dart';
import 'package:todo_launcher/extencions/diacritics_aware_string.dart';
import 'package:todo_launcher/services/app_list.dart';
import '../providers/app_info.dart';
import 'clock_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LocalAppWithIcon> apps = [];
  TextEditingController searchingController = TextEditingController();
  String systemTime = getSystemTime();

  @override
  void initState() {
    super.initState();
    searchingController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchingController.dispose();
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
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: Colors.black,
            child: PageView(
              onPageChanged: (value) {
                if (value == 0) {
                  searchingController.text = '';
                  FocusScope.of(context).unfocus();
                  setState(() {
                    apps = [];
                  });
                }
              },
              children: [
                const ClockPage(),
                Column(
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
                            onTap: () =>
                                DeviceApps.openApp('com.android.settings'),
                            child: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        controller: searchingController,
                        onChanged: (value) {
                          setState(() {
                            apps = appListInfo.appList
                                .where((app) =>
                                    partialRatio(app.appName.toLowerCase().withoutDiacriticalMarks.trim(), value.toLowerCase()) > 50 ||
                                    partialRatio(
                                            app.packageName.split('.').last.toLowerCase(),
                                            value.toLowerCase()) >
                                        50 ||
                                    app.packageName
                                        .split('.')
                                        .last
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    app.appName.toLowerCase().withoutDiacriticalMarks.trim()
                                        .contains(value.toLowerCase()))
                                .toList();
                            apps = orderList(apps, value);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: getApps(appListInfo).length,
                        itemBuilder: (context, index) {
                          LocalAppWithIcon app = getApps(appListInfo)[index];
                          return GestureDetector(
                            onTap: () {
                              searchingController.text = '';
                              setState(() {
                                apps = [];
                              });
                              DeviceApps.openApp(app.packageName);
                            },
                            child: ListTile(
                              title: Text(
                                app.appName,
                                style: const TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading:
                                  Image.memory(app.icon, width: 35, height: 35),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//order list of apps by his partial ratio of his appname nad packageName with a given searching text
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
