import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key, required this.storage});

  final FlutterSecureStorage storage;

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
