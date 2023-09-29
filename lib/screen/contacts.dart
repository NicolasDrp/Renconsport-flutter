import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:renconsport_flutter/services/user_service.dart';
import 'package:renconsport_flutter/widget/custom_contact.dart';
import 'package:http/http.dart' as http;

class Contacts extends StatelessWidget {
  const Contacts({super.key, required this.nav});

  final Function nav;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Center(
              child: Text("Discussions",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400))),
        ),
        GestureDetector(
          child: CustomContact(name: "Haroun tounde", isNew: true),
          onTap: () async {
            nav(8);
          },
        ),
      ],
    );
  }
}
