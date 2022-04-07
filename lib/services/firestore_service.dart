import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streaming_service/models/app_user.dart';

class FirestoreService {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static final CollectionReference<AppUser> _users =
      _instance.collection('users').withConverter(
            fromFirestore: (snapshot, _) =>
                AppUser.fromMap(snapshot.data() as Map<String, dynamic>),
            toFirestore: (user, _) => user.toMap(),
          );

  static Future<void> addUser(AppUser user) => _users.doc(user.uid).set(user);
  static Future<DocumentSnapshot<AppUser>> getUser(String id) =>
      _users.doc(id).get();
}
