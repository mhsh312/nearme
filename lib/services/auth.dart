import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/foundation.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during Anonymous Sign-In: ${e.code}');
      print('Message: ${e.message}');
    }
  }

  Future<void> googleLogin() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(authCredential);
    } on FirebaseAuthException catch (e) {
      print('Error occured: $e');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

// class GoogleAuthService {
//   final _googleSignIn = GoogleSignIn.instance;
//   bool _isGoogleSignInInitialized = false;
//   GoogleSignInAccount? _currentUser;
//   GoogleSignInAccount? get currentUser => _currentUser;
//   bool get isSignedIn => _currentUser != null;

//   GoogleAuthService() {
//     _initializeGoogleSignIn();
//   }

//   Future<void> _initializeGoogleSignIn() async {
//     try {
//       await _googleSignIn.initialize();
//       _isGoogleSignInInitialized = true;
//     } catch (e) {
//       print('Failed to initialize Google Sign-In: $e');
//     }
//   }

//   /// Always check Google sign in initialization before use
//   Future<void> _ensureGoogleSignInInitialized() async {
//     if (!_isGoogleSignInInitialized) {
//       await _initializeGoogleSignIn();
//     }
//   }

//   Future<GoogleSignInAccount> signInWithGoogle() async {
//     await _ensureGoogleSignInInitialized();

//     try {
//       // authenticate() throws exceptions instead of returning null
//       final GoogleSignInAccount account = await _googleSignIn.authenticate(
//         scopeHint: ['email'], // Specify required scopes
//       );
//       return account;
//     } on GoogleSignInException catch (e) {
//       print('Google Sign In Error: $e');
//       rethrow;
//     } catch (error) {
//       print('Unexpected Google Sign-In error: $error');
//       rethrow;
//     }
//   }

//   Future<void> signIn() async {
//     try {
//       _currentUser = await signInWithGoogle();
//       // Manually notify listeners or update state
//     } catch (error) {
//       _currentUser = null;
//       rethrow;
//     }
//   }
// }
