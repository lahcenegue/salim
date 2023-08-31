import 'package:dinetemp/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import '../view_model/subcategories_view_model.dart';
import 'categorie_detail.dart';

class SubCategoriesList extends StatelessWidget {
  final List<SubCategoriesViewModel> listSubCateg;

  const SubCategoriesList({
    super.key,
    required this.listSubCateg,
  });

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: listSubCateg.length,
      itemBuilder: (buildContext, index) {
        return customCard(
            name: listSubCateg[index].name,
            width: widthScreen,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategorieDetail(
                    catId: listSubCateg[index].id,
                    name: listSubCateg[index].name,
                  ),
                ),
              );
            });
      },
    );
  }
}
