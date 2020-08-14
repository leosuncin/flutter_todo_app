import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo_app/components/todo/list_tasks.dart';
import 'package:flutter_todo_app/providers/auth.dart';
import 'package:flutter_todo_app/screens/login_screen.dart';

enum MenuActionOptions { Logout }

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
    );
  }
}
