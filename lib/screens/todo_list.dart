import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:todoapp/screens/add_page.dart';

class TodoListScreen extends StatefulWidget {
  TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: Visibility(
        visible: isLoading,
        child: CircularProgressIndicator(),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;

                final id = item['_id'] as String;
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(item['title']),
                  subtitle: Text(item['description'] ?? "null"),
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == 'edit') {


                      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>AddPageScreen(todo:item)));
                    }
                    if (value == 'delete') {
                      deletebyId(id);
                    }
                  }, itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text('Edit'),
                        value: 'edit',
                      ),
                      PopupMenuItem(
                        child: Text('Delete'),
                        value: 'delete',
                      )
                    ];
                  }),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.amber,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => AddPageScreen()));
          },
          label: Text("Add")),
    );
  }

  Future<void> deletebyId(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    print(response.statusCode);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      Fluttertoast.showToast(msg: "Deletion not done");

    }
  }

  Future<void> fetchTodo() async {
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;
      print(result);
      setState(() {
        items = result;
      });
    } else {
      print("no data retrieved");
    }

    setState(() {
      isLoading = false;
    });
  }
}
