import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/screen/contacts.dart';
import 'package:renconsport_flutter/screen/homepage.dart';
import 'package:renconsport_flutter/screen/login.dart';
import 'package:renconsport_flutter/screen/parameters.dart';
import 'package:renconsport_flutter/screen/profile.dart';
import 'package:renconsport_flutter/screen/sessions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage storage = FlutterSecureStorage();
  runApp(MainApp(storage: storage));
}

class MainApp extends StatelessWidget {
  final FlutterSecureStorage storage;

  MainApp({required this.storage, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => HomePage(storage: storage),
        '/login': (context) => Login(storage: storage),
        '/profile': (context) => Profile(storage: storage),
        '/sessions': (context) => Sessions(storage: storage),
        '/parameters': (context) => Parameters(storage: storage),
        '/contacts': (context) => Contacts(storage: storage),
      },
    );
  }
}
