import '../constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'screens/navigation_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

bool isPermission = false;

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(kNotificationId);

  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    debugPrint(
        "====================================Accepted permission: $accepted");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: kMainColor,
      ),
      home: const NavigationScreen(),
    );
  }
}
