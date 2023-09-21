import 'package:renconsport_flutter/modal/sporttype.dart';
import 'package:renconsport_flutter/modal/user.dart';
import 'package:renconsport_flutter/services/user_service.dart';

class Session {
  final int id;
  final int duration;
  final DateTime dateTime;
  final String description;
  final String iriUser;
  final List<User> userList;
  final String iriSportType;

  Session({
    required this.id,
    required this.duration,
    required this.dateTime,
    required this.description,
    required this.iriUser,
    required this.userList,
    required this.iriSportType,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
        id: json['id'],
        duration: json['duration'],
        dateTime: DateTime.parse(json['datetime']),
        description: json['description'],
        iriUser: json['idUser'],
        userList:
            List<User>.from(json['userList'].map((x) => User.fromJson(x))),
        iriSportType: json['idSportType']);
  }
}
