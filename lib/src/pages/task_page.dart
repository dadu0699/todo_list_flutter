import 'package:flutter/material.dart';
import 'package:todo_list/src/blocs/provider_bloc.dart';
import 'package:todo_list/src/blocs/task_bloc.dart';
import 'package:todo_list/src/models/task_model.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _formKey = GlobalKey<FormState>();

  TaskBloc _taskBloc;
  TaskModel _task = new TaskModel();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    _taskBloc = Provider.taskBloc(context);
    final TaskModel taskData = ModalRoute.of(context).settings.arguments;

    if (taskData != null) _task = taskData;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30.0,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _header(),
                  SizedBox(height: 45.0),
                  _form(),
                  SizedBox(height: 30.0),
                  _button(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: <Widget>[
        Text(
          'Task',
          style: TextStyle(
            color: Colors.black,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _titleInput(),
          SizedBox(height: 30.0),
          _descriptionInput(),
        ],
      ),
    );
  }

  Widget _titleInput() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      initialValue: _task.title,
      decoration: _inputDecoration('Title'),
      onSaved: (value) => _task.title = value,
      validator: (value) {
        if (value.length < 0) return 'You need to enter a title';
        return null;
      },
    );
  }

  Widget _descriptionInput() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      initialValue: _task.description,
      maxLines: 3,
      minLines: 3,
      keyboardType: TextInputType.multiline,
      decoration: _inputDecoration('Description'),
      onSaved: (value) => _task.description = value,
    );
  }

  InputDecoration _inputDecoration(String title) {
    return InputDecoration(
      labelText: title,
      labelStyle: TextStyle(fontSize: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Widget _button(BuildContext context) {
    return ElevatedButton(
      child: Container(
        height: 55.0,
        width: double.infinity,
        child: Center(
          child: Text(
            'Save',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
      onPressed: _saving ? null : _submit,
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    setState(() {
      _saving = true;
    });

    if (_task.id == null) {
      _taskBloc.insertTask(_task);
    } else {
      _taskBloc.updateTask(_task);
    }

    Navigator.pop(context);
  }
}
