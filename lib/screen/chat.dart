import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/services/database.dart';
import 'package:renconsport_flutter/widget/bubble.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, required this.nav, required this.payload});

  final Function nav;
  final Map<String, dynamic> payload;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController controller = TextEditingController();
  late Stream<QuerySnapshot> messagesStream;
  late String id;

  @override
  void initState() {
    super.initState();
    setState(() {
      id = widget.payload["connectedUser"];
      messagesStream =
          CustomDatabase.streamData(CustomDatabase.chats, widget.payload['id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: messagesStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Une erreur s'est produite");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Chargement des messages...");
            }

            return Expanded(
              child: ListView(
                reverse: true,
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return (data['sender'] == id)
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Bubble(
                                  isReceived: false,
                                  message: data['text'],
                                  time: data['time']))
                          : Bubble(
                              isReceived: true,
                              message: data['text'],
                              time: data['time']);
                    })
                    .toList()
                    .cast(),
              ),
            );
          },
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width * 0.7,
            height: 70,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                        color: AdaptiveTheme.of(context).theme.hintColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                        color: AdaptiveTheme.of(context).theme.hintColor)),
                labelText: 'Message',
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                sendMessage(controller.text);
                controller.clear();
              },
              icon: Icon(
                Icons.send,
                color: AdaptiveTheme.of(context).theme.hintColor,
              ))
        ])
      ],
    );
  }

  void sendMessage(String text) {
    Map<String, dynamic> data = {
      'sender': widget.payload['connectedUser'],
      'text': text,
      'time': DateTime.now().toIso8601String(),
    };
    CustomDatabase.addData(CustomDatabase.chats, data, widget.payload["id"]);
  }
}
