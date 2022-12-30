import 'package:camera/camera.dart';
import 'package:fakevideocall/screens/splash_page.dart';
import 'package:fakevideocall/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:personal_package/screens/entry_point_page.dart';

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
      title: "NewYear Gift Prank Call", //TODO: AppName
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EntryPointPage(
        dataUrl: "https://raw.githubusercontent.com/Amegodev/amegodev.github.io/master/api/NY%20Gift/data.json",
        child: SplashPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
