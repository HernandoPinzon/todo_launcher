import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'clock_page.dart';

class HomePage extends StatefulWidget {
  final List<Application> appList;
  const HomePage({super.key, required this.appList});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Application> apps = [];
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

  List<Application> getApps() {
    if (apps.isEmpty) {
      return widget.appList;
    } else {
      return apps;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                ClockPage(appList: widget.appList),
                Column(
                  children: [
                    Container(
                      color: Colors.black,
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: ' Search',
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          //add icon options
                          suffixIcon: GestureDetector(
                            //Open settings
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
                            apps = widget.appList
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
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: getApps().length,
                        itemBuilder: (context, index) {
                          Application app = getApps()[index];
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
                              leading: Image.memory(
                                  (app as ApplicationWithIcon).icon,
                                  width: 32,
                                  height: 32),
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
