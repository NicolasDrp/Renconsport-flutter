import 'package:renconsport_flutter/modal/like.dart';
import 'package:renconsport_flutter/modal/relation.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final String bio;
  final dynamic avatar;
  final String city;
  final int age;
  final List<dynamic> sportTypeList;
  final String gender;
  final List<Like> likeList;
  final List<dynamic> receivedLikeList;
  final List<Relation> relationList;
  final List<Relation> targetRelationList;

  User(
      {required this.id,
      required this.email,
      required this.password,
      required this.bio,
      required this.username,
      required this.city,
      required this.age,
      required this.sportTypeList,
      required this.avatar,
      required this.gender,
      required this.likeList,
      required this.receivedLikeList,
      required this.relationList,
      required this.targetRelationList});

  factory User.fromJson(Map<String, dynamic> json) {
    List<Relation> relationList;
    if (json.containsKey('relationList')) {
      if (json['relationList'].length > 0) {
        relationList = List.generate(json['relationList'].length, (index) {
          return Relation.fromJson(json['relationList'][index]);
        });
      } else {
        relationList = [];
      }
    } else {
      relationList = [];
    }

    List<Relation> targetRelationList;
    if (json.containsKey('targetRelationList')) {
      if (json['targetRelationList'].length > 0) {
        targetRelationList =
            List.generate(json['targetRelationList'].length, (index) {
          return Relation.fromJson(json['targetRelationList'][index]);
        });
      } else {
        targetRelationList = [];
      }
    } else {
      targetRelationList = [];
    }

    List<Like> likeList;
    if (json.containsKey('likeList')) {
      if (json['likeList'].length > 0) {
        likeList = List.generate(json['likeList'].length, (index) {
          return Like.fromJson(json['likeList'][index]);
        });
      } else {
        likeList = [];
      }
    } else {
      likeList = [];
    }

    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        password: json['password'],
        bio: json['bio'],
        avatar: json['avatar'],
        city: json['city'],
        age: json['age'],
        sportTypeList:
            json.containsKey('sportTypeList') ? json['sportTypeList'] : [],
        gender: json['gender'],
        likeList: likeList,
        receivedLikeList: json.containsKey('receivedLikeList')
            ? json['receivedLikeList']
            : [],
        relationList: relationList,
        targetRelationList: targetRelationList);
  }
}
