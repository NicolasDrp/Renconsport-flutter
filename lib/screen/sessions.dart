import 'package:flutter/material.dart';

class Sessions extends StatefulWidget {
  const Sessions({super.key});
  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    ));
  }
}
