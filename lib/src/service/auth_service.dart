import 'package:fingerpay/src/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAAuthStateChanged =>
      _firebaseAuth.authStateChanges().map(
            (User user) => user?.uid,
          );

  //GET UID
  Future<String> getCurrentUID() async {
    return _firebaseAuth.currentUser.uid;
  }

  //GET CURRENT USER
  Future<void> getCurrent() async {
    return _firebaseAuth.currentUser;
  }

  //Create user with Email and Password
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Update the username
      await userCredential.user.updateProfile(displayName: name);
      await DatabaseService(uid: userCredential.user.uid)
          .updateUserData(0, name, '00000000');
      return userCredential.user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: 'The password provided is too weak.',
          gravity: ToastGravity.CENTER,
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: 'The account already exists for that email.',
          gravity: ToastGravity.CENTER,
        );
      } else {
        Fluttertoast.showToast(
          msg: e.message,
          gravity: ToastGravity.CENTER,
        );
      }
      return null;
    }
  }

  // Update the username
  Future updateUserName(String name, User currentuser) async {
    await currentuser.updateProfile(displayName: name);
    await currentuser.reload();
  }

  Future<String> anonymousLogin() async {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    await DatabaseService(uid: userCredential.user.uid)
        .updateUserData(0, 'Anonymous', '00000000');
    return userCredential.user.uid;
  }

  // Sign in with email and password
  Future<String> sinInWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: 'No user found for that email.',
          gravity: ToastGravity.CENTER,
        );
      } else if (exception.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: 'Wrong password provided for that user.',
          gravity: ToastGravity.CENTER,
        );
      } else {
        Fluttertoast.showToast(
          msg: exception.message,
          gravity: ToastGravity.CENTER,
        );
      }
    } on PlatformException catch (exception) {
      if (exception.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: 'No user found for that email.',
          gravity: ToastGravity.CENTER,
        );
      } else if (exception.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: 'Wrong password provided for that user.',
          gravity: ToastGravity.CENTER,
        );
      } else {
        Fluttertoast.showToast(
          msg: exception.message,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (error) {
      print(error.toString());
    }
    print("User: $userCredential");
    return userCredential.user.uid;
  }

  // Sign out
  signOut() {
    return _firebaseAuth.signOut();
  }
}
