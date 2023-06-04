import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:provider/provider.dart';
import 'package:todo_launcher/extencions/diacritics_aware_string.dart';
import 'package:todo_launcher/services/app_list.dart';
import '../providers/app_info.dart';
import 'app_list_page.dart';
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
    PageController pageController = PageController(initialPage: 0);
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: Colors.black,
            child: PageView(
              controller: pageController,
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
                AppListPage(pageController: pageController, searchingController: searchingController)
              ],
            ),
          ),
        ),
      ),
    );
  }
}