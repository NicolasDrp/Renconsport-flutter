import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/main.dart';
import 'package:renconsport_flutter/modal/session.dart';
import 'package:renconsport_flutter/widget/session_card.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Sessions extends StatefulWidget {
  const Sessions({super.key});
  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Prochaine Sessions",
              style: TextStyle(fontSize: 26),
            ),
          ),
          FutureBuilder<List<Session>>(
              future: fetchSessions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (snapshot.hasData) {
                    List<Session> sessions = snapshot.data!;
                    // return Text("OK");
                    return Expanded(
                      child: ListView.builder(
                          itemCount: sessions.length,
                          itemBuilder: (context, index) {
                            final String date = DateFormat('dd-MM-yyyy')
                                .format(sessions[index].dateTime);
                            final String time = DateFormat('kk:mm')
                                .format(sessions[index].dateTime);
                            return SessionCard(
                              sportType: sessions[index].iriSportType,
                              username: sessions[index].iriUser,
                              date: date,
                              time: time,
                              description: sessions[index].description,
                              length: sessions[index].duration,
                              id: sessions[index].id,
                              isLastSession: false,
                            );
                          }),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                } else {
                  return CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }

  Future<List<Session>> fetchSessions() async {
    String? token = await storage.read(key: "token");
    if (token == null) {
      throw Exception(
          ("Token not found")); // Gérer le cas où le token n'est pas disponible
    }
    final response = await http.get(Uri.parse("$urlApi/sessions"), headers: {
      HttpHeaders.authorizationHeader: "bearer $token",
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final result = jsonDecode(response.body);
      print(result);
      return List.generate(result['hydra:member'].length, (i) {
        return Session.fromJson(result['hydra:member'][i]);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(response.body);
    }
  }
}
