import 'dart:convert';

import 'package:flutter/foundation.dart';

class Artist {
  final String id;
  final String name;
  final List<String> blurbs;
  Artist({
    required this.id,
    required this.name,
    required this.blurbs,
  });

  Artist copyWith({
    String? id,
    String? name,
    List<String>? blurbs,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      blurbs: blurbs ?? this.blurbs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'blurbs': blurbs,
    };
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      id: map['id'] as String,
      name: map['name'] as String,
      blurbs: List<String>.from(map['blurbs']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Artist.fromJson(String source) =>
      Artist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Artist(id: $id, name: $name, blurbs: $blurbs)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Artist &&
        other.id == id &&
        other.name == name &&
        listEquals(other.blurbs, blurbs);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ blurbs.hashCode;
}
