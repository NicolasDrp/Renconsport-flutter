import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class ModalConfirmation extends StatelessWidget {
  final Function onConfirm;
  final String message;

  const ModalConfirmation(
      {super.key, required this.onConfirm, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(message)),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              child: Text('Annuler',
                  style: AdaptiveTheme.of(context).theme.textTheme.bodyMedium),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AdaptiveTheme.of(context).theme.primaryColor),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(16))),
              child: Text('Déconnexion',
                  style: AdaptiveTheme.of(context).theme.textTheme.bodyMedium),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        )
      ],
    );
  }
}
