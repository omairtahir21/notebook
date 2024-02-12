import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/themeprovider.dart';
import '../../utils/appcolor/app_color.dart';
import '../themeclass.dart';

class Setting extends StatefulWidget {
  final ThemeManager themeManager;

  const Setting({
    super.key,
    required this.themeManager,
  });

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:  themeProvider.themeData == ThemeData.dark()
          ? Colors.black
          :Colors.blue[50],
      appBar: AppBar(
        backgroundColor:  themeProvider.themeData == ThemeData.dark()
            ? Colors.black
            :Colors.blue[50],
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 13, right: 13),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3.6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: themeProvider.themeData == ThemeData.dark()
                      ? Colors.black
                      :Colors.white,

                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'General',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.nightlight),
                    title:  Text(
                      'Dark Mode',
                      style: TextStyle(
                        color: themeProvider.themeData == ThemeData.dark()
                            ? Colors.white
                            :Colors.black,
                      ),
                    ),
                    trailing:  Switch(
                      value: themeProvider.themeData == ThemeData.dark(),
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.color_lens),
                    title:  Text(
                      'Default color',
                      style: TextStyle(
                        color: themeProvider.themeData == ThemeData.dark()
                            ? Colors.white
                            :Colors.black,
                      ),
                    ),
                    trailing: IconButton(
                        onPressed: () {}, icon: Icon(Icons.color_lens)),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title:  Text(
                              'Language',
                                style: TextStyle(
                                  color: themeProvider.themeData == ThemeData.dark()
                                      ? Colors.white
                                      :Colors.black,
                                ),
                            ),
                            actions: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const ListTile(
                                  title: Text('English'),
                                  trailing: Icon(
                                    Icons.check,
                                    size: 25,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const ListTile(
                                  title: Text('Pyccknn'),
                                  trailing: Icon(
                                    Icons.check,
                                    size: 25,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const ListTile(
                                  title: Text('Espanol'),
                                  trailing: Icon(
                                    Icons.check,
                                    size: 25,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const ListTile(
                                  title: Text('Mexico'),
                                  trailing: Icon(
                                    Icons.check,
                                    size: 25,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const ListTile(
                                  title: Text('Turkye'),
                                  trailing: Icon(
                                    Icons.check,
                                    size: 25,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const ListTile(
                                  title: Text('Arabic'),
                                  trailing: Icon(
                                    Icons.check,
                                    size: 25,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const ListTile(
                                  title: Text('Francais'),
                                  trailing: Icon(
                                    Icons.check,
                                    size: 25,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const ListTile(
                                  title: Text('Deutsch'),
                                  trailing: Icon(
                                    Icons.check,
                                    size: 25,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      // Hide the delete icon
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Save'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: ListTile(
                      leading: const Icon(Icons.textsms_rounded),
                      title: const Text(
                        'Language Options',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                      trailing: IconButton(
                          onPressed: () {},
                          icon:const Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Colors.blue,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
