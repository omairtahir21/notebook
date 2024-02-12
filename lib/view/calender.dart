import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notebook/utils/appcolor/app_color.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/checkmodel.dart';
import '../model/model_data.dart';
import '../provider/themeprovider.dart';
import '../services/sqlitedatabase.dart';
import '../utils/app_name.dart';

class CalenderView extends StatefulWidget {
  const CalenderView({super.key});

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  final List<String> textList = ["Month", "Week"];
  bool _isLoading = false;
  DatabaseHelper dbHelper = DatabaseHelper();
  List<AddNote> txtItems = [];
  List<CheckListItem> checkItem = [];

  @override
  void initState() {
    super.initState();
    dbHelper.open();
    setState(() {
      _isLoading = true;
    });
    refreshItemList();
  }

  void refreshItemList() {
    dbHelper.getAllItems().then((itemList) {
      setState(() {
        txtItems = itemList;
      });
    });
    dbHelper.getCheckItemList().then((checkList) {
      setState(() {
        checkItem = checkList;
      });
    });
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final DateTime _dateTime = DateTime.now();
  var dateString = 'April 20, 2020';
  DateFormat format = new DateFormat("MMMM dd, yyyy");

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('MM-yyyy').format(_dateTime)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: DropdownButton<CalendarFormat>(
                  value: _calendarFormat,
                  items: const [
                    DropdownMenuItem(
                      value: CalendarFormat.month,
                      child: Text("Month"),
                    ),
                    DropdownMenuItem(
                      value: CalendarFormat.week,
                      child: Text("Week"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _calendarFormat = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            firstDay: DateTime(2022, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          const Divider(
            thickness: 3,
            color: AppColor.blackBackAccent,
          ),
          if (txtItems.isNotEmpty)
            Expanded(
                child: ListView.builder(
                itemCount: txtItems.length,
                itemBuilder: (context, index) {
                  final item = txtItems[index];
                  return GestureDetector(
                    onTap: (){},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.check_box_outline_blank),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            item.heading ?? '',
                            style: const TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  );
                }))
          else if(checkItem.isNotEmpty)
            Expanded(
                child: ListView.builder(
                itemCount: checkItem.length,
                itemBuilder: (context, index) {
                  final item = checkItem[index];
                  return GestureDetector(
                    onTap: (){},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.check_box_outline_blank),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            item.title ?? '',
                            style: const TextStyle(
                              // fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  );
                }))
          else
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    'assets/images/notask.png',
                    height: height / 3.7,
                    color: themeProvider.themeData == ThemeData.dark()
                        ? AppColor.whiteColor
                        :AppColor.blackColor,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
