import 'package:flutter/material.dart';
import 'package:renconsport_flutter/screen/contacts.dart';
import 'package:renconsport_flutter/screen/homepage.dart';
import 'package:renconsport_flutter/screen/login.dart';
import 'package:renconsport_flutter/screen/parameters.dart';
import 'package:renconsport_flutter/screen/profile.dart';
import 'package:renconsport_flutter/screen/sessions.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => Login(),
        '/profile': (context) => Profile(),
        '/sessions': (context) => Sessions(),
        '/parameters': (context) => Parameters(),
        '/contacts': (context) => Contacts(),
      },
    );
  }
}
