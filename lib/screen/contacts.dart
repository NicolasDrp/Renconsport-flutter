import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/modal/relation.dart';
import 'package:renconsport_flutter/services/relation_service.dart';
import 'package:renconsport_flutter/services/user_service.dart';
import 'package:renconsport_flutter/widget/custom_contact.dart';

class Contacts extends StatefulWidget {
  Contacts({super.key, required this.nav, required this.payload});

  final Function nav;
  final Map<String, dynamic> payload;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

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

                        String iri;
                        if (senderIsUser) {
                          iri = '/api/users/${relations[index].target}';
                        } else {
                          iri = '/api/users/${relations[index].sender}';
                        }
                        return FutureBuilder(
                            future: UserService.fetchUserFuture(
                                iri, UserService.getCurrentToken()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                } else if (snapshot.hasData) {
                                  return GestureDetector(
                                    child: CustomContact(user: snapshot.data!),
                                    onTap: () => widget.nav(8, payload),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              } else {
                                return Text("");
                              }
                            });
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
