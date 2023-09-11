import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Parameters extends StatefulWidget {
  const Parameters({super.key, required this.storage});

  final FlutterSecureStorage storage;

  @override
  State<Parameters> createState() => _ParametersState();
}

class _ParametersState extends State<Parameters> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}