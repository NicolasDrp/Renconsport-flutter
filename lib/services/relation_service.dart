import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/main.dart';
import 'package:renconsport_flutter/modal/relation.dart';
import 'package:http/http.dart' as http;
import 'package:renconsport_flutter/modal/user.dart';
import 'package:renconsport_flutter/services/user_service.dart';

class RelationService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<List<Relation>> fetchRelations() async {
    String? token = await _storage.read(key: "token");
    if (token == null) {
      throw Exception(("Token not found"));
    }
    final response = await http.get(Uri.parse("$urlApi/relations"), headers: {
      HttpHeaders.authorizationHeader: "bearer $token",
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final result = jsonDecode(response.body);
      print(result);
      return List.generate(result['hydra:member'].length, (i) {
        return Relation.fromJson(result['hydra:member'][i]);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(response.body);
    }
  }

  static Future<Relation> fetchRelationFuture(iri, token) async {
    var res = await http.get(
        Uri.parse("https://renconsport-api.osc-fr1.scalingo.io$iri"),
        headers: {
          HttpHeaders.authorizationHeader: "bearer $token",
        });
    Relation relation = Relation.fromJson(jsonDecode(res.body));
    return relation;
  }

  static Future<List<Relation>> fetchRelationsByCurrentUser() async {
    String? token = await _storage.read(key: "token");
    String? id = await _storage.read(key: "id");
    String iri = '/api/users/$id';
    User user = await UserService.fetchUserFuture(iri, token);
    List<Relation> relationList = user.relationList + user.targetRelationList;
    return relationList;
  }
}
