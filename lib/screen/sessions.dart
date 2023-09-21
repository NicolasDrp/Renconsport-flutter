import 'package:flutter/material.dart';
import 'package:renconsport_flutter/widget/session_card.dart';

class Sessions extends StatefulWidget {
  const Sessions({super.key});
  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  int id = 1;
  String sportType = "Musculation";
  String username = "username";
  String date = "XX/XX/XX";
  String time = "XXhXX";
  String description = "Description";
  String length = "Durée : xx minutes";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
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
            SessionCard(
                sportType: sportType,
                username: username,
                date: date,
                time: time,
                description: description,
                length: length,
                id: id,
                isLastSession: false)
          ],
        ),
      ),
    );
  }
}
