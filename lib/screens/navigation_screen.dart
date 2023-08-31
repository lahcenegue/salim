import 'package:dinetemp/screens/main_screen.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'download_screen.dart';
import 'favorite_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedIndex = 0;
  List pages = const [
    MainScreen(),
    FavoriteScreen(),
    DownloadScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          selectedLabelStyle: TextStyle(
            color: kMainColor,
            fontWeight: FontWeight.bold,
            fontSize: widthScreen * 0.025,
          ),
          currentIndex: selectedIndex,
          onTap: (value) => setState(() => selectedIndex = value),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: kIconColor,
                size: widthScreen * 0.04,
              ),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: kIconColor,
                size: widthScreen * 0.04,
              ),
              label: 'المفضلة',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.download,
                color: kIconColor,
                size: widthScreen * 0.04,
              ),
              label: 'التحميلات',
            ),
          ],
        ),
      ),
    );
  }
}
