import 'package:flutter/material.dart';
import 'package:todo_list/src/blocs/task_bloc.dart';

class Provider extends InheritedWidget {
  static Provider _instance;

  final _taskBloc = new TaskBloc();

  factory Provider({Key key, Widget child}) {
    if (_instance == null) {
      _instance = new Provider._internal(key: key, child: child);
    }
    return _instance;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static TaskBloc taskBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._taskBloc;
  }
}
