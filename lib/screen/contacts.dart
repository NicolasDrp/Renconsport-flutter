import 'package:flutter/material.dart';
import 'package:renconsport_flutter/services/user_service.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key, required this.nav});

  final Function nav;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          String idUser = await UserService.getCurrentUserId();
          nav(8, idUser);
        },
        child: Icon(Icons.person_add_alt_1));
  }
}
