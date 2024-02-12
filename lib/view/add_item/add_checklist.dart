import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notebook/model/checkmodel.dart';
import 'package:provider/provider.dart';

import '../../model/model_data.dart';
import '../../provider/themeprovider.dart';
import '../../services/sqlitedatabase.dart';
import '../../utils/appcolor/app_color.dart';

class CheckList extends StatefulWidget {
  final CheckListItem? selectedCheckNote;
  const CheckList({super.key, this.selectedCheckNote});

  @override
  State<CheckList> createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  final DateTime _dateTime = DateTime.now();
  final titleTextController = TextEditingController();
  final descriptionTextControllers = <TextEditingController>[]; // List of controllers for descriptions
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<CheckListItem> items = [];
  Color selectedColor = AppColor.addTXTYellowColor; // Default color is yellow
  List<Widget> textFields = [];

  bool isChecked = false;

  void addSubtitleField() {
    setState(() {
      descriptionTextControllers.add(TextEditingController()); // Add a new controller
    });
  }
  void removeSubtitleField(int index) {
    setState(() {
      descriptionTextControllers.removeAt(index); // Remove the controller at the given index
    });
  }

  @override
  void initState() {
    super.initState();
    dbHelper.open();
    refreshItemList();
    if(widget.selectedCheckNote != null){
      titleTextController.text = widget.selectedCheckNote!.title ?? '';
    }
  }

  void refreshItemList() {
    dbHelper.getCheckItemList().then((checkValue) {
      setState(() {
        items = checkValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        final titleName = titleTextController.text;
        if (titleName.isNotEmpty) {
          final descriptions = descriptionTextControllers.map((controller) => controller.text).join('\n');
          final updateNote = CheckListItem(
            id: widget.selectedCheckNote?.id,
            title: titleName,
            description: descriptions, // Include description data
          );
          if (widget.selectedCheckNote != null) {
            // Update the existing note
            dbHelper.updateCheck(updateNote);
          } else {
            dbHelper.insertChecklistItem(updateNote);
          }

          print("CheckList Data Is Store $updateNote");
          titleTextController.clear();
          descriptionTextControllers.forEach((controller) => controller.clear()); // Clear description fields
          refreshItemList();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: themeProvider.themeData == ThemeData.dark()
            ? AppColor.blackColor
            :selectedColor,
        appBar: AppBar(
          backgroundColor: themeProvider.themeData == ThemeData.dark()
              ? AppColor.blackColor
              :selectedColor,
          actions:  [
            GestureDetector(
                onTap: (){
                  _colorBottomSheetMenu();
                },
                child: const Icon(Icons.color_lens)),
            const SizedBox(
              width: 15,
            ),
            const Icon(
              Icons.push_pin,
              size: 25,
            ),
            const SizedBox(
              width: 15,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 18.0),
              child: Icon(
                Icons.more_vert,
                size: 25,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleTextController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add Title',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: AppColor.blackAccent,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      'Edited:',
                      style: TextStyle(color: themeProvider.themeData == ThemeData.dark()
                          ? AppColor.whiteColor
                          :AppColor.blackAccent),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      DateFormat('MM-dd HH:mm').format(_dateTime),
                      style:  TextStyle(
                        color: themeProvider.themeData == ThemeData.dark()
                            ? AppColor.whiteColor
                            :AppColor.blackAccent,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(
                      width: 170,
                    ),
                     Icon(
                      Icons.calendar_today,
                      color: themeProvider.themeData == ThemeData.dark()
                          ? AppColor.whiteColor
                          :AppColor.blackAccent,
                      size: 17,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: AppColor.blackAccent,
                  thickness: .5,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int index = 0; index < descriptionTextControllers.length; index++)
                          Row(
                            children: [
                              const Icon(Icons.more_horiz),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(Icons.check_box_outline_blank),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: descriptionTextControllers[index],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Add Subtitle',
                                    hintStyle: const TextStyle(
                                      color: AppColor.blackAccent,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        removeSubtitleField(index); // Remove the text field at the specified index
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        GestureDetector(
                          onTap: addSubtitleField,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 24),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 27,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 20, right: 20, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Change color',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('Personal', () {
                              setState(() {
                                selectedColor = AppColor.addTXTYellowColor;
                              });Navigator.pop(context);
                            }, AppColor.yellowColor,
                                AppColor.yellowBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('Work', () {
                              setState(() {
                                selectedColor = AppColor.addTXTGreenColor;
                              });Navigator.pop(context);
                            }, AppColor.greenColor,
                                AppColor.greenBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('Other', () {
                              setState(() {
                                selectedColor = AppColor.addTXTBlueColor;
                              });Navigator.pop(context);
                            }, AppColor.blueColor,
                                AppColor.backBlueColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('', () {
                              setState(() {
                                selectedColor = AppColor.addTXTRedColor;
                              });Navigator.pop(context);
                            }, AppColor.redColor,
                                AppColor.redBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor(' ', () {
                              setState(() {
                                selectedColor = AppColor.addTXTOrangeColor;
                              });Navigator.pop(context);
                            }, AppColor.orangeColor,
                                AppColor.orangeBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor(' ', () {
                              setState(() {
                                selectedColor = AppColor.addTXTPurpleColor;
                              });Navigator.pop(context);
                            }, AppColor.purpleColor,
                                AppColor.purpleBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('', () {
                              setState(() {
                                selectedColor = AppColor.addTXTBlackAccent;
                              });
                              Navigator.pop(context);
                            }, AppColor.blackAccent,
                                AppColor.blackBackAccent),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedColor = AppColor.whiteColor;
                                });
                              },
                              child: Container(
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
}
