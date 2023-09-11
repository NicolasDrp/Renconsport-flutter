import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLogged = true;
  @override
  Widget build(BuildContext context) {
    if (!isLogged) {
      Navigator.pushNamed(context, '/login');
    }
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
      ),bottomNavigationBar: BottomAppBar(),
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
}
