// ignore_for_file: constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';
import 'package:streaming_service/models/track.dart';

class HiveService {
  static const FAVOURITES_KEY = 'FAVOURITES';

  static initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TrackAdapter());
  }

  static Future<Box<Track>> getFavouritesBox() async =>
      await Hive.openBox(FAVOURITES_KEY);

}
