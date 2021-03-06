import 'package:flutter/material.dart';
import 'package:flutter_todo_app/providers/todo_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo_app/providers/auth.dart';
import 'package:flutter_todo_app/screens/home_screen.dart';
import 'package:flutter_todo_app/screens/login_screen.dart';
import 'package:flutter_todo_app/screens/register_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Auth()),
      ProxyProvider<Auth, TodoList>(
        update: (context, auth, previous) => previous..token = auth.token,
        create: (context) => TodoList(context.read<Auth>().token),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Consumer<Auth>(
        builder: (context, auth, child) =>
            auth.isAuthenticated ? HomeScreen() : LoginScreen(),
      ),
      routes: {
        LoginScreen.routeName: (_) => LoginScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
      },
    );
  }
}
