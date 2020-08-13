import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class User {
  final int id;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    int id,
    String name,
    String email,
    DateTime createdAt,
    DateTime updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      createdAt: DateTime.tryParse(map['createdAt']),
      updatedAt: DateTime.tryParse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return '''User (
      id: $id,
      name: $name,
      email: $email,
      createdAt: $createdAt,
      updatedAt: $updatedAt)''';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is User && o.id == id && o.name == name && o.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode;
  }
}

class LoginException implements Exception {
  final String _message;

  LoginException(this._message);

  @override
  String toString() => _message;
}

class RegisterException implements Exception {
  final List<String> _messages;

  RegisterException(this._messages);

  @override
  String toString() => _messages.join('\n');
}

class Auth with ChangeNotifier, DiagnosticableTreeMixin {
  User _user;
  String _token;
  DateTime _loggedAt;

  bool get isAuthenticated => _token != null && _token.isNotEmpty;
  User get user => _user;
  DateTime get loggedAt => _loggedAt;

  Future<void> login(String email, String password) async {
    final payload = json.encode({
      'email': email,
      'password': password,
    });
    final response = await http.post(
      'https://nest-auth-example.herokuapp.com/auth/login',
      body: payload,
      headers: {
        'content-type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      _user = User.fromJson(response.body);
      _loggedAt = DateTime.now();
      _token = response.headers['authorization'].split(' ').last;
      notifyListeners();
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw new LoginException(data['message']);
    }
  }

  Future<void> register(String name, String email, String password) async {
    final payload = json.encode({
      'name': name,
      'email': email,
      'password': password,
    });
    final response = await http.post(
      'https://nest-auth-example.herokuapp.com/auth/register',
      body: payload,
      headers: {
        'content-type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      _user = User.fromJson(response.body);
      _loggedAt = DateTime.now();
      _token = response.headers['authorization'].split(' ').last;
      notifyListeners();
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      throw new RegisterException(List<String>.from(data['message']));
    }
  }

  logout() {
    _user = null;
    _token = null;
    _loggedAt = null;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty<User>('user', user));
    properties.add(StringProperty('token', _token));
    properties.add(DiagnosticsProperty('loggedAt', loggedAt));
    super.debugFillProperties(properties);
  }
}
