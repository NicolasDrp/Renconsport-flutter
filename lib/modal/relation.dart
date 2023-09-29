class Relation {
  final int id;
  final String sender;
  final String target;

  Relation({
    required this.id,
    required this.sender,
    required this.target,
  });

  factory Relation.fromJson(Map<String, dynamic> json) {
    return Relation(
        id: json['id'], sender: json['sender'], target: json['target']);
  }
}
