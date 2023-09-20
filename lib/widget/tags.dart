import 'package:flutter/material.dart';

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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
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
