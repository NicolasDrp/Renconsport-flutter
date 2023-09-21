import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/main.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String> getCurrentToken() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    return token!;
  }

  static Future<bool> checkValidity(String token) async {
    var response = await http.post(Uri.parse("$urlApi/users"), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode != 401) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getCurrentUserId() async {
    String? userId = await _storage.read(key: "id");
    return userId!;
  }

  static Future<User> fetchUserFuture(iri, token) async {
    var res = await http.get(
        Uri.parse("https://renconsport-api.osc-fr1.scalingo.io$iri"),
        headers: {
          HttpHeaders.authorizationHeader: "bearer $token",
        });
    User user = User.fromJson(jsonDecode(res.body));
    return user;
  }
}
