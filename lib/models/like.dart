import 'dart:convert';

class Like {
  final String like;
  final String id;
  Like({
    required this.like,
    required this.id,
  });

  Like copyWith({
    String? like,
    String? id,
  }) {
    return Like(
      like: like ?? this.like,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'like': like});
    result.addAll({'id': id});

    return result;
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      like: map['like'] ?? '',
      id: map['\$id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Like.fromJson(String source) => Like.fromMap(json.decode(source));

  @override
  String toString() => 'Like(like: $like, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Like && other.like == like && other.id == id;
  }

  @override
  int get hashCode => like.hashCode ^ id.hashCode;
}
