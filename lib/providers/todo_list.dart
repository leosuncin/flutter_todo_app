import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_todo_app/data/todo.dart';

class TodoList {
  String _authToken;

  set token(String token) => _authToken = token;

  TodoList(this._authToken);

  Future<List<Todo>> fetchTodos() async {
    List<Todo> result = [];
    final response = await http.get(
      'https://nest-auth-example.herokuapp.com/todo',
      headers: {
        'Authorization': 'Bearer $_authToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      result = data.map((item) => Todo.fromMap(item)).toList();
    }

    return result;
  }
}
