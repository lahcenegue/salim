import 'package:dinetemp/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import '../view_model/home_view_model.dart';
import 'categorie_detail.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  HomeViewModel hvm = HomeViewModel();

  @override
  void initState() {
    super.initState();
    hvm.fetchCategoriesList();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    hvm.fetchCategoriesList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    hvm.addListener(() {
      setState(() {});
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: hvm.listCateg == null || hvm.listCateg!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: refreshData,
              child: ListView.builder(
                physics: const ScrollPhysics(),
                itemCount: hvm.listCateg!.length,
                itemBuilder: (buildContext, index) {
                  return customCard(
                      name: hvm.listCateg![index].name,
                      width: widthScreen,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategorieDetail(
                              catId: hvm.listCateg![index].id,
                              name: hvm.listCateg![index].name,
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
    );
  }
}
