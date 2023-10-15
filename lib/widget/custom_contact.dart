import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:renconsport_flutter/modal/user.dart';

class CustomContact extends StatelessWidget {
  const CustomContact(
      {super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 15),
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://googleflutter.com/sample_image.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Text(
                  user.username,
                  style: AdaptiveTheme.of(context).theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ));
  }
}
