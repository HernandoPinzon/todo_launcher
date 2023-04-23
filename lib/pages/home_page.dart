import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final List<Application> appList;
  const HomePage({super.key, required this.appList});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Application> apps = [];
  TextEditingController searchingController = TextEditingController();

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
                }
              },
              children: [
                Container(
                  child: Center(
                    child: Text(
                      getSystemTime(),
                      style: const TextStyle(color: Colors.white, fontSize: 80),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      color: Colors.black,
                      child: TextField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: ' Search',
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        controller: searchingController,
                        onChanged: (value) {
                          setState(() {
                            apps = widget.appList
                                .where((app) => app.appName
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

String getSystemTime() {
  var now = DateTime.now();
  return DateFormat('kk:mm').format(now);
}
