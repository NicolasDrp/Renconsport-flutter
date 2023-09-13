import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/screen/contacts.dart';
import 'package:renconsport_flutter/screen/homepage.dart';
import 'package:renconsport_flutter/screen/login.dart';
import 'package:renconsport_flutter/screen/parameters.dart';
import 'package:renconsport_flutter/screen/profile.dart';
import 'package:renconsport_flutter/screen/sessions.dart';

const String urlApi = "https://renconsport-api.osc-fr1.scalingo.io/api";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  runApp(MainApp(storage: storage));
}

class MainApp extends StatelessWidget {
  final FlutterSecureStorage storage;

  const MainApp({required this.storage, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
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
