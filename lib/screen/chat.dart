import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/services/database.dart';
import 'package:renconsport_flutter/services/user_service.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, required this.nav});

  final Function nav;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController controller = TextEditingController();
  final Stream<QuerySnapshot> massagesStream =
      CustomDatabase.streamData(CustomDatabase.chats);
  String id = "ersdfftgyhujikolpm1";

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
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      print(id);
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return (data['sender'] == id)
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Text(data['text']))
                          : Text(data['text']);
                    })
                    .toList()
                    .cast(),
              ),
            );
          },
        ),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'New message',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            sendMessage(controller.text);
            controller.clear();
          },
          child: const Text('Send'),
        ),
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
