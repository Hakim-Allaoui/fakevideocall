import 'dart:math';

import 'package:fakevideocall/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:applovin_max/applovin_max.dart';

class ApplovinAdNetwork {
  bool isRewardedVideoAvailable = false;
  bool isInterstitialVideoAvailable = false;
  static String SDK_KEY_HERE =
      "QO91l1_TOsERBEiVdyJ1_v6565RlGQWzRisC9X6f4R7ycMd9S-piVBfREtbtmUp8IDf8a3H_O-fk-rFy9nk0JH";
  static var _interstitialRetryAttempt = 0;
  static var _rewardedAdRetryAttempt = 0;

  static init() async {
    Map? sdkConfiguration = await AppLovinMAX.initialize(SDK_KEY_HERE);
    AppLovinMAX.setTestDeviceAdvertisingIds(
        ["792a89f5-c67c-4eaf-9a77-e5bfff0844b3"]);

    //TODO: comment the following
    AppLovinMAX.showMediationDebugger();
    Tools.logger.i(sdkConfiguration);
  }

  loadInter(String id) async {
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialReady(id) will now return 'true'
        Tools.logger.i('Interstitial ad loaded from ${ad.networkName}');

        // Reset retry attempt
        _interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        _interstitialRetryAttempt = _interstitialRetryAttempt + 1;

        int retryDelay = pow(2, min(6, _interstitialRetryAttempt)).toInt();

        Tools.logger.i(
            'Interstitial ad failed to load with code ${error.code} - retrying in ${retryDelay}s');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial(id);
        });
      },
      onAdDisplayedCallback: (ad) {},
      onAdDisplayFailedCallback: (ad, error) {},
      onAdClickedCallback: (ad) {},
      onAdHiddenCallback: (ad) {},
    ));

    // Load the first interstitial
    AppLovinMAX.loadInterstitial(id);
  }

  showInter(String id) async {
    bool? isReady = await AppLovinMAX.isInterstitialReady(id);
    if (isReady ?? false) {
      AppLovinMAX.showInterstitial(id);
    } else {
      Tools.logger.e("Applovin Interstitial not ready yet");
    }
  }

  loadAndShowInter(
      BuildContext context, String id, VoidCallback onFinished) async {
    Tools.waitingDialog(
        context: context,
        process: () {
          AppLovinMAX.setInterstitialListener(
            InterstitialListener(
              onAdLoadedCallback: (ad) async {
                // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialReady(id) will now return 'true'
                Tools.logger.i('Interstitial ad loaded from ${ad.networkName}');

                // Reset retry attempt
                _interstitialRetryAttempt = 0;

                await showInter(id);
                return;
              },
              onAdLoadFailedCallback: (adUnitId, error) {
                // Interstitial ad failed to load
                // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
                _interstitialRetryAttempt = _interstitialRetryAttempt + 1;

                int retryDelay =
                    pow(2, min(6, _interstitialRetryAttempt)).toInt();

                Tools.logger.i(
                    'Interstitial ad failed to load with code ${error.code} - retrying in ${retryDelay}s');

                Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
                  AppLovinMAX.loadInterstitial(id);
                });

                Navigator.pop(context);
                onFinished();
                return;
              },
              onAdDisplayedCallback: (ad) {},
              onAdDisplayFailedCallback: (ad, error) {},
              onAdClickedCallback: (ad) {},
              onAdHiddenCallback: (ad) {
                Navigator.pop(context);
                onFinished();
                return;
              },
            ),
          );

          // Load the first interstitial
          AppLovinMAX.loadInterstitial(id);
        });
  }

  loadReward(String id) {
    AppLovinMAX.setRewardedAdListener(RewardedAdListener(
        onAdLoadedCallback: (ad) {
          // Rewarded ad is ready to be shown. AppLovinMAX.isRewardedAdReady(_rewarded_ad_unit_id) will now return 'true'
          Tools.logger.i('Rewarded ad loaded from ${ad.networkName}');

          // Reset retry attempt
          _rewardedAdRetryAttempt = 0;
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          // Rewarded ad failed to load
          // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
          _rewardedAdRetryAttempt = _rewardedAdRetryAttempt + 1;

          int retryDelay = pow(2, min(6, _rewardedAdRetryAttempt)).toInt();
          Tools.logger.i(
              'Rewarded ad failed to load with code ${error.code} - retrying in ${retryDelay}s');

          Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
            AppLovinMAX.loadRewardedAd(id);
          });
        },
        onAdDisplayedCallback: (ad) {},
        onAdDisplayFailedCallback: (ad, error) {},
        onAdClickedCallback: (ad) {},
        onAdHiddenCallback: (ad) {},
        onAdReceivedRewardCallback: (ad, reward) {}));
  }

  showReward(String id) async {
    bool? isReady = await AppLovinMAX.isRewardedAdReady(id);

    if (isReady ?? false) {
      AppLovinMAX.showRewardedAd(id);
    } else {
      Tools.logger.e("Applovin Reward not ready yet");
    }
  }

  loadBanner() {}

  Widget getBanner(String id) {
    return MaxAdView(
      adUnitId: id,
      adFormat: AdFormat.banner,
      listener: AdViewAdListener(
        onAdLoadedCallback: (ad) {},
        onAdLoadFailedCallback: (adUnitId, error) {},
        onAdClickedCallback: (ad) {},
        onAdExpandedCallback: (ad) {},
        onAdCollapsedCallback: (ad) {},
      ),
    );
  }

  Widget getMrec(String id) {
    return MaxAdView(
        adUnitId: id,
        adFormat: AdFormat.mrec,
        listener: AdViewAdListener(
            onAdLoadedCallback: (ad) {},
            onAdLoadFailedCallback: (adUnitId, error) {},
            onAdClickedCallback: (ad) {},
            onAdExpandedCallback: (ad) {},
            onAdCollapsedCallback: (ad) {}));
  }

  static showAdmobConsent() async {}
}
