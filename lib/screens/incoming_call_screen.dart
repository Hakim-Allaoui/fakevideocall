import 'dart:ui';

import 'package:animated_button/animated_button.dart';
import 'package:fakevideocall/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IncomingCallScreen extends StatefulWidget {
  const IncomingCallScreen({Key? key, required this.nextScreen})
      : super(key: key);

  final Widget nextScreen;

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  @override
  void initState() {
    super.initState();
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.0),
                  child: Center(
                    child: Text(
                      "Incoming Call",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      height: 200.0,
                      width: 200.0,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: const [
                          Icon(
                            Icons.alarm,
                            color: Colors.white,
                          ),
                          Text(
                            "Remind Me",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: const [
                          Icon(
                            Icons.message,
                            color: Colors.white,
                          ),
                          Text(
                            "Message",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AnimatedButton(
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
                      AnimatedButton(
                        onPressed: () {
                          Tools.stop();

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => widget.nextScreen));
                        },
                        shape: BoxShape.circle,
                        color: Colors.green,
                        width: 100.0,
                        child: const Icon(
                          Icons.call_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
