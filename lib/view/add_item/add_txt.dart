import 'package:flutter/material.dart';
import 'package:notebook/utils/appcolor/app_color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/model_data.dart';
import '../../provider/themeprovider.dart';
import '../../services/sqlitedatabase.dart';

class AddTxt extends StatefulWidget {
  final AddNote? selectedTXTNote;
  const AddTxt({super.key, this.selectedTXTNote});

  @override
  State<AddTxt> createState() => _AddTxtState();
}

class _AddTxtState extends State<AddTxt> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController =
      TextEditingController(); // Add a description controller
  final DateTime _dateTime = DateTime.now();
  final DatabaseHelper dbHelper = DatabaseHelper();
  Color selectedColor = AppColor.addTXTYellowColor; // Default color is yellow
  List<AddNote> items = [];
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    dbHelper.open();
    refreshItemList();

    if (widget.selectedTXTNote != null) {
      titleController.text = widget.selectedTXTNote!.heading ?? '';
      descriptionController.text = widget.selectedTXTNote!.description ?? '';
    }
  }

  void refreshItemList() {
    dbHelper.getAllItems().then((itemList) {
      setState(() {
        items = itemList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        final itemName = titleController.text;
        final itemDescription = descriptionController.text;

        if (itemName.isNotEmpty) {
          if (widget.selectedTXTNote != null) {
            // This block will handle updating an existing note
            final updatedNote = AddNote(
              id: widget.selectedTXTNote!.id,
              heading: itemName,
              description: itemDescription,
              color: selectedColor.toString(),
            );
            dbHelper.update(updatedNote); // Update the existing note
            refreshItemList();
          } else {
            // This block will handle creating a new note
            final newNote = AddNote(
              heading: itemName,
              description: itemDescription,
              color: selectedColor.toString(),
            );
            dbHelper.insert(newNote); // Insert a new note
          }

          titleController.clear();
          descriptionController.clear();
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
          elevation: 0,
          actions: [
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
            const SizedBox(
              width: 15,
            ),
            IconButton(onPressed: () {
              setState(() {
                widget.selectedTXTNote!.pinned != widget.selectedTXTNote!.pinned;
                // if the note is pin move to top
                if (widget.selectedTXTNote != null) {
                  if (widget.selectedTXTNote!.pinned != null && widget.selectedTXTNote!.pinned!) {
                    items.remove(widget.selectedTXTNote);
                    items.insert(0, widget.selectedTXTNote!);
                    dbHelper.update(widget.selectedTXTNote!);
                  }
                }
              });

            }, icon: Icon(widget.selectedTXTNote?.pinned == true
            ? Icons.push_pin
            : Icons.push_pin_outlined,
            )),
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
                  controller: titleController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add Title',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: AppColor.blackAccent,
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      'Edited:',
                      style: TextStyle(
                          color: themeProvider.themeData == ThemeData.dark()
                              ? AppColor.whiteColor
                              :AppColor.blackAccent,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      DateFormat('MM-dd HH:mm').format(_dateTime),
                      style:  TextStyle(
                          color: themeProvider.themeData == ThemeData.dark()
                              ? AppColor.whiteColor
                              :AppColor.blackAccent, fontSize: 13),
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
                  child: SizedBox(
                    height: height,
                    width: width,
                    child: TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          hintText: "Add Subtitle",
                          hintStyle: TextStyle(color: AppColor.blackAccent),
                          border: InputBorder.none),
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
                                selectedColor = AppColor.getColor('yellow');
                              });
                              Navigator.pop(context);
                            }, AppColor.yellowColor, AppColor.yellowBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('Work', () {
                              setState(() {
                                selectedColor = AppColor.getColor('green');

                              });
                              Navigator.pop(context);
                            }, AppColor.greenColor, AppColor.greenBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('Other', () {
                              setState(() {
                                selectedColor = AppColor.getColor('blue');

                              });
                              Navigator.pop(context);
                            }, AppColor.blueColor, AppColor.backBlueColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('', () {
                              setState(() {
                                selectedColor = AppColor.getColor('red');

                              });
                              Navigator.pop(context);
                            }, AppColor.redColor, AppColor.redBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor(' ', () {
                              setState(() {
                                selectedColor = AppColor.getColor('orange');

                              });
                              Navigator.pop(context);
                            }, AppColor.orangeColor, AppColor.orangeBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor(' ', () {
                              setState(() {
                                selectedColor = AppColor.getColor('purple');

                              });
                              Navigator.pop(context);
                            }, AppColor.purpleColor, AppColor.purpleBackColor),
                            const SizedBox(
                              height: 10,
                            ),
                            selectColor('', () {
                              setState(() {
                                selectedColor = AppColor.getColor('blackAccent');

                              });
                              Navigator.pop(context);
                            }, AppColor.blackAccent, AppColor.blackBackAccent),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColor = AppColor.whiteColor;

                                });
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: AppColor.blackAccent),
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
