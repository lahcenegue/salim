import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/categories_model.dart';

class CategoriesApi {
  Future<List<CategoriesModel>> loadData() async {
    try {
      var url = Uri.parse('$kUrl/api/');
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var data = convert.jsonDecode(response.body);

        Iterable list = data;

        List<CategoriesModel> categoriesList =
            list.map((e) => CategoriesModel.fromJson(e)).toList();

        return categoriesList;
      }
    } catch (e) {
      throw Exception(e);
    }
    return [];
  }
}
