import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/widget/bottom_app_bar.dart';
import 'package:renconsport_flutter/widget/custom_app_bar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.storage});

  final FlutterSecureStorage storage;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // TODO: Rédiger le tutorial de la page profile
      appBar: CustomAppbar(tutorial: ""),
      bottomNavigationBar: BottomAppBarWidget(),
      body: Center(
        child: Text('Profile'),
      ),
    );
  }
}
