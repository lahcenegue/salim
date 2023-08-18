import 'package:dinetemp/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import '../view_model/home_view_model.dart';
import '../view_model/subcategories_view_model.dart';
import 'content_screen.dart';

class SubMattersList extends StatefulWidget {
  final String catId;
  final String catName;
  final List<SubMatterViewModel> subMatters;
  const SubMattersList({
    super.key,
    required this.catId,
    required this.catName,
    required this.subMatters,
  });

  @override
  State<SubMattersList> createState() => _SubMattersListState();
}

class _SubMattersListState extends State<SubMattersList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  HomeViewModel hvm = HomeViewModel();

  final controller = ScrollController();
  bool isLoadingMore = false;
  int page = 1;

  List<SubMatterViewModel> matters = [];

  @override
  void initState() {
    controller.addListener(_scrollListener);
    matters = widget.subMatters;

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    hvm.addListener(() {
      setState(() {});
    });

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: refreshData,
      child: ListView.builder(
        controller: controller,
        itemCount: isLoadingMore ? matters.length + 1 : matters.length,
        itemBuilder: (buildContext, index) {
          if (index < matters.length) {
            return customCard(
              name: matters[index].name,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContentScreen(
                      id: matters[index].id,
                    ),
                  ),
                );
              },
            );
          } else {
            return const Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    hvm.fetchSubMatterList(
      catid: widget.catId,
      page: 1,
    );
    setState(() {
      matters = hvm.listSubMatter!;
    });
  }

  Future<void> _scrollListener() async {
    if (isLoadingMore) return;
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      await Future.delayed(const Duration(seconds: 2)).whenComplete(() async {
        setState(() {
          page = page + 1;
        });

        await hvm
            .fetchSubMatterList(
          catid: widget.catId,
          page: page,
        )
            .whenComplete(() {
          setState(
            () {
              matters = matters + hvm.listSubMatter!;

              isLoadingMore = false;
            },
          );
        });
      });
    }
  }
}
