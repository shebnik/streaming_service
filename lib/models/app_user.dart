import 'dart:convert';

class AppUser {
  final String email;
  final String uid;

  AppUser({
    required this.email,
    required this.uid,
  });

  AppUser copyWith({
    String? email,
    String? uid,
  }) {
    return AppUser(
      email: email ?? this.email,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'uid': uid,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      email: map['email'] as String,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) => AppUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AppUser(email: $email, uid: $uid)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppUser &&
      other.email == email &&
      other.uid == uid;
  }

  @override
  int get hashCode => email.hashCode ^ uid.hashCode;
}
