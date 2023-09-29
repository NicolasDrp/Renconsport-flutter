import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/services/database.dart';
import 'package:renconsport_flutter/services/user_service.dart';
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
  final Stream<QuerySnapshot> massagesStream =
      CustomDatabase.streamData(CustomDatabase.chats);
  String id = "";

  @override
  void initState() {
    super.initState();
    getId();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: massagesStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return Expanded(
              child: ListView(
                reverse: true,
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      print(id);
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

  void sendMessage(String text) async {
    String idUser = await UserService.getCurrentUserId();
    Map<String, dynamic> data = {
      'sender': idUser,
      'text': text,
      'time': DateTime.now().toIso8601String(),
    };
    CustomDatabase.addData(CustomDatabase.chats, data);
  }

  void getId() {
    UserService.getCurrentUserId().then((value) {
      setState(() {
        id = value;
      });
    });
  }
}
