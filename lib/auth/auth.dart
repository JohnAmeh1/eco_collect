import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class CustomUser {
  CustomUser({required this.uid, required this.email});

  final String uid;
  final String? email;
}

final FirebaseAuth _auth = FirebaseAuth.instance;
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;

abstract class AuthBase {
  Stream<CustomUser?> get onAuthStateChanged;
  Future<CustomUser?> currentUser();
  Future<void> signOut();
  // Future<CustomUser?> signInWithGoogle();
  Future<CustomUser?> signInWithEmailAndPassword(String email, String password);
  Future<CustomUser?> createUserWithEmailAndPassword(
    String email,
    String password,
  );
}

class Auth implements AuthBase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CustomUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return CustomUser(uid: user.uid, email: user.email);
  }

  @override
  Stream<CustomUser?> get onAuthStateChanged {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  // @override
  // Future<CustomUser?> signInWithGoogle() async {
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //   final GoogleSignInAccount? googleSignInAccount =
  //       await googleSignIn.signIn();
  //   if (googleSignInAccount != null) {
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleSignInAccount.authentication;
  //     if (googleAuth.accessToken != null && googleAuth.idToken != null) {
  //       final authresult = await _auth.signInWithCredential(
  //         GoogleAuthProvider.credential(
  //           idToken: googleAuth.idToken,
  //           accessToken: googleAuth.accessToken,
  //         ),
  //       );
  //       return _userFromFirebase(authresult.user);
  //     } else {
  //       throw PlatformException(
  //           code: 'ERROR_MISSSING_GOOGLE_AUTH_TOKEN',
  //           message: 'Missing Google Auth Token');
  //     }
  //   } else {
  //     throw PlatformException(
  //       code: 'ERROR_ABORTED_BY_USER',
  //       message: 'Sign in aborted by user',
  //     );
  //   }
  // }

  @override
  Future<CustomUser?> currentUser() async {
    final user = _auth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<CustomUser?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(authResult.user);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
  }

  @override
  Future<CustomUser?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(authResult.user);
    } on FirebaseAuthException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    }
  }

  @override
  Future<void> signOut() async {
    // final googleSignIn = GoogleSignIn();
    // await googleSignIn.signOut();
    await _auth.signOut();
  }
}
