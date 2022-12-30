import 'package:fakevideocall/services/app_open_ad_helper.dart';
import 'package:fakevideocall/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class AdmobHelper {
  static InterstitialAd? _interstitialAd;

  static int numOfAttemptToLoad = 0;

  int calledTimes = 0;

  static int frequency = 2;

  static init() async {
    await MobileAds.instance.initialize();
  }

  Widget getBanner(String id) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomBannerAd(
        id: id,
      ),
    );
  }

  Widget getNative(String id) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomBannerAd(
        id: id,
      ),
    );
  }

  // create interstitial ads (2)
  void loadInter(String id) {
    Tools.logger.i("create interstitial called");

    if (_interstitialAd != null) {
      Tools.logger.i("interstitial already created called");
      return;
    }

    InterstitialAd.load(
      adUnitId: id,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          Tools.logger.i("Loaded interstitial");
          _interstitialAd = ad;
          numOfAttemptToLoad = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          numOfAttemptToLoad = numOfAttemptToLoad + 1;
          if (numOfAttemptToLoad <= 2) {
            loadInter(id);
          }
          _interstitialAd = null;
        },
      ),
    );
  }

// show interstitial ads to user (2)
  showInter(String id) {
    /*interCalledTimes++;

    Tools.logger.i(
        "\ntteesstt frequency= $frequency / recommendationCalledTimes= $interCalledTimes" +
            "\ntteesstt interstitial Div = ${frequency / interCalledTimes}" +
            "\ntteesstt interstitial Frequency = ${interCalledTimes % frequency}");

    if (interCalledTimes % frequency != 0) {
      if (_interstitialAd == null) {
        createInterstitialStatic();
      }
      return;
    }
    */

    if (_interstitialAd == null) {
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        Tools.logger.i("ad onAdShowedFullscreen interstitial");
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        Tools.logger.i("ad Disposed interstitial");
        ad.dispose();
        loadInter(id);
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError adError) {
        Tools.logger.i('$ad OnAdFailed $adError interstitial');
        ad.dispose();
      },
      onAdWillDismissFullScreenContent: (InterstitialAd ad) {
        Tools.logger.i('$ad onAdWillDismissFullScreenContent interstitial');
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  loadAndShowInter({
    required BuildContext context,
    required String id,
    required VoidCallback onFinished,
  }) async {
    Tools.logger.i("show interstitial called");
    Tools.logger.i("interstitial Div = ${calledTimes / frequency}");
    Tools.logger.i("interstitial Frequency = ${calledTimes % frequency}");

    if (calledTimes % frequency != 0) {
      onFinished();
      calledTimes++;
      return;
    }

    calledTimes++;

    bool ok = false;

    Future.delayed(const Duration(seconds: 10), () {
      if (!ok) {
        Navigator.pop(context);
        onFinished();
        Tools.logger.i("TIMEOUT");
        return;
      }
    });

    Tools.waitingDialog(
        context: context,
        process: () {
          InterstitialAd.load(
            adUnitId: id,
            request: const AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (InterstitialAd ad) {
                Tools.logger.i("Loaded interstitial");
                _interstitialAd = ad;
                numOfAttemptToLoad = 0;

                _interstitialAd!.fullScreenContentCallback =
                    FullScreenContentCallback(
                      onAdShowedFullScreenContent: (InterstitialAd ad) {
                        Tools.logger.i("adss onAdShowedFullscreen interstitial");
                      },
                      onAdDismissedFullScreenContent: (InterstitialAd ad) {
                        AppLifecycleReactor.pausedByInterstitial = true;

                        Tools.logger.i("adss Disposed interstitial");
                        ad.dispose();
                        loadInter(id);

                        ok = true;
                        Navigator.pop(context);
                        onFinished();
                        return;
                      },
                      onAdFailedToShowFullScreenContent:
                          (InterstitialAd ad, AdError adError) {
                        Tools.logger.e('adss $ad OnAdFailed $adError interstitial');
                        ad.dispose();
                      },
                      onAdWillDismissFullScreenContent: (InterstitialAd ad) {
                        Tools.logger.e(
                            'adss $ad onAdWillDismissFullScreenContent interstitial');
                      },
                    );

                _interstitialAd!.show();
                _interstitialAd = null;
              },
              onAdFailedToLoad: (LoadAdError error) {
                numOfAttemptToLoad = numOfAttemptToLoad + 1;
                if (numOfAttemptToLoad <= 2) {
                  loadInter(id);
                }
                _interstitialAd = null;

                ok = true;
                Navigator.pop(context);
                onFinished();
                return;
              },
            ),
          );
        });
  }
}

class CustomBannerAd extends StatefulWidget {
  const CustomBannerAd({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<CustomBannerAd> createState() => _CustomBannerAdState();
}

class _CustomBannerAdState extends State<CustomBannerAd> {
  BannerAd? bannerAd;
  bool isBannerAdLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: widget.id,
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          Tools.logger.i("Ad Failed to Load\nError: ${error.message}");
          ad.dispose();
        },
        onAdLoaded: (ad) {
          Tools.logger.i("Ad Loaded");
          setState(() {
            isBannerAdLoaded = true;
          });
        },
      ),
      request: const AdRequest(),
    );

    bannerAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    return isBannerAdLoaded
        ? SizedBox(
            width: double.infinity, height: 50, child: AdWidget(ad: bannerAd!))
        : const SizedBox();
  }
}