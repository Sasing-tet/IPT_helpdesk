class CommentReply {
  String replyId;
  String replyContent;
  String commentId;
  String userId;
  String created;
  CommentReply({
    required this.commentId,
    required this.replyId,
    required this.userId,
    required this.created,
    this.replyContent = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'replyId': replyId,
      'replyContent': replyContent,
      'commentId': commentId,
      'userId': userId,
      'created': created,
    };
  }

  factory CommentReply.fromJson(Map<String, dynamic> map) {
    return CommentReply(
      replyId: map['replyId'],
      replyContent: map['replyContent'],
      commentId: map['commentId'],
      userId: map['userId'],
      created: map['created'],
    );
  }

  @override
  bool operator ==(covariant CommentReply other) => replyId == other.replyId;

  @override
  int get hashCode => replyId.hashCode;
}
