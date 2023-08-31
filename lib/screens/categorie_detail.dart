import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../view_model/home_view_model.dart';
import 'subcategorie_list.dart';
import 'submatters_list.dart';

class CategorieDetail extends StatefulWidget {
  final String catId;
  final String name;

  const CategorieDetail({
    Key? key,
    required this.name,
    required this.catId,
  }) : super(key: key);

  @override
  State<CategorieDetail> createState() => _CategorieDetailState();
}

class _CategorieDetailState extends State<CategorieDetail> {
  HomeViewModel hvm = HomeViewModel();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  int page = 1;
  @override
  void initState() {
    super.initState();
    hvm.fetchSubCategoriesList(widget.catId);
    hvm.fetchSubMatterList(
      catid: widget.catId,
      page: page,
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    hvm.addListener(() {
      setState(() {});
    });

    if (hvm.listSubCateg == null || hvm.listSubMatter == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          length:
              hvm.listSubCateg!.isEmpty || hvm.listSubMatter!.isEmpty ? 1 : 2,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              shadowColor: Colors.white,
              title: Text(
                widget.name,
                style: TextStyle(fontSize: widthScreen * 0.03),
              ),
              bottom: PreferredSize(
                preferredSize: Size(widthScreen, widthScreen * 0.12),
                child: Container(
                  color: const Color(0xFFfafafa),
                  height: widthScreen * 0.1,
                  padding: EdgeInsets.symmetric(
                    horizontal: widthScreen * 0.05,
                    vertical: widthScreen * 0.01,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        widthScreen * 0.05,
                      ),
                      color: Colors.grey[200],
                    ),
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      labelStyle: TextStyle(
                        fontSize: widthScreen * 0.03,
                      ),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          widthScreen * 0.05,
                        ),
                        color: kMainColor,
                      ),
                      tabs: hvm.listSubCateg!.isEmpty
                          ? [
                              const Tab(
                                text: 'المواد',
                              )
                            ]
                          : hvm.listSubMatter!.isEmpty
                              ? [
                                  const Tab(text: 'الأقسام'),
                                ]
                              : [
                                  const Tab(text: 'الأقسام'),
                                  const Tab(text: 'المواد'),
                                ],
                    ),
                  ),
                ),
              ),
            ),
            body: hvm.listSubCateg!.isEmpty
                ? TabBarView(
                    children: [
                      // المواد
                      SubMattersList(
                        catName: widget.name,
                        catId: widget.catId,
                        subMatters: hvm.listSubMatter!,
                      ),
                    ],
                  )
                : hvm.listSubMatter!.isEmpty
                    ? TabBarView(
                        children: [
                          //الاقسام
                          RefreshIndicator(
                            key: _refreshIndicatorKey,
                            onRefresh: refreshData,
                            child: SubCategoriesList(
                              listSubCateg: hvm.listSubCateg!,
                            ),
                          ),
                        ],
                      )
                    : TabBarView(
                        children: [
                          //الاقسام
                          RefreshIndicator(
                            key: _refreshIndicatorKey,
                            onRefresh: refreshData,
                            child: SubCategoriesList(
                              listSubCateg: hvm.listSubCateg!,
                            ),
                          ),

                          // المواد
                          SubMattersList(
                            catId: widget.catId,
                            catName: widget.name,
                            subMatters: hvm.listSubMatter!,
                          ),
                        ],
                      ),
          ),
        ),
      );
    }
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    hvm.fetchSubCategoriesList(widget.catId);
    setState(() {});
  }
}
