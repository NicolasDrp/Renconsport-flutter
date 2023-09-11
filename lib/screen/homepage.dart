import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.storage});

  final FlutterSecureStorage storage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLogged = true;
  @override
  Widget build(BuildContext context) {
    checkLogged();
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/logo_appbar.png'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.error_outline,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.black,
              ))
        ],
      ),
      bottomNavigationBar: BottomAppBar(),
      body: Column(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          Text("homepage")
        ],
      ),
    );
  }

  void checkLogged() async {
    if (!await widget.storage.containsKey(key: "token")) {
      redirect();
    } else {
      print(await widget.storage.read(key: "token"));
    }
  }

  void redirect() {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
