import 'dart:convert';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:camera/camera.dart';
import 'package:fakevideocall/main.dart';
import 'package:fakevideocall/models/data_model.dart';
import 'package:fakevideocall/services/admob_ad_network.dart';
import 'package:fakevideocall/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Tools {
  static String link =
      "https://raw.githubusercontent.com/Amegodev/amegodev.github.io/master/api/fakecall/dump_data.json";
  static final assetsAudioPlayer = AssetsAudioPlayer();

  static late PackageInfo packageInfo;

  static initAppSettings() async {
    WidgetsFlutterBinding.ensureInitialized();

    AdmobHelper.init();

    myCameras = await availableCameras();

    packageInfo = await PackageInfo.fromPlatform();

    Tools.hideStatusBar();
  }

  static late DataModel allData;

  static Future getData() async {
    var res = await http
        .get(Uri.parse(link), headers: {"Accept": "application/json"});
    Tools.logger.i("Data:\n${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      Tools.logger.i(data);
      allData = DataModel.fromJson(data);
    } else {
      link =
          "https://raw.githubusercontent.com/Amegodev/amegodev.github.io/master/api/fakecall/dump_data.json";
      await getData();

      // throw Exception(res.statusCode);
    }

    return;
  }

  static Future getDumpData() async {
    String link =
        "https://raw.githubusercontent.com/Amegodev/amegodev.github.io/master/api/fakecall/dump_data.json";
    var res = await http
        .get(Uri.parse(link), headers: {"Accept": "application/json"});
    Tools.logger.i("Data:\n${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      Tools.logger.i(data);
      allData = DataModel.fromJson(data);
    } else {
      throw Exception(res.statusCode);
    }

    return;
  }

  static checkAppVersion(BuildContext context) async {
    if (Tools.allData != null) {
      String newVersion = Tools.allData.config.currentAppVersion;

      double currentVersion =
          double.parse(newVersion.trim().replaceAll(".", ""));
      double installedVersion =
          double.parse(Tools.packageInfo.version.trim().replaceAll(".", ""));

      Tools.logger
          .i('Current version: $currentVersion Installed: $installedVersion');

      if (installedVersion < currentVersion) {
        await showDialog(
          context: context,
          barrierDismissible: !Tools.allData.config.forceUpdate,
          builder: (context) => AlertDialog(
            title: Text(
              Tools.allData.config.title,
            ),
            content: WillPopScope(
              onWillPop: () => Future.value(!Tools.allData.config.forceUpdate),
              child: Text(
                "${Tools.allData.config.body.split("var").first} $newVersion ${Tools.allData.config.body.split("var").last}",
              ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: Tools.allData.config.forceUpdate
                        ? MButton(
                            text: 'exit',
                            bgColor: Colors.transparent,
                            onClicked: () {
                              SystemChannels.platform
                                  .invokeMethod('SystemNavigator.pop');
                              Navigator.pop(context);
                            },
                          )
                        : MButton(
                            text: 'later',
                            bgColor: Colors.transparent,
                            onClicked: () {
                              Navigator.pop(context);
                              return;
                            },
                          ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: MButton(
                      text: 'update',
                      onClicked: () async {
                        var url = Tools.allData.config.updateLink;

                        await Tools.launchURL(url);
                        if (!Tools.allData.config.forceUpdate) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    }
  }

  static height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static var logger = Logger(
    printer: PrettyPrinter(methodCount: 2, colors: true, printEmojis: true),
  );

  static launchURL(String myUrl) async {
    final Uri url = Uri.parse(myUrl);
    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } catch (e) {
      logger.wtf("error launch url Could not launch $url \n error $e");
    }
  }

  static waitingDialog(
      {required BuildContext context, required VoidCallback process}) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          process();

          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: WillPopScope(
              onWillPop: () => Future.value(false),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("loading"),
                  SizedBox(
                    height: 40.0,
                  ),
                  SizedBox(
                    height: 40.0,
                    width: 40.0,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  static play({String? assets}) {
    assetsAudioPlayer.open(
      Audio(assets ?? "assets/ringtone.mp3"),
      autoStart: true,
    );
  }

  static pause() {
    assetsAudioPlayer.pause();
  }

  static stop() {
    assetsAudioPlayer.stop();
  }

  static int getRandomInt({int maxNumber = 1}) {
    var rng = Random();
    return rng.nextInt(maxNumber);
  }
}
