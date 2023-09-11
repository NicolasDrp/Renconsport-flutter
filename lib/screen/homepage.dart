import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLogged = false;
  @override
  Widget build(BuildContext context) {
    if (!isLogged) {
      Navigator.pushNamed(context, '/login');
    }
    return Scaffold(
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
