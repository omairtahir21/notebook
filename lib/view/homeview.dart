// ignore_for_file: unused_field, unused_local_variable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notebook/utils/app_name.dart';
import 'package:notebook/utils/appcolor/app_color.dart';
import 'package:notebook/view/add_item/add_checklist.dart';
import 'package:notebook/view/add_item/add_txt.dart';
import 'package:notebook/view/searchfilter/searchfilter.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import '../model/checkmodel.dart';
import '../model/model_data.dart';
import '../provider/themeprovider.dart';
import '../services/sqlitedatabase.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final DateTime _dateTime = DateTime.now();
  bool _isLoading = false;
  DatabaseHelper dbHelper = DatabaseHelper();
  List<AddNote> txtItems = [];
  List<CheckListItem> checkItems = [];
  TextEditingController searchController =
      TextEditingController(); // Add search controller

  @override
  void initState() {
    super.initState();
    dbHelper.open();
    setState(() {
      _isLoading = true;
    });
    refreshItemList();
    _isLoading = false;
  }

  void refreshItemList() {
    dbHelper.getAllItems().then((itemList) {
      setState(() {
        txtItems = itemList;
      });
    });
    dbHelper.getCheckItemList().then((checkList) {
      setState(() {
        checkItems = checkList;
      });
    });
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      refreshItemList(); // If the query is empty, show all items
    } else {
      setState(() {
        txtItems = txtItems
            .where((item) =>
                item.heading.toLowerCase().contains(query.toLowerCase()) ||
                item.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.blueColor,
        onPressed: () {
          _addItemBottom();
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40))),
        child: const RippleAnimation(
            color: AppColor.blueColor,
            delay: Duration(milliseconds: 300),
            repeat: true,
            minRadius: 28,
            ripplesCount: 3,
            duration: Duration(milliseconds: 6 * 300),
            child: Center(
              child: Icon(
                Icons.edit,
                color: AppColor.whiteColor,
                size: 30,
              ),
            )),
      ),
      appBar: AppBar(
        title: const Text(
          AppName.homeTitle,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _colorBottomSheetMenu();
                },
                child: SizedBox(
                    // color: Colors.amber,
                    height: height / 20,
                    width: width / 7.5,
                    child: const Icon(
                      Icons.color_lens_outlined,
                      size: 22,
                    )),
              ),
              GestureDetector(
                onTap: () {
                  _shortBottomSheetMenu();
                },
                child: SizedBox(
                    // color: Colors.amber,
                    height: height / 20,
                    width: width / 7.5,
                    child: const Icon(
                      Icons.edit_note_outlined,
                      size: 35,
                    )),
              ),
              PopupMenuButton(
                  color: themeProvider.themeData == ThemeData.dark()
                      ? AppColor.blackColor
                      :AppColor.whiteAccent,
                  // add icon, by default "3 dot" icon
                  // icon: Icon(Icons.book)
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.check_box_rounded),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Select")
                          ],
                        ),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.view_in_ar),
                            SizedBox(
                              width: 10,
                            ),
                            Text("View")
                          ],
                        ),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.feedback),
                            SizedBox(
                              width: 10,
                            ),
                            Text("FeedBack")
                          ],
                        ),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      print("My account menu is selected.");
                    } else if (value == 1) {
                      print("Settings menu is selected.");
                    } else if (value == 2) {
                      print("Logout menu is selected.");
                    }
                  }),
            ],
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  showSearch(context: context, delegate: DataSearch(searchItems: txtItems));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height/15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.searchBarColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_sharp,
                          size: 27,
                          color: AppColor.whiteAccent,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Search....',style: TextStyle(fontSize: 17,color: AppColor.blackAccent),)
                    ]
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (txtItems.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: txtItems.length,
                    itemBuilder: (context, index) {
                      final item = txtItems[index];

                      bool showDeleteIcon = false; // Flag to show delete icon
                      print('load the data$txtItems');
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: GestureDetector(
                            onLongPress: () {
                              // Set the flag to show delete icon
                              setState(() {
                                showDeleteIcon = true;
                              });
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete'),
                                    content: const Text(
                                      'Are you sure you want to delete this item?',
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          // Hide the delete icon
                                          setState(() {
                                            showDeleteIcon = false;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Delete'),
                                        onPressed: () {
                                          // Delete the item
                                          dbHelper.delete(item
                                              .id!); // Assuming `id` is the unique identifier
                                          refreshItemList();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onTap: () {
                              // Navigate to the AddTxt screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AddTxt(
                                            selectedTXTNote: item,
                                          )));
                              refreshItemList();
                            },
                            child: Container(
                              // Container for AddTxt items
                              height: MediaQuery.of(context).size.height / 7,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: themeProvider.themeData == ThemeData.dark()
                                    ? Colors.black
                                    :AppColor.displayContainerColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.heading ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('HH:mm')
                                              .format(DateTime.now()),
                                          style:  TextStyle(
                                            color: themeProvider.themeData == ThemeData.dark()
                                                ? Colors.white
                                                :AppColor.blackAccent,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      thickness: .5,
                                      color: AppColor.blackAccent,
                                    ),
                                    Text(
                                      item.description ?? '',
                                      style:  TextStyle(
                                        color: themeProvider.themeData == ThemeData.dark()
                                            ? Colors.white
                                            :AppColor.blackAccent,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              // Check Note List
              else if (checkItems.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: checkItems.length,
                    itemBuilder: (context, index) {
                      final checkItem = checkItems[index];
                      bool showDeleteIcon = false; // Flag to show delete icon
                      print('load the data$checkItem');
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: GestureDetector(
                            onLongPress: () {
                              // Set the flag to show delete icon
                              setState(() {
                                showDeleteIcon = true;
                              });
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete'),
                                    content: const Text(
                                      'Are you sure you want to delete this item?',
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          // Hide the delete icon
                                          setState(() {
                                            showDeleteIcon = false;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Delete'),
                                        onPressed: () {
                                          // Delete the item
                                          dbHelper.delete(checkItem
                                              .id!); // Assuming `id` is the unique identifier
                                          refreshItemList();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onTap: () {
                              // Navigate to the CheckList screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CheckList(selectedCheckNote: checkItem),
                                ),
                              );
                              refreshItemList();
                            },
                            child: Container(
                              // Container for Checklist items
                              height: MediaQuery.of(context).size.height / 6,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: themeProvider.themeData == ThemeData.dark()
                                    ? Colors.black
                                    :AppColor.displayContainerColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      checkItem.title ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('HH:mm')
                                              .format(DateTime.now()),
                                          style: const TextStyle(
                                            color: AppColor.blackAccent,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      thickness: .5,
                                      color: AppColor.blackAccent,
                                    ),
                                     Text(
                                      checkItem.description ?? '',
                                      style: const TextStyle(
                                        color: AppColor.blackColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                // Empty Image Show
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      Image.asset(
                        'assets/images/emptyhome.png',
                        height: height / 4,
                        color: themeProvider.themeData == ThemeData.dark()
                            ? AppColor.whiteColor
                            :AppColor.blackColor,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      const Text(
                        AppName.emptyHomeTitle,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
            ],
          )),
    );
  }

  void _colorBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 350.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: const BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 20, right: 20, bottom: 5),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Filter',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              'Edit',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: AppColor.blackAccent),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.block,
                                      color: AppColor.blackAccent,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'All notes',
                                      style: TextStyle(
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('Personal', () {}, AppColor.yellowColor,
                                AppColor.yellowBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('Work', () {}, AppColor.greenColor,
                                AppColor.greenBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('Other', () {}, AppColor.blueColor,
                                AppColor.backBlueColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('', () {}, AppColor.redColor,
                                AppColor.redBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor(' ', () {}, AppColor.orangeColor,
                                AppColor.orangeBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor(' ', () {}, AppColor.purpleColor,
                                AppColor.purpleBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('', () {}, AppColor.blackAccent,
                                AppColor.blackBackAccent),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: AppColor.blackAccent),
                              ),
                              child: const Padding(
                                  padding: EdgeInsets.all(8.5),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 280.0),
                                    child: CircleAvatar(
                                      radius: 4,
                                      backgroundColor: AppColor.backBlueColor,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          );
        });
  }

  void _addItemBottom() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 180.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration:  const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (_) => AddTxt()));

                              print('updating ....');
                              refreshItemList();
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height / 9,
                              width: MediaQuery.of(context).size.width / 2.3,
                              decoration: BoxDecoration(
                                color: AppColor.backBlueColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.terminal_outlined,
                                      size: 50,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      'TXT',
                                      style: TextStyle(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const CheckList()));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height / 9,
                              width: MediaQuery.of(context).size.width / 2.3,
                              decoration: BoxDecoration(
                                color: AppColor.backBlueColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 50,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      'Checklist',
                                      style: TextStyle(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  void _shortBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return Container(
            height: 200.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: const BoxDecoration(
                    // color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child:  Padding(
                  padding: const EdgeInsets.only(top: 15, left: 20, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Sort by',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          Icon(Icons.edit, size: 25, color:themeProvider.themeData == ThemeData.dark()
                              ? AppColor.whiteAccent
                              :AppColor.blackAccent,),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            'Modified Time',
                            style: TextStyle(
                                color: themeProvider.themeData == ThemeData.dark()
                                    ? AppColor.whiteAccent
                                    :AppColor.blackAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(Icons.create_new_folder_rounded,
                              size: 25, color:themeProvider.themeData == ThemeData.dark()
                                ? AppColor.whiteAccent
                                :AppColor.blackAccent,),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            'Created time',
                            style: TextStyle(
                                color: themeProvider.themeData == ThemeData.dark()
                                    ? AppColor.whiteAccent
                                    :AppColor.blackAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(Icons.more_time_rounded,
                              size: 25, color: themeProvider.themeData == ThemeData.dark()
                                ? AppColor.whiteAccent
                                :AppColor.blackAccent,),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            'Reminder Time',
                            style: TextStyle(
                                color: themeProvider.themeData == ThemeData.dark()
                                    ? AppColor.whiteAccent
                                    :AppColor.blackAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(Icons.color_lens,
                              size: 25, color:themeProvider.themeData == ThemeData.dark()
                                ? AppColor.whiteAccent
                                :AppColor.blackAccent,),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            'Color',
                            style: TextStyle(
                                color: themeProvider.themeData == ThemeData.dark()
                                    ? AppColor.whiteAccent
                                    :AppColor.blackAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          )
                        ],
                      ),

                      //  selectColor('All notes', () { })
                    ],
                  ),
                )),
          );
        });
  }

  Widget selectColor(String title, VoidCallback onPress, final Color? color,
      final Color? backColor) {
    var Size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        height: Size.height / 15,
        width: Size.width,
        decoration: BoxDecoration(
          color: backColor,
          // border: Border.all(color: AppColor.blackColor),
          //color: isColor ? Colors.blue[700] : AppColor.testFieldColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: color,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectShotItem(String title, VoidCallback onPress, final Color? color,
      IconData iconData) {
    var Size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        height: Size.height / 15,
        width: Size.width,
        decoration: BoxDecoration(
          // border: Border.all(color: AppColor.blackColor),
          //color: isColor ? Colors.blue[700] : AppColor.testFieldColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: color,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
