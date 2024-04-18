import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../pages/home.dart';

class CredService {

  void login(dynamic credential, context) {

    if (credential.runtimeType != User) {

      FirebaseAuthException error = credential as FirebaseAuthException;

      if (kDebugMode) {
        print('error signing in');
        print(error.toString());
        print(error.runtimeType);
      }

      String errorText = error.message.toString();
      if (error.code == "unknown-error") errorText = "Invalid inputs";

      showDialog(
          context: context,
          builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Credentials'),
          content: Text(errorText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      });
    } else {

      if (kDebugMode) {
        print("signed in");
        print(credential);
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

    }
  }

  void register(dynamic credential, context) {

    if (credential.runtimeType != User) {

      FirebaseAuthException error = credential as FirebaseAuthException;

      if (kDebugMode) {
        print('error registering in');
        print(error.toString());
        print(error.runtimeType);
      }

      String errorText = error.message.toString();
      if (error.code == "unknown-error") errorText = "Invalid inputs";

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Credentials'),
              content: Text(errorText),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          });

    } else {

      if (kDebugMode) {
        print("successful registered");
        print(credential);
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }
}