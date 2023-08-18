import '../constants/constants.dart';
import '../models/content_model.dart';

class ContentViewModel {
  final ContentModel _contentModel;

  ContentViewModel({required ContentModel contentModel})
      : _contentModel = contentModel;

  String get id {
    return _contentModel.id!;
  }

  String get catId {
    return _contentModel.catid!;
  }

  String get name {
    return _contentModel.name!;
  }

  String get image {
    return _contentModel.image!;
  }

  String get comment {
    return _contentModel.comment!;
  }

  String get byadd {
    return _contentModel.byadd!;
  }

  List<String>? get listLinks {
    List<String> links = [];
    if (_contentModel.likaty!.isNotEmpty) {
      for (int i = 0; i < _contentModel.likaty!.length; i++) {
        if (_contentModel.likaty![i].link!.contains('http')) {
          links.add(_contentModel.likaty![i].link!);
        } else {
          links.add('$kUrl/${_contentModel.likaty![i].link!}');
        }
      }
    }
    return links;
  }
}
