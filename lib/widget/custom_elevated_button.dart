import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

///
/// [icon] The Icon to show, use Icon(null) for iconless button
class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.callback});

  // final bool hasIcon;
  final Icon icon;
  final String text;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    ElevatedButton button;
    button = ElevatedButton.icon(
      onPressed: () {
        callback();
      },
      icon: (icon.icon == null)
          ? const Icon(
              null,
              size: 0,
              color: Colors.white,
            )
          : icon,
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ButtonStyle(
          elevation: MaterialStateProperty.all<double?>(5),
          backgroundColor: MaterialStatePropertyAll<Color>(
              AdaptiveTheme.of(context).theme.hintColor),
          // padding:
          //     MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
          fixedSize: MaterialStatePropertyAll<Size>(Size(
              MediaQuery.of(context).size.width * 0.6,
              MediaQuery.of(context).size.width * 0.14))),
    );
    return button;
  }
}
