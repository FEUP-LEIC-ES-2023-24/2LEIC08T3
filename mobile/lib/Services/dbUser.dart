import 'package:flutter/foundation.dart';

class DbUser {
  final String name;
  final String email;
  final bool admin;

  DbUser({required this.name, required this.email, this.admin = false});

  static Future<DbUser?> buildUserDB(Map<String, dynamic>? data) async {
    if (data == null) return null;

    if (!(data.containsKey("name") ||
        data.containsKey("email") ||
        data.containsKey("admin"))) return null;

    return DbUser(
        name: data["name"], email: data["email"], admin: data["admin"]);
  }
}
