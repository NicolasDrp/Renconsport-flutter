class Like {
  final int id;
  final bool isLike;
  final String sender;
  final String target;

  Like(
      {required this.id,
      required this.isLike,
      required this.sender,
      required this.target});

  factory Like.fromJson(Map<String, dynamic> json) {
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
    return Like(
        id: json['id'],
        isLike: json['is_like'],
        sender: idSender,
        target: idTarget);
  }
}
