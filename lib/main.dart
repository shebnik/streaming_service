import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:streaming_service/firebase_options.dart';
import 'package:streaming_service/services/auth_service.dart';
import 'package:streaming_service/services/firestore_service.dart';
import 'package:streaming_service/services/hive_service.dart';
import 'package:streaming_service/services/napster_service.dart';
import 'package:streaming_service/services/extensions.dart';
import 'package:streaming_service/ui/pages/auth/landing_login_page.dart';
import 'package:streaming_service/ui/pages/home/home_page.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HiveService.initialize();
  await NapsterService.initialize();
  FirestoreService.setupListener();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      scaffoldMessengerKey: snackbarKey,
      theme: AppTheme.themeDark,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        LandingLoginPage.routeName: (context) => const LandingLoginPage(),
      },
      home: Builder(builder: (_) {
        AuthService.listenAuthState(_navigatorKey);
        return Container();
      }),
    );
  }
}
