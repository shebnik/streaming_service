import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streaming_service/models/app_user.dart';
import 'package:streaming_service/models/track.dart';
import 'package:streaming_service/services/auth_service.dart';
import 'package:streaming_service/services/hive_service.dart';
import 'package:streaming_service/services/napster_service.dart';

class FirestoreService {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static final CollectionReference<AppUser> _users =
      _instance.collection('users').withConverter(
            fromFirestore: (snapshot, _) =>
                AppUser.fromMap(snapshot.data() as Map<String, dynamic>),
            toFirestore: (user, _) => user.toMap(),
          );

  static Future<void> addUser(AppUser user) => _users.doc(user.uid).set(user);
  static Future<AppUser> getUser(String id) =>
      _users.doc(id).get().then((snapshot) => snapshot.data()!);
  static Future<bool> userExists(String id) =>
      _users.doc(id).get().then((doc) => doc.exists);

  static Future<void> addToFavourites(Track track) async {
    return await _users.doc(AuthService.getUserId()).update({
      'favouriteTracks': FieldValue.arrayUnion([
        FavouriteTrack(
          id: track.id,
          timeAdded: track.timeWhenAddedToFavourites!.toString(),
        ).toMap(),
      ])
    });
  }

  static Future<void> removeFromFavourites(Track track) async {
    return await _users.doc(AuthService.getUserId()).update({
      'favouriteTracks': FieldValue.arrayRemove([
        FavouriteTrack(
          id: track.id,
          timeAdded: track.timeWhenAddedToFavourites!.toString(),
        ).toMap(),
      ])
    });
  }

  static StreamSubscription<DocumentSnapshot<AppUser>>? streamSubscription;

  static void setupListener() {
    final uid = AuthService.getUserId();
    if (uid == null) return;

    streamSubscription = _users.doc(uid).snapshots().listen((snapshot) async {
      if (snapshot.exists) {
        final user = snapshot.data();
        if (user == null) return;
        List<String> trackIds = user.favouriteTracks.map((e) => e.id).toList();

        var tracksBox = await HiveService.getFavouritesBox();

        List<String> localTracks = tracksBox.keys.toList().cast<String>();
        for (var e in localTracks) {
          if (!trackIds.contains(e)) {
            await tracksBox.delete(e);
          }
        }

        trackIds.removeWhere((id) => tracksBox.containsKey(id));
        if (trackIds.isEmpty) return;
        List<Track> tracks = (await NapsterService.getTracks(trackIds))
            .map((e) => e.copyWith(
                  timeWhenAddedToFavourites: DateTime.parse(
                    user.favouriteTracks
                        .where((element) => element.id == e.id)
                        .first
                        .timeAdded,
                  ),
                ))
            .toList();
            
        tracksBox.putAll({
          for (var track in tracks) track.id: track,
        });
      }
    });
  }

  static void detachListener() {
    streamSubscription?.cancel();
  }
}
