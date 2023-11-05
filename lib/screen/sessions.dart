import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/modal/session.dart';
import 'package:renconsport_flutter/services/session_service.dart';
import 'package:renconsport_flutter/widget/session_card.dart';
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
              future: SessionService.fetchSessions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (snapshot.hasData) {
                    List<Session> sessions = snapshot.data!;
                    return Expanded(
                      child: ListView.builder(
                          itemCount: sessions.length,
                          itemBuilder: (context, index) {
                            final String date = DateFormat('dd-MM-yyyy')
                                .format(sessions[index].dateTime);
                            final String time = DateFormat('kk:mm')
                                .format(sessions[index].dateTime);
                            final String name =
                                sessions[index].creator?.username ?? 'Anonyme';
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: SessionCard(
                                sportType: sessions[index].iriSportType,
                                username: name,
                                date: date,
                                time: time,
                                description: sessions[index].description,
                                length: sessions[index].duration,
                                id: sessions[index].id,
                                isLastSession: false,
                              ),
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
}
