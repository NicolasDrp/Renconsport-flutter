import 'package:flutter/material.dart';
import 'package:renconsport_flutter/modal/relation.dart';
import 'package:renconsport_flutter/services/relation_service.dart';
import 'package:renconsport_flutter/widget/custom_contact.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key, required this.nav});

  final Function nav;

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
                        return GestureDetector(
                          child: CustomContact(
                              name: relations[index].sender, isNew: true),
                          onTap: () async {
                            nav(8);
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
