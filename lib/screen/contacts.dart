import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key, required this.nav});

  final Function nav;

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
