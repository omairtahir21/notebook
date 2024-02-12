
import 'package:flutter/material.dart';
import 'package:notebook/utils/appcolor/app_color.dart';
import 'package:notebook/view/calender.dart';
import 'package:notebook/view/homeview.dart';
import 'package:notebook/view/menu.dart';
import 'package:provider/provider.dart';

import '../../provider/themeprovider.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _currentIndex = 0;
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return const HomeView();
      case 1:
        return const CalenderView();
      case 2:
        return const MenuView();

      default:
        return const Text("Error");
    }
  }

  List<String> titleList = ["Favorite", "Music", "Places"];
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        //backgroundColor: colorScheme.surface,
        selectedItemColor: themeProvider.themeData == ThemeData.dark()
          ? AppColor.whiteColor
          :AppColor.blueColor,
        unselectedItemColor:themeProvider.themeData == ThemeData.dark()
            ? Colors.grey
            :Colors.grey,
        // selectedLabelStyle: textTheme.caption,
        // unselectedLabelStyle: textTheme.caption,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.sticky_note_2_rounded,size: 30,),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.calendar_today,size: 30,),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.menu,size: 30,),
          ),
        ],
      ),
      body: _getDrawerItemWidget(_currentIndex,),
    );
  }
}
