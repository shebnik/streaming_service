// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_service/models/artist.dart';
import 'package:streaming_service/models/track.dart';

class NapsterService {
  static late final String NAPSTER_API_KEY;
  static const String API_BASE = 'https://api.napster.com/v2.2';
  static const String topArtists = 'artists/top?limit=10';

  static const imageSizes = {
    'small': '150x100',
    'medium': '356x237',
    'large': '633x422',
  };

  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    NAPSTER_API_KEY = dotenv.env['NAPSTER_API_KEY']!;
  }

  static Future<String> makeApiCall(String url) async {
    final response = await http.get(Uri.parse(url), headers: {
      'apikey': NAPSTER_API_KEY,
    });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to make napster api call');
    }
  }

  static Future<List<Artist>> getTopArtists(int offset) async {
    final url = '$API_BASE/$topArtists&offset=$offset';
    final data = jsonDecode(await makeApiCall(url));
    return data['artists']
        .map((artist) => Artist.fromMap(artist))
        .toList()
        .cast<Artist>();
  }

  static String getArtistImage(String artistId, [String size = 'medium']) {
    return 'https://api.napster.com/imageserver/v2/artists/' +
        artistId +
        '/images/${imageSizes[size]}.jpg';
  }

  static Future<List<Track>> getArtistTopTracks(
      String artistId, int offset) async {
    final url = '$API_BASE/artists/$artistId/tracks/top?limit=5&offset=$offset';
    final data = jsonDecode(await makeApiCall(url));
    return data['tracks']
        .map((track) => Track.fromMap(track))
        .toList()
        .cast<Track>();
  }

  static String getTrackImage(String albumId) {
    return 'https://api.napster.com/imageserver/v2/albums/' +
        albumId +
        '/images/170x170.jpg';
  }

  static Future<List<Artist>> searchArtists(String query, int offset) async {
    final url =
        '$API_BASE/search?query=$query&type=artist&per_type_limit=5&offset=$offset';
    final data = jsonDecode(await makeApiCall(url));
    return data['search']['data']['artists']
        .map((artist) => Artist.fromMap(artist))
        .toList()
        .cast<Artist>();
  }
}
