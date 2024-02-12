
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/model_data.dart';
import '../../provider/themeprovider.dart';
import '../../utils/appcolor/app_color.dart';

class DataSearch extends SearchDelegate<String> {
  final List<AddNote> searchItems;
  DataSearch({required this.searchItems});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          Navigator.pop(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    // Define what to display when a search result is selected.
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // Show suggestions while the user is typing in the search bar.
    return SingleChildScrollView(
      child: Column(
        children: [
          // Update the suggestion list based on the query
          // Use the filterItems method from the parent widget
          for (var item in searchItems)
            if (item.heading.toLowerCase().contains(query.toLowerCase()) ||
                item.description.toLowerCase().contains(query.toLowerCase()))
              Padding(
                padding: const EdgeInsets.only(top:14.0,left: 10,right: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height / 9,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: themeProvider.themeData == ThemeData.dark()
                        ? AppColor.blackColor
                        :AppColor.getColor(item.color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(item.heading),
                    subtitle: Text(item.description),
                    onTap: () {
                      // Handle selection here
                      // You can close the search and navigate to the selected item
                      close(context, item.heading);
                    },
                  ),
                ),
              ),
        ],
      ),
    );
  }
}