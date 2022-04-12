import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:streaming_service/models/app_user.dart';
import 'package:streaming_service/services/firestore_service.dart';
import 'package:streaming_service/services/hive_service.dart';
import 'package:streaming_service/ui/pages/auth/landing_login_page.dart';
import 'package:streaming_service/ui/pages/home/home_page.dart';

enum AuthType {
  createAccount,
  login,
  facebook,
  google,
}

class AuthService {
  static final FirebaseAuth _instance = FirebaseAuth.instance;

  static String? getUserId() => _instance.currentUser?.uid;

  static void listenAuthState(GlobalKey<NavigatorState> navigatorKey) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil(LandingLoginPage.routeName, (_) => false);
      } else {
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil(HomePage.routeName, (_) => false);
      }
    });
  }

  static Future<void> signOut() async {
    FirestoreService.detachListener();
    await HiveService.getFavouritesBox().then((value) => value.clear());
    await _instance.signOut();
  }

  static Future<String?> signIn(
    AuthType authType, {
    String? email,
    String? password,
  }) async {
    UserCredential? userCredential;
    try {
      // Email and password sign in
      if (authType == AuthType.createAccount || authType == AuthType.login) {
        if (email == null && password == null) {
          return "Email and password are required";
        }
        userCredential = authType == AuthType.createAccount
            ? await _instance.createUserWithEmailAndPassword(
                email: email!,
                password: password!,
              )
            : await _instance.signInWithEmailAndPassword(
                email: email!,
                password: password!,
              );
      }
      // Facebook sign in
      else if (authType == AuthType.facebook) {
        userCredential = await _signInWithFacebook();
      }
      // Google sign in
      else if (authType == AuthType.google) {
        userCredential = await _signInWithGoogle();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return e.message;
    }

    if (userCredential == null || userCredential.user == null) {
      return "Login failed. Please try again later.";
    }

    final User user = userCredential.user!;
    final bool exists = await FirestoreService.userExists(user.uid);
    if (!exists) {
      await FirestoreService.addUser(
        AppUser(
          uid: user.uid,
          email: user.email ?? '',
          favouriteTracks: [],
        ),
      );
    }
    FirestoreService.setupListener();
    return null;
  }

  static Future<UserCredential> _signInWithFacebook() async {
    if (kIsWeb) {
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();

      facebookProvider.addScope('email');
      facebookProvider.setCustomParameters({
        'display': 'popup',
      });

      return FirebaseAuth.instance.signInWithPopup(facebookProvider);
    }
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  static Future<UserCredential> _signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({
        'login_hint': 'user@example.com',
      });

      return FirebaseAuth.instance.signInWithPopup(googleProvider);
    }
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return FirebaseAuth.instance.signInWithCredential(credential);
  }
}
