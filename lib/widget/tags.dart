import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class Tags extends StatelessWidget {
  final List<String> sports;

  const Tags({
    Key? key,
    required this.sports,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      child: Wrap(
        spacing: 8.0, // gap between adjacent chips
        children: sports
            .map((sportName) => Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 1,
                        color: Color.fromARGB(255, 121, 121, 121)),
                  ],
                  color: AdaptiveTheme.of(context).theme.canvasColor,
                  border: Border.all(
                    color: AdaptiveTheme.of(context).theme.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                    child: Text(
                      sportName,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ))))
            .toList(),
      ),
    );
  }
}
