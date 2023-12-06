import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenication {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static Future<String?> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Successful";
    } catch (e) {
      if (e is FirebaseException) {
        return (e.message);
      }
    }
    return null;
  }

  static Future<String?> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Successful";
    } catch (e) {
      if (e is FirebaseException) {
        return (e.message);
      }
    }
    return null;
  }

  static selectLoginOrSIgnUp(
      {required bool isLogin,
      required String email,
      required String password}) {
    return isLogin
        ? loginWithEmailAndPassword(email: email, password: password)
        : signUpWithEmailAndPassword(email: email, password: password);
  }
}
