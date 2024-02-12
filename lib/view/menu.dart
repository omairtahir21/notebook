import 'package:flutter/material.dart';
import 'package:notebook/utils/appcolor/app_color.dart';
import 'package:notebook/view/settings/setting.dart';
import 'package:notebook/view/themeclass.dart';
import 'package:provider/provider.dart';

import '../provider/themeprovider.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final ThemeManager themeManager = ThemeManager();
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:  themeProvider.themeData == ThemeData.dark()
          ? Colors.black
          :Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: themeProvider.themeData == ThemeData.dark()
                      ? Colors.black
                      :Colors.white,
                  borderRadius: BorderRadius.circular(6)),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                        child: Icon(
                      Icons.delete,
                      color: Colors.blue,
                      size: 30,
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recycle bin',
                          style: TextStyle(fontSize: 16,
                          ),
                        ),
                        Text(
                          '4',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Center(
                        child: Icon(
                      Icons.archive,
                      color: Colors.blue,
                      size: 30,
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Archive',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: themeProvider.themeData == ThemeData.dark()
                      ? Colors.black
                      :Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.chat,
                          color: themeProvider.themeData == ThemeData.dark()
                              ? Colors.white
                              :AppColor.blackAccent,
                          size: 25,
                        ),
                       const  SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Feedback or suggestion',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    Setting(themeManager: themeManager)));
                      },
                      child:  Row(
                        children: [
                          Icon(
                            Icons.settings,
                            color: themeProvider.themeData == ThemeData.dark()
                                ? Colors.white
                                :AppColor.blackAccent,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Settings',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Security/Your personal preference',
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                     Row(
                      children: [
                        Icon(
                          Icons.file_present,
                          color: themeProvider.themeData == ThemeData.dark()
                              ? Colors.white
                              :AppColor.blackAccent,
                          size: 25,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Widget',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Sticky notes/Quick access toolbar',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
