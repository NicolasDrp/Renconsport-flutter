class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final String bio;
  final dynamic avatarUrl;
  final String city;
  final int age;
  final List<dynamic> sportTypeList;
  final String gender;
  final List<dynamic> likeList;
  final List<dynamic> receivedLikeList;

  User(
      {required this.id,
      required this.email,
      required this.password,
      required this.bio,
      required this.username,
      required this.city,
      required this.age,
      required this.sportTypeList,
      required this.avatarUrl,
      required this.gender,
      required this.likeList,
      required this.receivedLikeList});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        password: json['password'],
        bio: json['bio'],
        avatarUrl: json['avatar_url'],
        city: json['city'],
        age: json['age'],
        sportTypeList: json['sport_type_list'],
        gender: json['gender'],
        likeList: json['like_list'],
        receivedLikeList: json['received_like_list']);
  }
}
