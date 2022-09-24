import 'package:animated_button/animated_button.dart';
import 'package:camera/camera.dart';
import 'package:fakevideocall/services/ads.dart';
import 'package:fakevideocall/utils/constansts.dart';
import 'package:fakevideocall/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;

  late List<CameraDescription> _cameras;

  CameraController? controller;

  AdsHelper ads = AdsHelper();

  @override
  void initState() {
    super.initState();
    int vidIndex = Tools.getRandomInt(maxNumber: numberOfVideos);
    _controller = VideoPlayerController.asset("assets/vid_$vidIndex.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});

        _controller.play();
      });
    initCam();

    ads.loadInter();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  initCam() async {
    _cameras = await availableCameras();

    controller = CameraController(_cameras[1], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      print(">>> ${cameraController.description}");
    }
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
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: AnimatedButton(
                  onPressed: () {
                    _controller.pause();
                    controller!.dispose();
                    ads.loadAndShowInter(
                      context: context,
                      frequency: 1,
                      onFinished: () {
                        Navigator.pop(context);
                      },
                    );
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
            Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Opacity(
                    opacity: 0.8,
                    child: Container(
                      height: 200.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: controller == null ||
                                !controller!.value.isInitialized
                            ? Container()
                            : CameraPreview(controller!),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
