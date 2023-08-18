import 'package:flutter/material.dart';

//name
String kAppName = 'الدكتور سالم العجمي';

//notification
String kNotificationId = '8dc9f6aa-c551-4c73-884e-bc6c8d1403a7';

//Links
String kUrl = 'https://www.salemalajmi.com/main';

//Colors
Color mainColor = const Color(0xff014249);
MaterialColor kMainColor = MaterialColorGenerator.from(mainColor);

Color kIconColor = Colors.grey;

//images

String kHeader = 'assets/images/header.png';
String kIcon = 'assets/images/icon.png';
String kSoundImage =
    'https://as1.ftcdn.net/v2/jpg/00/85/61/98/1000_F_85619893_qcV9Vr8GQGGToKKozmKZlon9M1rNwWNd.jpg';

//
class MaterialColorGenerator {
  static MaterialColor from(Color color) {
    return MaterialColor(color.value, <int, Color>{
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    });
  }
}
