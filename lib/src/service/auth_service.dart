import 'package:fingerpay/src/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          .updateUserData(0, 'User', '00000000');
      return userCredential.user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print(e);
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
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      print("User: $userCredential");
      return userCredential.user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  // Sign out
  signOut() {
    return _firebaseAuth.signOut();
  }
}
