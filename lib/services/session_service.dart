import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/modal/session.dart';
import 'package:http/http.dart' as http;

class SessionService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<List<Session>> fetchSessions() async {
    String? token = await _storage.read(key: "token");
    if (token == null) {
      throw Exception(("Token not found"));
    }
    final response = await http.get(
        Uri.parse('https://renconsport-api.osc-fr1.scalingo.io/api/sessions'),
        headers: {
          HttpHeaders.authorizationHeader: "bearer $token",
        });

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return List.generate(result['hydra:member'].length, (i) {
        return Session.fromJson(result['hydra:member'][i]);
      });
    } else {
      throw Exception(response.body);
    }
  }
}
