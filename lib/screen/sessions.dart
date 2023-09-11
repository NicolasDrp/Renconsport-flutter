import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Sessions extends StatefulWidget {
  const Sessions({super.key, required this.storage});

  final FlutterSecureStorage storage;

  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}