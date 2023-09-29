import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/services/user_service.dart';

class BottomAppBarWidget extends StatefulWidget {
  const BottomAppBarWidget(
      {super.key, required this.callback, required this.currentPage});

  final Function callback;
  final int currentPage;

  @override
  State<BottomAppBarWidget> createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    // String currentId = "";
    bool isActive;
    int page = widget.currentPage;
    if (widget.currentPage > 3) {
      page = 0;
      isActive = false;
    } else {
      isActive = true;
    }

    return BottomNavigationBar(
      currentIndex: page,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 34,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AdaptiveTheme.of(context).theme.hintColor,
      selectedItemColor: isActive
          ? AdaptiveTheme.of(context)
              .theme
              .bottomNavigationBarTheme
              .selectedItemColor
          : AdaptiveTheme.of(context)
              .theme
              .bottomNavigationBarTheme
              .unselectedItemColor,
      unselectedItemColor: AdaptiveTheme.of(context)
          .theme
          .bottomNavigationBarTheme
          .unselectedItemColor,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      onTap: (value) async {
        String currentId = await UserService.getCurrentUserId();
        Map<String, dynamic> payload = {};
        if (value == 2) {
          payload = {
            'id': currentId,
          };
        }
        print("payload: $payload");
        widget.callback(value, (value == 2) ? payload : null);
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
