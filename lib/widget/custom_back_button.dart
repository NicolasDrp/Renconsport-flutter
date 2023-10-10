import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, required this.nav, required this.index});

  final Function nav;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              nav(index, null);
            },
          ),
        ));
  }
}
