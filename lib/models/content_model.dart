//Content Model
class ContentModel {
  String? id;
  String? catid;
  String? name;
  String? image;
  String? comment;
  String? byadd;
  List<Likaty>? likaty;

  ContentModel({
    this.id,
    this.catid,
    this.name,
    this.image,
    this.comment,
    this.byadd,
    this.likaty,
  });

  ContentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catid = json['catid'];
    name = json['name'];
    image = json['image'];
    comment = json['comment'];
    byadd = json['byadd'];
    if (json['likaty'] != null) {
      likaty = <Likaty>[];
      json['likaty'].forEach((v) {
        likaty!.add(Likaty.fromJson(v));
      });
    }
  }
}

class Likaty {
  String? link;

  Likaty({
    this.link,
  });

  Likaty.fromJson(Map<String, dynamic> json) {
    link = json['link'];
  }
}
