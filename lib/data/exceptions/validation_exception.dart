import 'dart:convert';

class ValidationException implements Exception {
  final List<String> _message;

  ValidationException(this._message);

  factory ValidationException.fromJson(String source) {
    Map<String, dynamic> error = json.decode(source);
    return ValidationException(error['message']);
  }

  @override
  String toString() => _message.join('\n');
}
