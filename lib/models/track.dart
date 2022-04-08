// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Track {
  final String id;
  final String name;
  final String artistId;
  final String artistName;
  final String albumName;
  final String albumId;
  final String previewURL;
  
  Track({
    required this.id,
    required this.name,
    required this.artistId,
    required this.artistName,
    required this.albumName,
    required this.albumId,
    required this.previewURL,
  });

  Track copyWith({
    String? id,
    String? name,
    String? artistId,
    String? artistName,
    String? albumName,
    String? albumId,
    String? previewURL,
  }) {
    return Track(
      id: id ?? this.id,
      name: name ?? this.name,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      albumName: albumName ?? this.albumName,
      albumId: albumId ?? this.albumId,
      previewURL: previewURL ?? this.previewURL,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'artistId': artistId,
      'artistName': artistName,
      'albumName': albumName,
      'albumId': albumId,
      'previewURL': previewURL,
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] as String,
      name: map['name'] as String,
      artistId: map['artistId'] as String,
      artistName: map['artistName'] as String,
      albumName: map['albumName'] as String,
      albumId: map['albumId'] as String,
      previewURL: map['previewURL'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Track.fromJson(String source) => Track.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Track(id: $id, name: $name, artistId: $artistId, artistName: $artistName, albumName: $albumName, albumId: $albumId, previewURL: $previewURL)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Track &&
      other.id == id &&
      other.name == name &&
      other.artistId == artistId &&
      other.artistName == artistName &&
      other.albumName == albumName &&
      other.albumId == albumId &&
      other.previewURL == previewURL;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      artistId.hashCode ^
      artistName.hashCode ^
      albumName.hashCode ^
      albumId.hashCode ^
      previewURL.hashCode;
  }
}
