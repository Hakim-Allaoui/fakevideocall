import 'dart:ui';

import 'package:fakevideocall/screens/home_page.dart';
import 'package:fakevideocall/screens/test_page.dart';
import 'package:fakevideocall/services/ads.dart';
import 'package:fakevideocall/services/app_open_ad_helper.dart';
import 'package:fakevideocall/utils/constansts.dart';
import 'package:fakevideocall/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
      Tools.packageInfo = await PackageInfo.fromPlatform();

      await Tools.getData();

      AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
      WidgetsBinding.instance
          .addObserver(AppLifecycleReactor(appOpenAdManager: appOpenAdManager));

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
              "assets/bg.jpg",
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
              children: const [
                Text(
                  "Initializing resources...",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
