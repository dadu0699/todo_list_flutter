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

  final _taskController = new BehaviorSubject<List<TaskModel>>();
  Stream<List<TaskModel>> get taskStream => _taskController.stream;

  dispose() {
    _taskController?.close();
  }

  void getTaskList() async {
    _taskController.sink.add(await DBProvider.instance.getTaskList());
  }

  void insertTask(TaskModel task) async {
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
