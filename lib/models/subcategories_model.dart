// List SubCategories
class ListSubCatModel {
  final List<dynamic> listSubModel;

  ListSubCatModel({
    required this.listSubModel,
  });

  factory ListSubCatModel.fromJson(Map<String, dynamic> json) {
    return ListSubCatModel(
      listSubModel: json['cat'],
    );
  }
}

// List SubMatters
class ListSubMatter {
  final List<dynamic> listMatter;

  ListSubMatter({
    required this.listMatter,
  });

  factory ListSubMatter.fromJson(Map<String, dynamic> json) {
    return ListSubMatter(
      listMatter: json['play'],
    );
  }
}

// الاقسام model
class SubCategoriesModel {
  final String name;
  final String id;

  SubCategoriesModel({
    required this.name,
    required this.id,
  });

  factory SubCategoriesModel.fromJson(Map<String, dynamic> json) {
    return SubCategoriesModel(
      name: json['catname'],
      id: json['catid'],
    );
  }
}

// المواد Model
class SubMatterModel {
  final String id;
  final String name;
  final String comm;
  final String image;
  SubMatterModel({
    required this.id,
    required this.name,
    required this.comm,
    required this.image,
  });
  factory SubMatterModel.fromJson(Map<String, dynamic> json) {
    return SubMatterModel(
      id: json['id'].toString(),
      name: json['name'].toString(),
      comm: json['comm'].toString(),
      image: json['image'].toString(),
    );
  }
}
