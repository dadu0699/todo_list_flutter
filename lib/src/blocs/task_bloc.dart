import 'package:rxdart/rxdart.dart';

import 'package:todo_list/src/models/task_model.dart';
import 'package:todo_list/src/providers/db_provider.dart';

class TaskBloc {
  static final TaskBloc _instance = new TaskBloc._internal();

  factory TaskBloc() {
    return _instance;
  }

  TaskBloc._internal() {
    getTaskList();
  }

  final _taskContoller = new BehaviorSubject<List<TaskModel>>();
  Stream<List<TaskModel>> get taskStream => _taskContoller.stream;

  dispose() {
    _taskContoller?.close();
  }

  void getTaskList() async {
    _taskContoller.sink.add(await DBProvider.instance.getTaskList());
  }

  void insert(TaskModel task) async {
    await DBProvider.instance.insertTask(task);
    getTaskList();
  }

  void updateTask(TaskModel task) async {
    await DBProvider.instance.updateTask(task);
    getTaskList();
  }

  void deleteTask(TaskModel task) async {
    await DBProvider.instance.deleteTask(task);
    getTaskList();
  }
}
