class RepComment {
  String commentId;
  String content;
  String repId;
  bool showReply;
  String userId;
  String created;
  RepComment({
    required this.commentId,
    required this.repId,
    required this.userId,
    required this.created,
    this.content = "",
    this.showReply = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'content': content,
      'repId': repId,
      'showReply': showReply,
      'userId': userId,
      'created': created,
    };
  }

  factory RepComment.fromJson(Map<String, dynamic> map) {
    return RepComment(
      commentId: map['commentId'],
      content: map['content'],
      repId: map['repId'],
      showReply: map['showReply'],
      userId: map['userId'],
      created: map['created'],
    );
  }

  @override
  bool operator ==(covariant RepComment other) => commentId == other.commentId;

  @override
  int get hashCode => commentId.hashCode;
}
