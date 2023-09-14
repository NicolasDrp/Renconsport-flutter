import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/widget/bottom_app_bar.dart';
import 'package:renconsport_flutter/widget/custom_app_bar.dart';

class Parameters extends StatefulWidget {
  const Parameters({super.key, required this.storage});

  final FlutterSecureStorage storage;

  @override
  State<Parameters> createState() => _ParametersState();
}

class _ParametersState extends State<Parameters> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // TODO: Rédiger le tutorial de la page parameters
      appBar: CustomAppbar(tutorial: ""),
      bottomNavigationBar: BottomAppBarWidget(),
      body: Center(
        child: Text('Parameters'),
      ),
    );
  }
}
