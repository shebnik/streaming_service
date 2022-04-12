import 'dart:convert';

import 'package:flutter/foundation.dart';

class AppUser {
  final String email;
  final String uid;
  final List<FavouriteTrack> favouriteTracks;

  AppUser({
    required this.email,
    required this.uid,
    required this.favouriteTracks,
  }); 

  AppUser copyWith({
    String? email,
    String? uid,
    List<FavouriteTrack>? favouriteTracks,
  }) {
    return AppUser(
      email: email ?? this.email,
      uid: uid ?? this.uid,
      favouriteTracks: favouriteTracks ?? this.favouriteTracks,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'email': email});
    result.addAll({'uid': uid});
    result.addAll({'favouriteTracks': favouriteTracks.map((x) => x.toMap()).toList()});
  
    return result;
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      favouriteTracks: List<FavouriteTrack>.from(map['favouriteTracks']?.map((x) => FavouriteTrack.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) => AppUser.fromMap(json.decode(source));

  @override
  String toString() => 'AppUser(email: $email, uid: $uid, favouriteTracks: $favouriteTracks)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppUser &&
      other.email == email &&
      other.uid == uid &&
      listEquals(other.favouriteTracks, favouriteTracks);
  }

  @override
  int get hashCode => email.hashCode ^ uid.hashCode ^ favouriteTracks.hashCode;
}

class FavouriteTrack {
  final String id;
  final String timeAdded;

  FavouriteTrack({
    required this.id,
    required this.timeAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timeAdded': timeAdded,
    };
  }

  static FavouriteTrack fromMap(Map<String, dynamic> map) {
    return FavouriteTrack(
      id: map['id'],
      timeAdded: map['timeAdded'],
    );
  }
}
