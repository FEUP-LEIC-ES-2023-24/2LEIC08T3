import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInEmail(String email, String password) async {

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = credential.user;
      return user;
    } catch (e) {
      return e;
    }
  }


  Future registerEmail(String email, String password, String secondPassword) async {

    if (password != secondPassword) {
      FirebaseAuthException exception = FirebaseAuthException(
          code: "whatever",
          message: "Different passwords"
      );
      return exception;
    }

    try {

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      User? user = credential.user;
      return user;

    } catch (e) {
      return e;
    }
  }
}