import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:provider/provider.dart';
import 'package:todo_launcher/services/app_list.dart';
import '../providers/applist_info.dart';
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

  List<LocalAppWithIcon> getApps(AppListInfo appListInfo) {
    if (apps.isEmpty) {
      return appListInfo.appList;
    } else {
      return apps;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppListInfo appListInfo = context.watch<AppListInfo>();
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
                ClockPage(),
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
                                    partialRatio(app.appName, value) > 50 ||
                                    partialRatio(
                                            app.packageName.split('.').last,
                                            value) >
                                        50 ||
                                    app.packageName
                                        .split('.')
                                        .last
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    app.appName
                                        .toLowerCase()
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
  log(" ");
  list.sort((a, b) {
    int aRatio = partialRatio(a.appName, text);
    int bRatio = partialRatio(b.appName, text);
    return bRatio.compareTo(aRatio);
  });
  return list;
}
