import 'package:flutter/material.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key, required this.nav});

  final Function nav;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          nav(8);
        },
        child: Icon(Icons.person_add_alt_1));
  }
}
