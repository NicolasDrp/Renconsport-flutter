import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/widget/bottom_app_bar.dart';
import 'package:renconsport_flutter/widget/custom_app_bar.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class Parameters extends StatefulWidget {
  const Parameters({super.key, required this.storage});

  final FlutterSecureStorage storage;

  @override
  State<Parameters> createState() => _ParametersState();
}

class _ParametersState extends State<Parameters> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(tutorial: ""),
      bottomNavigationBar: BottomAppBarWidget(),
      body: Center(
        child: Column(
          children: [
            Text(
              'Parameterss',
              style: TextStyle(
                color: AdaptiveTheme.of(context).theme.primaryColor,
              ),
            ),
            Text(
              'Parameterss',
              style: TextStyle(
                color: AdaptiveTheme.of(context).theme.bottomNavigationBarTheme.selectedItemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
