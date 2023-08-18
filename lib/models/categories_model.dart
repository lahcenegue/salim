class CategoriesModel {
  final String name;
  final String id;
  final String category;

  CategoriesModel({
    required this.name,
    required this.id,
    required this.category,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      name: json['catname'],
      id: json['catid'],
      category: json['cat'],
    );
  }
}
