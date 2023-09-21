class SportType {
  final int id;
  final String name;
  final List<dynamic> userList;

  SportType({
    required this.id,
    required this.name,
    required this.userList,
  });

  factory SportType.fromJson(Map<String, dynamic> json) {
    return SportType(
        id: json['id'], name: json['name'], userList: json['userList']);
  }
}
