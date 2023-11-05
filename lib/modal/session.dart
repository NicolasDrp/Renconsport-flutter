import 'package:renconsport_flutter/modal/user.dart';

class Session {
  final int id;
  final int duration;
  final DateTime dateTime;
  final String description;
  final User? creator;
  final List<User> userList;
  final String iriSportType;

  Session({
    required this.id,
    required this.duration,
    required this.dateTime,
    required this.description,
    required this.creator,
    required this.userList,
    required this.iriSportType,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
        id: json['id'],
        duration: json['duration'],
        dateTime: DateTime.parse(json['datetime']),
        description: json['description'],
        creator:
            json.containsKey('creator') ? User.fromJson(json['creator']) : null,
        userList:
            List<User>.from(json['user_list'].map((x) => User.fromJson(x))),
        iriSportType: json['idSportType'] ?? 'Autre catégorie');
  }
}
