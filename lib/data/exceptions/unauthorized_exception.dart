import 'dart:convert' show json;

class UnauthorizedException {
  final String _message;

  UnauthorizedException(this._message);

  factory UnauthorizedException.fromJson(String source) {
    Map<String, dynamic> error = json.decode(source);
    return UnauthorizedException(error['message'] ?? 'Expired session');
  }

  @override
  String toString() => _message;
}
