import 'dart:convert';

class Todo {
  final int id;
  final String text;
  final bool done;
  final DateTime createdAt;
  final DateTime updatedAt;

  Todo({
    this.id,
    this.text,
    this.done: false,
    this.createdAt,
    this.updatedAt,
  });

  Todo copyWith({
    int id,
    String text,
    bool done,
    DateTime createdAt,
    DateTime updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      text: text ?? this.text,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'done': done,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Todo(
      id: map['id'],
      text: map['text'],
      done: map['done'],
      createdAt: DateTime.tryParse(map['createdAt']),
      updatedAt: DateTime.tryParse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

  @override
  String toString() {
    return '''Todo(
      id: $id,
      text: $text,
      done: $done,
      createdAt: $createdAt,
      updatedAt: $updatedAt)''';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Todo &&
        o.id == id &&
        o.text == text &&
        o.done == done &&
        o.createdAt == createdAt &&
        o.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        done.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
