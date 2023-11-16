import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:todoapp/screens/api/api.dart';

class AddPageScreen extends StatefulWidget {
  final Map? todo;
  AddPageScreen({super.key, this.todo});

  @override
  State<AddPageScreen> createState() => _AddPageScreenState();
}

class _AddPageScreenState extends State<AddPageScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: "description"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
               isEdit? await submidata():await updatedata();
                titleController.clear();
                descriptionController.clear();
              },
              child: Text(isEdit ? "update" : "submit"))
        ],
      ),
    );
  }

  Future<void> submidata() async {
    final title = titleController.text;
    final description = descriptionController.text;

    await ApiCalls().postdata(title, description);
  }

  Future<void> updatedata() async {
    final todo = widget.todo;
    if (todo == null) {
      print("you cannot call update without todo data");
    }
    final id = todo!['_id'];
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      print('Update Success');
      Fluttertoast.showToast(msg: "Update sucess");
    } else {
      print("update failed");
      Fluttertoast.showToast(msg: "Update failed");

      print(response);
    }
  }
}
