import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// import 'package:easy_ads_flutter/easy_ads_flutter.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:fake_it/utils/theme.dart';
// import 'package:fake_it/utils/tools.dart';
// import 'package:flutter/material.dart';

class AdMobAdNetwork {
  static String get bannerID {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return "ca-app-pub-9826383179102622/2702991942";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialID {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-9826383179102622/6454534694";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeID {
    if (Platform.isAndroid) {
      return "ca-app-pub-9826383179102622/7392970013";
    } else if (Platform.isIOS) {
      return "ca-app-pub-9826383179102622/7392970013";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialVideoAdUnitId {
    if (Platform.isAndroid) {
      return "4a8eb21a858ed7b8";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  InterstitialAd? _interstitialAd;
  int num_of_attempt_load = 0;

  int calledTimes = 0;

  static bool isBannerLoaded = false;

  static Future<InitializationStatus> initialize() async {
    return MobileAds.instance.initialize();
  }

  static BannerAd getBannerAd() {
    BannerAd bAd = BannerAd(
        size: AdSize.banner,
        adUnitId: bannerID,
        listener: BannerAdListener(onAdClosed: (Ad ad) {
          print("Ad Closed");
        }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        }, onAdLoaded: (Ad ad) {
          print('Ad Loaded');
        }, onAdOpened: (Ad ad) {
          print('Ad opened');
        }),
        request: const AdRequest());
    return bAd;
  }

  static BannerAd getCustomBannerAd(BannerAdListener _listener) {
    BannerAd bAd = BannerAd(
        size: AdSize.banner,
        adUnitId: bannerID,
        listener: _listener,
        request: const AdRequest());
    return bAd;
  }

  // create interstitial ads
  void createInterstitial() {
    print("create interstitial called");

    InterstitialAd.load(
      adUnitId: interstitialID,
      request: const AdRequest(),
      adLoadCallback:
          InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
        print("Loaded interstitial");
        _interstitialAd = ad;
        num_of_attempt_load = 0;
      }, onAdFailedToLoad: (LoadAdError error) {
        num_of_attempt_load + 1;
        _interstitialAd = null;
        if (num_of_attempt_load <= 2) {
          createInterstitial();
        }
      }),
    );
  }

// show interstitial ads to user
  void showInterstitial({int frequency = 1}) {
    print("show interstitial called");
    print("interstitial Div = ${calledTimes / frequency}");
    print("interstitial Frequency = ${calledTimes % frequency}");

    if (calledTimes % frequency != 0) {
      createInterstitial();
      calledTimes++;
      return;
    }

    calledTimes++;

    if (_interstitialAd == null) {
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print("ad onAdshowedFullscreen interstitial");
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print("ad Disposed interstitial");
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror) {
        print('$ad OnAdFailed $aderror interstitial');
        ad.dispose();
        createInterstitial();
      },
      onAdWillDismissFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdWillDismissFullScreenContent interstitial');
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  /*late AdManagerBannerAd _bannerAd;
  late AdManagerInterstitialAd _interstitialAd;
  late RewardedAd _rewardedAd;

  static late IAdIdManager adIdManager;

  static init() {
    */ /*EasyAds.instance.initialize(
      adIdManager,
      enableLogger: true,
      unityTestMode: true,
      adMobAdRequest: const AdRequest(
        nonPersonalizedAds: false,
      ),
      admobConfiguration: RequestConfiguration(
        testDeviceIds: ['17a0fe30-414c-456f-9ead-789b830e7fac'],
      ),
    );
    */ /*
    MobileAds.instance.initialize().then((initializationStatus) {
      initializationStatus.adapterStatuses.forEach((key, value) {
        Tools.logger.i('Adapter status for $key: ${value.description}');
      });
    });
  }

  loadInter(String id) {
    AdManagerInterstitialAd.load(
        adUnitId: id,
        request: const AdManagerAdRequest(),
        adLoadCallback: AdManagerInterstitialAdLoadCallback(
          onAdLoaded: (AdManagerInterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;

            _interstitialAd.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdShowedFullScreenContent: (AdManagerInterstitialAd ad) =>
                  Tools.logger.i('%ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (AdManagerInterstitialAd ad) {
                Tools.logger.i('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent:
                  (AdManagerInterstitialAd ad, AdError error) {
                Tools.logger.i('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
              },
              onAdImpression: (AdManagerInterstitialAd ad) =>
                  Tools.logger.i('$ad impression occurred.'),
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            Tools.logger.i('InterstitialAd failed to load: $error');
          },
        ));
  }

  showInter() {
    _interstitialAd.show();
  }

  Future<bool> loadAndShowInter(BuildContext context, String id) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          AdManagerInterstitialAd.load(
              adUnitId: id,
              request: const AdManagerAdRequest(),
              adLoadCallback: AdManagerInterstitialAdLoadCallback(
                onAdLoaded: (AdManagerInterstitialAd ad) {
                  // Keep a reference to the ad so you can show it later.
                  _interstitialAd = ad;

                  _interstitialAd.fullScreenContentCallback =
                      FullScreenContentCallback(
                    onAdShowedFullScreenContent: (AdManagerInterstitialAd ad) =>
                        Tools.logger.i('$ad onAdShowedFullScreenContent.'),
                    onAdDismissedFullScreenContent:
                        (AdManagerInterstitialAd ad) {
                      Tools.logger.i('$ad onAdDismissedFullScreenContent.');
                      ad.dispose();
                      Navigator.pop(context, true);
                    },
                    onAdFailedToShowFullScreenContent:
                        (AdManagerInterstitialAd ad, AdError error) {
                      Tools.logger
                          .i('$ad onAdFailedToShowFullScreenContent: $error');
                      ad.dispose();
                    },
                    onAdImpression: (AdManagerInterstitialAd ad) =>
                        Tools.logger.i('$ad impression occurred.'),
                  );

                  _interstitialAd.show();
                },
                onAdFailedToLoad: (LoadAdError error) {
                  Tools.logger.i('InterstitialAd failed to load: $error');

                  Navigator.pop(context, false);
                },
              ));

          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            backgroundColor:
                Prefs.isDarkMode ? S.colors.darkGrey : S.colors.white,
            content: WillPopScope(
              onWillPop: () => Future.value(false),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("loading".tr()),
                  const SizedBox(
                    height: 40.0,
                  ),
                  SizedBox(
                    height: 40.0,
                    width: 40.0,
                    child: CircularProgressIndicator(
                      color: Prefs.isDarkMode ? S.colors.light : S.colors.dark,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  loadReward(String id) {
    RewardedAd.loadWithAdManagerAdRequest(
      adUnitId: id,
      adManagerRequest: const AdManagerAdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          Tools.logger.i('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;

          _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) =>
                Tools.logger.i('$ad onAdShowedFullScreenContent.'),
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              Tools.logger.i('$ad onAdDismissedFullScreenContent.');
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              Tools.logger.i('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
            },
            onAdImpression: (RewardedAd ad) =>
                Tools.logger.i('$ad impression occurred.'),
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          Tools.logger.i('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  showReward() {
    _rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      // Reward the user for watching an ad.
      Tools.logger.i("Rewarded - rewardItem: " + rewardItem.toString());
    });
  }

  loadBanner(String id) {
    _bannerAd = AdManagerBannerAd(
      adUnitId: id,
      sizes: [AdSize.banner],
      request: const AdManagerAdRequest(),
      listener: AdManagerBannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          Tools.logger.i(
              'Banner: (${ad.adUnitId}) loaded\nmediationAdapterClassName: ${ad.responseInfo?.mediationAdapterClassName}');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          _bannerAd.dispose();
          Tools.logger.i('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => Tools.logger.i('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => Tools.logger.i('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => Tools.logger.i('Ad impression.'),
      ),
    );
    _bannerAd.load();
  }

  Widget getBanner() {
    return Container(
      height: 60.0,
      alignment: Alignment.center,
      child: AdWidget(
        ad: _bannerAd,
      ),
    );
  }

  static showAdmobConsent() async {}*/
}

// class TestAdIdManager extends IAdIdManager {
//   final String? admobAppId;
//   final String? admobBannerId;
//   final String? admobInterId;
//   final String? admobRewardId;
//
//   final String? unityAppId;
//   final String? unityBannerId;
//   final String? unityInterId;
//   final String? unityRewardId;
//
//   final String? applovinAppId;
//   final String? applovinInterId;
//   final String? applovinRewardId;
//
//
//   TestAdIdManager(
//       {this.admobAppId,
//         this.admobBannerId,
//         this.admobInterId,
//         this.admobRewardId,
//         this.unityAppId,
//         this.unityBannerId,
//         this.unityInterId,
//         this.unityRewardId,
//         this.applovinAppId,
//         this.applovinInterId,
//         this.applovinRewardId});
//
//   @override
//   AppAdIds? get admobAdIds => AppAdIds(
//     appId: 'ca-app-pub-3940256099942544~1458002511',
//     bannerId: BannerAd.testAdUnitId,
//     interstitialId: InterstitialAd.testAdUnitId,
//     rewardedId: RewardedAd.testAdUnitId,
//   );
//
//   @override
//   AppAdIds? get unityAdIds => AppAdIds(
//     appId: admobAppId!,
//     bannerId: admobBannerId,
//     interstitialId:  admobInterId,
//     rewardedId: admobRewardId,
//   );
//
//   @override
//   AppAdIds? get appLovinAdIds => AppAdIds(
//     appId: applovinAppId!,
//     interstitialId: applovinInterId,
//     rewardedId: applovinRewardId,
//   );
//
//   @override
//   AppAdIds? get fbAdIds => null;
// }
