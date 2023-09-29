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
    String idSender;
    String idTarget;
    if (json['sender'] is String) {
      idSender = json['sender'].split("/").last;
    } else {
      idSender = json['sender']['id'].toString();
    }

    if (json['target'] is String) {
      idTarget = json['target'].split("/").last;
    } else {
      idTarget = json['target']['id'].toString();
    }

    return Relation(id: json['id'], sender: idSender, target: idTarget);
  }
}
