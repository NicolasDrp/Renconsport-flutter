import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String> getCurrentToken() async {
    String? token = await _storage.read(key: "token");
    return token!;
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
