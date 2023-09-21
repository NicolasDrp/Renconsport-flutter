import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionCard extends StatefulWidget {
  const SessionCard(
      {super.key,
      required this.sportType,
      required this.username,
      required this.date,
      required this.time,
      required this.description,
      required this.length,
      required this.id,
      required this.isLastSession});

  final int id;
  final String sportType;
  final String username;
  final String date;
  final String time;
  final String description;
  final int length;
  final bool isLastSession;

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: AdaptiveTheme.of(context).theme.canvasColor,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: AdaptiveTheme.of(context).theme.primaryColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 2,
              spreadRadius: 0.5,
              offset: Offset(0, 5),
            )
          ]),
      child: Column(
        children: [
          widget.isLastSession
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Ma dernière séance",
                    style: AdaptiveTheme.of(context).theme.textTheme.bodyLarge,
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/placeholder_avatar.png"),
                radius: 25,
              ),
              Column(
                children: [
                  Text(
                    widget.sportType,
                    style: AdaptiveTheme.of(context).theme.textTheme.bodyMedium,
                  ),
                  Text(
                    widget.username,
                    style: AdaptiveTheme.of(context).theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    widget.date,
                    style: AdaptiveTheme.of(context).theme.textTheme.bodySmall,
                  ),
                  Text(
                    widget.time,
                    style: AdaptiveTheme.of(context).theme.textTheme.bodySmall,
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              widget.description,
              style: AdaptiveTheme.of(context).theme.textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.length.toString(),
                style: AdaptiveTheme.of(context).theme.textTheme.bodySmall,
              ),
            ),
            // widget.isLastSession
            //     ? SizedBox(
            //         height: 0,
            //       )
            //     : OutlinedButton(
            //         style: OutlinedButton.styleFrom(
            //           side: BorderSide(
            //               color: AdaptiveTheme.of(context).theme.primaryColor),
            //         ),
            //         child: Text(
            //           "Rejoindre",
            //           style:
            //               AdaptiveTheme.of(context).theme.textTheme.labelMedium,
            //         ),
            //         onPressed: () {
            //           // TODO: implement joining sessions
            //         },
            //       ),
          ),
        ],
      ),
    );
  }
}
