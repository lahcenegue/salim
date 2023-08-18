import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../constants/constants.dart';
import '../models/content_model.dart';

class ContentApi {
  String catId;
  ContentApi({
    required this.catId,
  });

  Future<ContentModel> loadContentData() async {
    try {
      var url = Uri.parse('$kUrl/api/play/$catId/');

      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var data = convert.jsonDecode(response.body);
        ContentModel content = ContentModel.fromJson(data);
        return content;
      }
    } catch (e) {
      throw Exception(e);
    }
    return ContentModel();
  }
}
