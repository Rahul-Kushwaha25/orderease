import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';



abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get onAuthStateChanged;
}


class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(
      this._firebaseAuth,
      this._googleSignIn,
      );

  @override
  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google Sign-In aborted by user');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user == null) {
      throw Exception('Firebase Sign-In failed');
    }

    return UserModel(
      uid: user.uid,
      displayName: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final User? user = _firebaseAuth.currentUser;
    debugPrint("RX1106 Firebase user => ${user?.email}");
    debugPrint("RX1106 Firebase uid => ${user?.uid}");
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      displayName: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );
  }

  @override
  Stream<UserModel?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel(
        uid: user.uid,
        displayName: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL,
      );
    });
  }
}

// @lazySingleton
// class AuthRemoteDataSource {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//   Future<UserModel?> get currentUser async {
//     final user = _firebaseAuth.currentUser;
//     if (user == null) return null;
//     return UserModel(
//       uid: user.uid,
//       displayName: user.displayName ?? '',
//       email: user.email ?? '',
//       photoUrl: user.photoURL,
//     );
//   }
//
//   Future<UserModel> signInWithGoogle() async {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) {
//       throw Exception('Google Sign-In aborted by user');
//     }
//
//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//
//     final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
//     final User? user = userCredential.user;
//
//     if (user == null) {
//       throw Exception('Firebase Sign-In failed');
//     }
//
//     return UserModel(
//       uid: user.uid,
//       displayName: user.displayName ?? '',
//       email: user.email ?? '',
//       photoUrl: user.photoURL,
//     );
//   }
//
//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     await _firebaseAuth.signOut();
//   }
// }
