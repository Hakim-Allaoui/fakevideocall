import 'package:fakevideocall/services/admob_ad_network.dart';
import 'package:fakevideocall/services/applovin_ad_network.dart';
import 'package:fakevideocall/utils/tools.dart';
import 'package:flutter/material.dart';

class AdsHelper {
  // static late AdsModel ids;
  static ApplovinAdNetwork applovin = ApplovinAdNetwork();
  static AdmobHelper admob = AdmobHelper();

  static late String adNetwork;
  static late String appId;
  static late String appOpen;
  static late String banner;
  static late String inter;
  static late String rewarded;
  static late String native;
  static late String mRec;

  static init() async {
    adNetwork = Tools.allData.ads.adNetwork.toLowerCase();

    appId = Tools.allData.ads.ids.appId;
    appOpen = Tools.allData.ads.ids.appOpen;
    banner = Tools.allData.ads.ids.banner;
    inter = Tools.allData.ads.ids.inter;
    rewarded = Tools.allData.ads.ids.reward;
    native = Tools.allData.ads.ids.native;

    AdmobHelper.frequency = Tools.allData.ads.frequency;

    switch (adNetwork) {
      case "admob":
        await AdmobHelper.init();
        break;
      case "applovin":
        await ApplovinAdNetwork.init(sdkKey: appId);
        break;
      case "unity":
        break;
      case "facebook":
        break;
      default: //"any"
        break;
    }

    return;
  }

  Widget getBannerAd() {
    switch (adNetwork) {
      case "admob":
        return admob.getBanner(banner);
      case "applovin":
        return applovin.getBanner(banner);
      case "unity":
        return const SizedBox();
      case "facebook":
        return const SizedBox();
      default: //"any"
        return const SizedBox();
    }
  }

  Widget getNativeAd() {
    switch (adNetwork) {
      case "admob":
        return admob.getBanner(banner);
      case "applovin":
        return applovin.getMrec(native);
      case "unity":
        return const SizedBox();
      case "facebook":
        return const SizedBox();
      default: //"any"
        return const SizedBox();
    }
  }

  loadInter() async {
    switch (adNetwork) {
      case "admob":
        admob.loadInter(inter);
        break;
      case "applovin":
        await applovin.loadInter(inter);
        break;
      case "unity":
        break;
      case "facebook":
        break;
      default: //"any"
        break;
    }
  }

  showInter() async {
    switch (adNetwork) {
      case "admob":
        admob.showInter(inter);
        break;
      case "applovin":
        await applovin.showInter(inter);
        break;
      case "unity":
        break;
      case "facebook":
        break;
      default: //"any"
        break;
    }
  }

  loadAndShowInter({required BuildContext context, required VoidCallback onFinished}) async {
    switch (adNetwork) {
      case "admob":
        admob.loadAndShowInter(context: context, id: inter, onFinished: onFinished,);
        break;
      case "applovin":
        await applovin.loadAndShowInter(
            context: context, id: inter, onFinished: onFinished, frequency: Tools.allData.ads.frequency,);
        break;
      case "unity":
        break;
      case "facebook":
        break;
      default: //"any"
        break;
    }
  }

  loadReward() async {
    switch (adNetwork) {
      case "admob":
        break;
      case "applovin":
        applovin.loadReward(rewarded);
        break;
      case "unity":
        break;
      case "facebook":
        break;
      default: //"any"
        break;
    }
  }

  showReward() async {
    switch (adNetwork) {
      case "admob":
        break;
      case "applovin":
        applovin.showReward(rewarded);
        break;
      case "unity":
        break;
      case "facebook":
        break;
      default: //"any"
        break;
    }
  }
}
