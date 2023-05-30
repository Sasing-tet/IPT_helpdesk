class Categories {
  String catId;
  String categoryName;
  bool isClicked;
  String userId;
  Categories({
    required this.catId,
    required this.categoryName,
    required this.userId,
    this.isClicked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'catId': catId,
      'categoryName': categoryName,
      'userId': userId,
    };
  }

  factory Categories.fromJson(Map<String, dynamic> map) {
    return Categories(
      catId: map['catId'],
      categoryName: map['categoryName'],
      userId: map['userId'],
    );
  }

  @override
  bool operator ==(covariant Categories other) => catId == other.catId;

  @override
  int get hashCode => catId.hashCode;
}
