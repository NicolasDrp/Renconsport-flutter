class User {
  final int id;
  final String username;
  final String email;
  final String bio;
  final dynamic avatarUrl;
  final String city;
  final int age;
  final List<dynamic> sportTypeList;

  User(
      {required this.id,
      required this.email,
      required this.bio,
      required this.username,
      required this.city,
      required this.age,
      required this.sportTypeList,
      required this.avatarUrl
      });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        bio: json['bio'],
        avatarUrl: json['avatar_url'],
        city: json['city'],
        age: json['age'],
        sportTypeList: json['sport_type_list']);
  }
}
