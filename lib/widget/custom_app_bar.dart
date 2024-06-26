import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar(
      {super.key, required this.tutorial, required this.nav});

  final String tutorial;
  final Function nav;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AdaptiveTheme.of(context).theme.hintColor,
      leading: Image.asset('assets/logo_appbar.png'),
      actions: [
        IconButton(
            onPressed: () {
              //TODO: afficher les informations sur la page en cours
            },
            icon: const Icon(
              Icons.error_outline,
              color: Colors.black,
            )),
        IconButton(
            onPressed: () {
              nav(4, null);
            },
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.black,
            ))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
