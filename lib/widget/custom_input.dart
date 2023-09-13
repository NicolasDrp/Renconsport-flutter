import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({super.key, required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: getStyle(),
          focusedBorder: getStyle(),
          labelText: label,
        ),
      ),
    );
  }

  getStyle() {
    return const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange));
  }
}
