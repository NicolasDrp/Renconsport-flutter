import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/main.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:renconsport_flutter/modal/sporttype.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:adaptive_theme/adaptive_theme.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.nav});

  final Function nav;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Stack(children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 80, 0, 0),
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                color: AdaptiveTheme.of(context).theme.primaryColor,
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      snapshot.data!.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "${snapshot.data!.age}, ${snapshot.data!.city}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Center(
                      child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    width: 340,
                    child: Column(children: [
                      Center(
                        child: Text(
                          "A propos de moi",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${snapshot.data!.bio}",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )),
                      )
                    ]),
                  )),
                  FutureBuilder<List<String>>(
                    future: fetchSports(snapshot.data!),
                    builder: (context, snapshotlist) {
                      if (snapshotlist.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show a loading indicator while fetching data.
                      } else if (snapshotlist.hasError) {
                        return Text('Error: ${snapshotlist.error}');
                      } else {
                        return Column(
                          children: snapshotlist.data!
                              .map((sportName) => Text(sportName))
                              .toList(),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
            Column(
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      (profileImage(snapshot.data!)),
                    ),
                    radius: 80,
                  ),
                ),
              ],
            ),
          ]);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Future<User> fetchUser() async {
    String? token = await storage.read(key: "token");
    if (token == null) {
      throw Exception(
          ("Token not found")); // Gérer le cas où le token n'est pas disponible
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final response = await http
        .get(Uri.parse("$urlApi/users/${decodedToken['id']}"), headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final result = jsonDecode(response.body);
      return User.fromJson(result);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load User');
    }
  }

  Future<List<String>> fetchSports(User user) async {
    String? token = await storage.read(key: "token");
    if (token == null) {
      throw Exception(
          ("Token not found")); // Gérer le cas où le token n'est pas disponible
    }
    List<String> sportNames = [];
    user.sportTypeList.forEach((sport_type) async {
      final response = await http.get(
          Uri.parse("https://renconsport-api.osc-fr1.scalingo.io${sport_type}"),
          headers: {
            HttpHeaders.authorizationHeader: token,
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final result = jsonDecode(response.body);
        final type_sport = SportType.fromJson(result);
        sportNames.add(type_sport.name);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load User');
      }
    });
    return sportNames;
  }

  String profileImage(User user) {
    if (user.avatarUrl != null) {
      return user.avatarUrl;
    } else {
      return "assets/placeholder_avatar.png";
    }
  }
}
