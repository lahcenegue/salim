import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'categories_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            kAppName,
            style: TextStyle(fontSize: widthScreen * 0.03),
          ),
        ),
        body: Column(
          children: [
            Image.asset(
              kHeader,
              height: widthScreen * 0.5,
              width: widthScreen,
              fit: BoxFit.cover,
            ),
            SizedBox(height: widthScreen * 0.02),
            const Expanded(
              child: CategoriesList(),
            ),
          ],
        ),
      ),
    );
  }
}
