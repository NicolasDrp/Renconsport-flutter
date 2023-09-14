import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:renconsport_flutter/widget/bottom_app_bar.dart';
import 'package:renconsport_flutter/widget/custom_app_bar.dart';

class Sessions extends StatefulWidget {
  const Sessions({super.key, required this.storage});

  final FlutterSecureStorage storage;

  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppbar(tutorial: ""),
        bottomNavigationBar: const BottomAppBarWidget(),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "Prochaine Sessions",
                    style: TextStyle(fontSize: 26),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
