import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:streaming_service/models/app_user.dart';
import 'package:streaming_service/services/firestore_service.dart';
import 'package:streaming_service/ui/pages/auth/landing_login_page.dart';
import 'package:streaming_service/ui/pages/home/home_page.dart';

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

  static Future<String?> createAccount(String email, String password) async {
    try {
      UserCredential userCredential =
          await _instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user == null) return 'Create account error';
      await FirestoreService.addUser(
        AppUser(
          uid: user.uid,
          email: user.email ?? '',
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  static Future<String?> login(String email, String password) async {
    try {
      await _instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return e.message.toString();
    }
    return null;
  }

  static Future<bool> signInFacebook() async {
    UserCredential? userCredential;
    if (kIsWeb) {
      userCredential = await _signInWithFacebookWeb();
    } else {
      userCredential = await _signInWithFacebook();
    }
    if (userCredential == null) return false;
    User? user = userCredential.user;
    if (user == null) {
      // AppUtils.showSnackBar(context, 'Login error');
      return false;
    }
    await FirestoreService.addUser(
      AppUser(
        uid: user.uid,
        email: user.email ?? '',
      ),
    );
    return true;
  }

  static Future<UserCredential?> _signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.accessToken == null) return null;

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  static Future<UserCredential?> _signInWithFacebookWeb() async {
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    facebookProvider.addScope('email');
    facebookProvider.setCustomParameters({
      'display': 'popup',
    });

    return await FirebaseAuth.instance.signInWithPopup(facebookProvider);
  }

  static Future<bool> signInGoogle(BuildContext context) async {
    UserCredential? userCredential;
    if (kIsWeb) {
      userCredential = await _signInWithGoogleWeb();
    } else {
      userCredential = await _signInWithGoogle();
    }
    if (userCredential == null) return false;
    User? user = userCredential.user;
    if (user == null) {
      // AppUtils.showSnackBar(context, 'Login error');
      return false;
    }
    await FirestoreService.addUser(
      AppUser(
        uid: user.uid,
        email: user.email ?? '',
      ),
    );
    return true;
  }

  static Future<UserCredential?> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    try {
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<UserCredential?> _signInWithGoogleWeb() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    try {
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<void> signOut() async => await _instance.signOut();
}
