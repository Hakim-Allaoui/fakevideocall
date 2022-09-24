import 'dart:ui';

import 'package:animated_button/animated_button.dart';
import 'package:fakevideocall/utils/constansts.dart';
import 'package:fakevideocall/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VoiceCallScreen extends StatefulWidget {
  const VoiceCallScreen({Key? key}) : super(key: key);

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  final stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);

  String time = "00:00";

  @override
  void initState() {
    super.initState();

    Tools.play(assets: "assets/audio.mp3");

    stopWatchTimer.onStartTimer();
  }

  @override
  void dispose() async {
    super.dispose();
    await stopWatchTimer.dispose(); // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            SizedBox(
              child: Tools.allData!.backgroundImg!.isEmpty
                  ? Image.asset(
                      "assets/bg.jpg",
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
            Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          Tools.allData!.title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                        const Text(
                          "Coming call",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<int>(
                    stream: stopWatchTimer.rawTime,
                    initialData: 0,
                    builder: (context, snap) {
                      final value = snap.data;
                      final displayTime = StopWatchTimer.getDisplayTime(
                        value!,
                        milliSecond: false,
                        hours: false,
                      );
                      return Text(
                        displayTime,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 18.0),
                      );
                    }),
                const SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      height: 150.0,
                      width: 150.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Tools.allData!.icon!.isEmpty
                            ? Image.asset(
                                "assets/bg.jpg",
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: Tools.allData!.icon!,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: SvgPicture.asset(
                        "assets/calling_buttons.svg",
                        height: 120.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Center(
                    child: AnimatedButton(
                      onPressed: () {
                        Tools.stop();
                        Navigator.pop(context);
                      },
                      shape: BoxShape.circle,
                      color: Colors.red,
                      width: 100.0,
                      child: const Icon(
                        Icons.call_end_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
