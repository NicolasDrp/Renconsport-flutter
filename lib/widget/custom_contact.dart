import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class CustomContact extends StatelessWidget {
  const CustomContact({super.key, required this.name, required this.isNew});

  final String name;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://googleflutter.com/sample_image.jpg'),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            Text(
              name,
              style: isNew
                  ? TextStyle(
                      color: isNew ? Colors.white : const Color(0xFF000000),
                      fontSize: 20)
                  : AdaptiveTheme.of(context).theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      tileColor: isNew
          ? const Color(0xFF004989)
          : AdaptiveTheme.of(context).theme.canvasColor,
    );
  }
}
