import 'dart:ui';

import 'package:animated_button/animated_button.dart';
import 'package:fakevideocall/models/chat_model.dart';
import 'package:fakevideocall/screens/chat_page.dart';
import 'package:fakevideocall/screens/incoming_call_screen.dart';
import 'package:fakevideocall/screens/video_call_screen.dart';
import 'package:fakevideocall/screens/voice_call_screen.dart';
import 'package:fakevideocall/services/ads.dart';
import 'package:fakevideocall/services/app_open_ad_helper.dart';
import 'package:fakevideocall/utils/constansts.dart';
import 'package:fakevideocall/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AdsHelper ads = AdsHelper();

  @override
  void initState() {
    super.initState();


    Tools.hideStatusBar();
  }

  @override
  Widget build(BuildContext context) {
    AppOpenAdManager().showAdIfAvailable();
    const myTextStyle = TextStyle(
        fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.bold);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            child: Tools.allData!.backgroundImg!.isEmpty
                ? Image.asset(
                    "assets/bg.png",
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: Tools.allData!.backgroundImg!,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
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
                Text(
                  Tools.allData!.title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                  height: 150.0,
                  width: 150.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: CachedNetworkImage(
                      imageUrl: Tools.allData!.icon!,
                      placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedButton(
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: const Color(0XFF990063),
                      onPressed: () async {
                        await ads.loadAndShowInter(
                          context: context,
                          frequency: 3,
                          onFinished: () {
                            Tools.play();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => const IncomingCallScreen(
                                  nextScreen: VoiceCallScreen(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Icon(
                              Icons.phone_callback_sharp,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Call',
                            style: myTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    AnimatedButton(
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: const Color(0XFFad0071),
                      onPressed: () {
                        Tools.play(assets: "assets/video_ringtone.mp3");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => const IncomingCallScreen(
                              nextScreen: VideoCallScreen(),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Icon(
                              Icons.video_call,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Video Call',
                            style: myTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    AnimatedButton(
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: const Color(0XFFd6008b),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => ChatPage(user: currentUser),
                          ),
                        );
                      },
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Icon(
                              Icons.chat,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Chat',
                            style: myTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ads.getBannerAd(),
          )
        ],
      ),
    );
  }
}
