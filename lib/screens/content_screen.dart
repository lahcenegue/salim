import 'package:flutter/material.dart';
import '../view_model/home_view_model.dart';
import '../widgets/screen_picker.dart';

class ContentScreen extends StatefulWidget {
  final String id;
  const ContentScreen({
    super.key,
    required this.id,
  });

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  HomeViewModel hvm = HomeViewModel();
  @override
  void initState() {
    super.initState();
    hvm.fetchContentData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    hvm.addListener(() {
      setState(() {});
    });

    if (hvm.contentData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: screenPiker(hvm.contentData!),
      );
    }
  }
}
