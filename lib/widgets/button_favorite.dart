import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/constants.dart';
import '../data/sqldb.dart';

class ButtonFavorite extends StatefulWidget {
  final String id;
  final String title;
  const ButtonFavorite({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  State<ButtonFavorite> createState() => _ButtonFavoriteState();
}

class _ButtonFavoriteState extends State<ButtonFavorite> {
  bool isFavorite = false;

  @override
  void initState() {
    checkFavorite(id: widget.id).then((value) => setState(
          () {
            isFavorite = value;
          },
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(isFavorite
                    ? 'تم حذف المادة من المفضلة'
                    : 'تم إظافة المادة الى المفضلة')));
            if (isFavorite == false) {
              addFavorite(id: widget.id, title: widget.title).then((value) {
                setState(
                  () {
                    isFavorite = true;
                  },
                );
              });
            } else {
              deleteFavorite(id: widget.id).then(
                (value) => setState(
                  () {
                    isFavorite = false;
                  },
                ),
              );
            }
          },
          icon: Icon(
            Icons.favorite_rounded,
            color: isFavorite ? Colors.red : Colors.white,
            size: widthScreen * 0.04,
          ),
        ),
        IconButton(
          onPressed: () async {
            final box = context.findRenderObject() as RenderBox?;
            await Share.share(
                'اسم المحاضرة: ${widget.title} \n $kUrl/play/${widget.id}',
                sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                subject: 'Look what I made!');
          },
          icon: Icon(
            Icons.share_rounded,
            size: widthScreen * 0.04,
          ),
        ),
      ],
    );
  }
}

Future<bool> checkFavorite({required String id}) async {
  bool isFavorite = false;
  List<Map> response = await SqlDb()
      .readData("SELECT * FROM contentmodel WHERE id_content = $id");

  if (response.isEmpty) {
    isFavorite = false;
  } else {
    isFavorite = true;
  }
  return isFavorite;
}

Future<bool> addFavorite({required String id, title}) async {
  bool isFavorite = false;
  int response = await SqlDb().insertData('''
                                     INSERT INTO contentmodel ("id_content" , "name")
                                     VALUES ("$id", "$title")
                                      ''');

  if (response > 0) {
    isFavorite = true;
  }
  return isFavorite;
}

Future<bool> deleteFavorite({required String id}) async {
  bool isFavorite = false;
  int delete = await SqlDb()
      .deleteData("DELETE FROM contentmodel WHERE id_content= $id");
  if (delete.isFinite) {
    isFavorite = false;
  }

  return isFavorite;
}
