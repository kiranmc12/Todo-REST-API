import 'package:flutter/material.dart';
import 'package:todoapp/screens/add_page.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amber,
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>AddPageScreen()));

        },
         label: Text("Add")),
    );
  }
}
