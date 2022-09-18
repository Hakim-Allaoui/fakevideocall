// import 'package:easy_ads_flutter/easy_ads_flutter.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:fake_it/utils/theme.dart';
// import 'package:fake_it/utils/tools.dart';
// import 'package:flutter/material.dart';

class AdMob {
  /*late AdManagerBannerAd _bannerAd;
  late AdManagerInterstitialAd _interstitialAd;
  late RewardedAd _rewardedAd;

  static late IAdIdManager adIdManager;

  static init() {
    *//*EasyAds.instance.initialize(
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
    *//*
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
