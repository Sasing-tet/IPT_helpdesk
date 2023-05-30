class Report {
  String repId;
  String title;
  String description;
  String catId;
  String userId;
  String created;
  Report({
    required this.repId,
    required this.title,
    required this.description,
    required this.catId,
    required this.userId,
    required this.created,
  });

  Map<String, dynamic> toJson() => {
        'repId': repId,
        'title': title,
        'description': description,
        'catId': catId,
        'userId': userId,
        'created': created
      };

  factory Report.fromJson(Map<String, dynamic> map) {
    return Report(
      repId: map['repId'],
      title: map['title'],
      description: map['description'],
      catId: map['catId'],
      userId: map['userId'],
      created: map['created'],
    );
  }

  @override
  bool operator ==(covariant Report other) => repId == other.repId;

  @override
  int get hashCode => repId.hashCode;
}
