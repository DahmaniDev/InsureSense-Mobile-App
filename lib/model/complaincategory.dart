class ComplainCategory {
  final int? categoryID;
  final String? description;

  const ComplainCategory({this.categoryID, this.description});

  factory ComplainCategory.fromJson(Map<String, dynamic> json) {
    return ComplainCategory(
      categoryID: json['ID'] as int,
      description: json['Description'],
    );
  }
}
