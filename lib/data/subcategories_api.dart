import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../constants/constants.dart';
import '../models/subcategories_model.dart';

class SubCategoriesApi {
  String catId;
  SubCategoriesApi({
    required this.catId,
  });

// SubCategories list
  Future<List<SubCategoriesModel>> loadSubCat() async {
    try {
      var url = Uri.parse('$kUrl/api/cat/$catId/');

      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var data = convert.jsonDecode(response.body);

        var listdata = data[0];

        ListSubCatModel listSubModel = ListSubCatModel.fromJson(listdata);

        List<SubCategoriesModel> listSubcat = listSubModel.listSubModel
            .map((e) => SubCategoriesModel.fromJson(e))
            .toList();

        return listSubcat;
      }
    } catch (e) {
      throw Exception(e);
    }
    return [];
  }

  // MatterList api

  Future<List<SubMatterModel>> loadSubMatter({required int page}) async {
    try {
      Uri url = Uri.parse('$kUrl/api/cat/$catId/$page');

      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var data = convert.jsonDecode(response.body);

        var listdata = data[0];

        ListSubMatter listSubMatterModel = ListSubMatter.fromJson(listdata);

        List<SubMatterModel> listMatter = listSubMatterModel.listMatter
            .map(
              (e) => SubMatterModel.fromJson(e),
            )
            .toList();

        return listMatter;
      }
    } catch (e) {
      throw Exception(e);
    }
    return [];
  }
}
