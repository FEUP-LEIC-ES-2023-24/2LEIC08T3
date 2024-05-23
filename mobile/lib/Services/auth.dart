import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:greenscan/Services/cred.dart';
import 'package:greenscan/Services/firebase.dart';
import 'package:greenscan/Services/dbUser.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? user; //firebase user info (credentials)
  static DbUser? dbUser; //firestore user info (custom info)

  static Future signInEmail(String email, String password, context) async {
    UserCredential credential;

    try {
    credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  } catch (e) {
    if (e is FirebaseException) {
      // Handle FirebaseException
      CredService.showErrorMsg(context, "Invalid Credentials", e.message);
    } else {
      // Re-throw the exception
      rethrow;
    }
    return;
  }

    user = credential.user;
    await DataBase.firebaseGetUser();
    CredService.login(context);
  }

  static Future registerEmail(String userName, String email, String password,
      String secondPassword, context) async {
    if (password != secondPassword) {
      CredService.showErrorMsg(
          context, "Invalid Credentials", "Passwords not matching");
      return;
    }

    if (userName.isEmpty) {
      CredService.showErrorMsg(
          context, "Invalid Credentials", "User name empty");
      return;
    }

    UserCredential credential;

    try {
      credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      e as FirebaseAuthException;
      CredService.showErrorMsg(context, "Invalid Credentials", e.message);
      return;
    }

    user = credential.user;

    try {
      await user!.updateDisplayName(userName);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    dbUser = DbUser(name: userName, email: email);
    await DataBase.firebaseAddUser();

    CredService.register(context);
  }
}
