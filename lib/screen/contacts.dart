import 'package:flutter/material.dart';
import 'package:renconsport_flutter/modal/relation.dart';
import 'package:renconsport_flutter/services/relation_service.dart';
import 'package:renconsport_flutter/widget/custom_contact.dart';

class Contacts extends StatefulWidget {
  Contacts({super.key, required this.nav, required this.payload});

  final Function nav;
  final Map<String, dynamic> payload;

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.all(12.0),
        child: Center(
            child: Text("Discussions",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400))),
      ),
      FutureBuilder<List<Relation>>(
          future: RelationService.fetchRelationsByCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.hasData) {
                List<Relation> relations = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                      itemCount: relations.length,
                      itemBuilder: (context, index) {
                        bool senderIsUser =
                            relations[index].sender == widget.payload['id'];
                        Map<String, dynamic> payload = {
                          'id': relations[index].id,
                          'connectedUser': widget.payload['id'],
                        };
                        return GestureDetector(
                          child: CustomContact(
                              id: (senderIsUser)
                                  ? relations[index].target
                                  : relations[index].sender,
                              isNew: true),
                          onTap: () async {
                            widget.nav(8, payload);
                          },
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
    ]);
  }
}
