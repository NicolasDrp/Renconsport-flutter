import 'package:flutter/material.dart';

class BottomAppBarWidget extends StatelessWidget {
  const BottomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 34,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blue,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      onTap: (value) {
        switch (value) {
          case 0:
            Navigator.pushNamed(context, "/");
            break;
          case 1:
            Navigator.pushNamed(context, "/sessions");
            break;
          case 2:
            Navigator.pushNamed(context, "/contacts");
            break;
          case 3:
            Navigator.pushNamed(context, "/profile");
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          label: "Page d'accueil",
          icon: Icon(Icons.switch_account_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Sessions',
          icon: Icon(Icons.calendar_month_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Messages',
          icon: Icon(Icons.message_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.account_circle_outlined),
        )
      ],
    );
  }
}