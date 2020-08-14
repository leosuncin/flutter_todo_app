import 'dart:convert';

import 'package:flutter_todo_app/data/exceptions/unauthorized_exception.dart';
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
    } else if (response.statusCode == 401) {
      throw new UnauthorizedException.fromJson(response.body);
    } else {
      Map<String, dynamic> error = json.decode(response.body);
      throw new Exception(error['message']);
    }

    return result;
  }
}
