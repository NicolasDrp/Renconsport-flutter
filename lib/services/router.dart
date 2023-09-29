import 'package:flutter/material.dart';
import 'package:renconsport_flutter/screen/Register.dart';
import 'package:renconsport_flutter/screen/chat.dart';
import 'package:renconsport_flutter/screen/contacts.dart';
import 'package:renconsport_flutter/screen/homepage.dart';
import 'package:renconsport_flutter/screen/login.dart';
import 'package:renconsport_flutter/screen/parameters.dart';
import 'package:renconsport_flutter/screen/profile.dart';
import 'package:renconsport_flutter/screen/profile_settings.dart';
import 'package:renconsport_flutter/screen/sessions.dart';

class CustomRouter extends StatefulWidget {
  CustomRouter({super.key, required this.nav, required this.index, required this.payload});

  final int index;
  final Function nav;
  final Map<String, dynamic> payload;

  static final List<String> tutorialList = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    ""
  ];
  @override
  State<CustomRouter> createState() => _CustomRouterState();
}

class _CustomRouterState extends State<CustomRouter> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> pageList = [
      HomePage(nav: widget.nav),
      const Sessions(),
      Contacts(nav: widget.nav),
      Profile(nav: widget.nav, payload: widget.payload),
      Parameters(nav: widget.nav),
      Login(nav: widget.nav),
      Register(nav: widget.nav),
      ProfileSettings(nav: widget.nav),
      Chat(nav: widget.nav, payload: widget.payload),
    ];

    return pageList[widget.index];
  }
}
