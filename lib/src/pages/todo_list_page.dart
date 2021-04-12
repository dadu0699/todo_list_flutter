import 'package:flutter/material.dart';

import 'package:todo_list/src/blocs/provider_bloc.dart';
import 'package:todo_list/src/blocs/task_bloc.dart';
import 'package:todo_list/src/models/task_model.dart';

class ToDoListPage extends StatefulWidget {
  ToDoListPage({Key key}) : super(key: key);

  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  TaskBloc _taskBloc;

  @override
  Widget build(BuildContext context) {
    _taskBloc = Provider.taskBloc(context);
    _taskBloc.getTaskList();

    return StreamBuilder<List<TaskModel>>(
      stream: _taskBloc.taskStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data;
        final int completedTaskCount =
            tasks.where((TaskModel task) => task.status == 1).toList().length;

        return Scaffold(
          body: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 75.0),
            itemCount: 1 + tasks.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) return _header(completedTaskCount, tasks.length);

              return _task(tasks[index - 1]);
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, 'task'),
          ),
        );
      },
    );
  }

  Widget _header(int completedTaskCount, int taskCount) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'My Tasks',
            style: TextStyle(
              color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '$completedTaskCount of $taskCount',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _task(TaskModel task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 18.0,
                decoration: task.status == 0
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
              ),
            ),
            subtitle: Text(
              '${task.description}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.0,
                decoration: task.status == 0
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
              ),
            ),
            trailing: Checkbox(
              activeColor: Theme.of(context).primaryColor,
              value: task.status == 1 ? true : false,
              onChanged: (value) {
                setState(() {
                  task.status = value ? 1 : 0;
                  _taskBloc.updateTask(task);
                });
              },
            ),
            onTap: () => Navigator.pushNamed(
              context,
              'task',
              arguments: task,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
