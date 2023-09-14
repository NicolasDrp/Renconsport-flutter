import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
      required this.hasIcon,
      required this.icon,
      required this.text,
      required this.callback});

  final bool hasIcon;
  final Icon icon;
  final String text;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    ElevatedButton button;
    if (hasIcon == false) {
      button = ElevatedButton(
          onPressed: () {
            callback();
          },
          child: Text(text));
    } else {
      button = ElevatedButton(
          onPressed: () {
            callback();
          },
          child: Row(children: [
            icon,
            Text(text),
          ]));
    }
    return button;
  }
}
