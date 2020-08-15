import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo_app/components/todo/create_task_form.dart';
import 'package:flutter_todo_app/components/todo/list_tasks.dart';
import 'package:flutter_todo_app/data/todo.dart';
import 'package:flutter_todo_app/providers/auth.dart';
import 'package:flutter_todo_app/screens/login_screen.dart';

enum MenuActionOptions { Logout }

class _MyFloatingActionButton extends StatelessWidget {
  const _MyFloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(Icons.add),
      label: Text('New task'),
      onPressed: () async {
        var ctrl = showBottomSheet<Todo>(
          context: context,
          builder: (context) => CreateTaskForm(),
        );
        Todo newTask = await ctrl.closed;

        if (newTask != null) debugPrint(newTask.toString());
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('List of task'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Sign out'),
                value: MenuActionOptions.Logout,
                enabled: auth.isAuthenticated,
              ),
            ],
            onSelected: (MenuActionOptions option) {
              switch (option) {
                case MenuActionOptions.Logout:
                  auth.logout();
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                  break;
              }
            },
          ),
        ],
      ),
      body: ListTasks(),
      floatingActionButton: _MyFloatingActionButton(),
    );
  }
}
