import 'package:flutter/material.dart';

import 'package:todo_list/src/blocs/provider_bloc.dart';

import 'package:todo_list/src/pages/todo_list_page.dart';
import 'package:todo_list/src/pages/task_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-Do List',
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => ToDoListPage(),
          'task': (BuildContext context) => TaskPage(),
        },
      ),
    );
  }
}
