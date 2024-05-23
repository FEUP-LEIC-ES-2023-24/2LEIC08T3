import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greenscan/Services/auth.dart';

import '../pages/home.dart';

class CredService {
  static void showErrorMsg(context, tittle, text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tittle),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void login(context) {
    if (AuthService.dbUser == null) {
      if (kDebugMode) {
        print("error getting firestore user");
      }
      showErrorMsg(
          context, "Database Error", "There was an error in the database");
      return;
    }

    if (AuthService.user == null) {
      if (kDebugMode) {
        print("error getting authentication user");
      }
      showErrorMsg(
          context, "Database Error", "There was an error in the database");
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage()));
  }

  static void register(context) {
    if (AuthService.dbUser == null) {
      if (kDebugMode) {
        print("error getting firestore user");
      }
      showErrorMsg(
          context, "Database Error", "There was an error in the database");
      return;
    }

    if (AuthService.user == null) {
      if (kDebugMode) {
        print("error getting authentication user");
      }
      showErrorMsg(
          context, "Database Error", "There was an error in the database");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage()),
    );
  }
}
