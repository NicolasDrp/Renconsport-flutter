import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings(
      {super.key, required this.storage, this.savedThemeMode});

  final FlutterSecureStorage storage;
  final AdaptiveThemeMode? savedThemeMode;

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("placeholder"));
  }
}
