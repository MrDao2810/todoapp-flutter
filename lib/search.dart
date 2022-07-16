
import 'package:flutter/material.dart';

class SearchTask extends StatelessWidget {
  SearchTask({Key? key, required this.onChange}) : super(key: key);

  ValueChanged<String> onChange;
  
  @override
  Widget build(BuildContext context) {
    TextEditingController searchTaskController = TextEditingController();
    searchTaskController.addListener(() {
      final searchQuery = searchTaskController.text;
      if(searchQuery.isNotEmpty) {
        onChange(searchQuery);
      }
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextField(
        controller: searchTaskController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Search Task',
        ),
      ),
    );
  }
}
