import '../models/subcategories_model.dart';

class SubCategoriesViewModel {
  final SubCategoriesModel _subcategories;

  SubCategoriesViewModel({required SubCategoriesModel subcategories})
      : _subcategories = subcategories;

  String get name {
    return _subcategories.name;
  }

  String get id {
    return _subcategories.id;
  }
}

// المواد view Model

class SubMatterViewModel {
  final SubMatterModel _matterModel;

  SubMatterViewModel({required SubMatterModel matterModel})
      : _matterModel = matterModel;

  String get name {
    return _matterModel.name;
  }

  String get id {
    return _matterModel.id;
  }

  String get image {
    return _matterModel.image;
  }

  String get comm {
    return _matterModel.comm;
  }
}
