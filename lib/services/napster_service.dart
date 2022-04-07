import 'package:flutter_dotenv/flutter_dotenv.dart';

class NapsterService {
  // ignore: non_constant_identifier_names
  static late final String NAPSTER_API_KEY;

  Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    NAPSTER_API_KEY = dotenv.env['NAPSTER_API_KEY']!;
  }
}
