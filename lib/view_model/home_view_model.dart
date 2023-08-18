import 'package:flutter/material.dart';
import '../data/categories_api.dart';
import '../data/content_api.dart';
import '../data/subcategories_api.dart';
import '../models/categories_model.dart';
import '../view_model/categories_view_model.dart';
import '../view_model/subcategories_view_model.dart';
import '../models/content_model.dart';
import '../view_model/content_view_model.dart';

class HomeViewModel extends ChangeNotifier {
  List<CategoriesViewModel>? listCateg;
  List<SubCategoriesViewModel>? listSubCateg;
  List<SubMatterViewModel>? listSubMatter;
  ContentViewModel? contentData;

//Categories list
  Future<void> fetchCategoriesList() async {
    List<CategoriesModel> jsonMapCat = await CategoriesApi().loadData();

    jsonMapCat.removeWhere((element) => element.category == 'page');

    listCateg =
        jsonMapCat.map((e) => CategoriesViewModel(categories: e)).toList();
    notifyListeners();
  }

  //SubCategories List
  Future<void> fetchSubCategoriesList(String catid) async {
    List jsonMap = await SubCategoriesApi(catId: catid).loadSubCat();

    listSubCateg =
        jsonMap.map((e) => SubCategoriesViewModel(subcategories: e)).toList();

    notifyListeners();
  }

  // Matter List
  Future<void> fetchSubMatterList(
      {required String catid, required int page}) async {
    List jsonMatter =
        await SubCategoriesApi(catId: catid).loadSubMatter(page: page);
    listSubMatter =
        jsonMatter.map((e) => SubMatterViewModel(matterModel: e)).toList();

    notifyListeners();
  }

  // Contents Data
  Future<void> fetchContentData(String catid) async {
    ContentModel jsonContent = await ContentApi(catId: catid).loadContentData();
    contentData = ContentViewModel(contentModel: jsonContent);

    notifyListeners();
  }
}
