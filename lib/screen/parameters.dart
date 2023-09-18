import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class Parameters extends StatefulWidget {
  const Parameters({super.key});

  @override
  State<Parameters> createState() => _ParametersState();
}

class _ParametersState extends State<Parameters> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Parameters',
            style: TextStyle(
              color: AdaptiveTheme.of(context).theme.primaryColor,
            ),
          ),
          Text(
            'Parameters',
            style: TextStyle(
              color: AdaptiveTheme.of(context)
                  .theme
                  .bottomNavigationBarTheme
                  .selectedItemColor,
            ),
          ),
        ],
      ),
    );
  }
}
