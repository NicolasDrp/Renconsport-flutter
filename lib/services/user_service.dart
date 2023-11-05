import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/main.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String?> getCurrentToken() async {
    String? token = await _storage.read(key: "token");
    return token;
  }

  static Future<bool> checkValidity(String token) async {
    var response = await http.post(Uri.parse("$urlApi/api/users"), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode != 401) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getCurrentUserId() async {
    String? userId = await _storage.read(key: "id");
    return userId!;
  }

  static Future<User> fetchUserFuture(iri, token) async {
    var res = await http.get(
        Uri.parse("$urlApi$iri"),
        headers: {
          HttpHeaders.authorizationHeader: "bearer $token",
        });
    User user = User.fromJson(jsonDecode(res.body));
    return user;
  }

  static Future<List<User>> fetchUsers() async {
    final String? token = await UserService.getCurrentToken();
    if (token == null) {
      throw Exception(("Token not found"));
    }
    final response = await http.get(
        Uri.parse('$urlApi/api/users'),
        headers: {
          HttpHeaders.authorizationHeader: token,
        });

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return List.generate(result['hydra:member'].length, (i) {
        return User.fromJson(result['hydra:member'][i]);
      });
    } else {
      throw Exception('Failed to load Users');
    }
  }
}
