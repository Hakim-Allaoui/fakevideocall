import 'package:camera/camera.dart';
import 'package:fakevideocall/screens/splash_page.dart';
import 'package:fakevideocall/utils/tools.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> myCameras;

void main() async {
  Tools.initAppSettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fake Video Call", //TODO: AppName
    theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
