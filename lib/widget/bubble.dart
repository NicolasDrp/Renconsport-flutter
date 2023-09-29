import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  const Bubble({
    Key? key,
    required this.message,
    required this.isReceived,
    required this.time,
  }) : super(key: key);

  final String message;
  final bool isReceived;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment:
            isReceived ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!isReceived)
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  time,
                  style: TextStyle(
                    color: Color(0xFF807979),
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          Flexible(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: isReceived ? Color(0xFFFB7819) : Color(0xFF004989),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(12.0),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (isReceived)
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  time,
                  style: TextStyle(
                    color: Color(0xFF807979),
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
