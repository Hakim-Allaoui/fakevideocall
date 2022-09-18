import 'dart:ui';

import 'package:fakevideocall/screens/home_page.dart';
import 'package:fakevideocall/screens/test_page.dart';
import 'package:fakevideocall/services/ads.dart';
import 'package:fakevideocall/utils/constansts.dart';
import 'package:fakevideocall/utils/tools.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    try {
      await Tools.getData();

      if (mounted) await Tools.checkAppVersion(context);

      AdsHelper.init();

      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (builder) {
          return const HomePage();
        }));
      }
    } catch (e) {
      Tools.logger.e(e);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) {
        return const TestPage();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            child: Image.asset(
              "assets/bg.png",
              fit: BoxFit.cover,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
            child: Container(color: Colors.black12),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                Image.asset(
                  "assets/icon.png",
                  height: 200.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text("Loading...")],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
