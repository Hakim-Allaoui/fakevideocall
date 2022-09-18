import 'package:fakevideocall/services/applovin_ad_network.dart';
import 'package:fakevideocall/utils/tools.dart';
import 'package:flutter/material.dart';

class AdsHelper {
  // static late AdsModel ids;
  static late ApplovinAdNetwork applovin;

  static init() async {
    switch (Tools.allData?.ads!.adNetwork!.toLowerCase()) {
      case "admob":
        break;
      case "applovin":
        applovin = ApplovinAdNetwork();
        await ApplovinAdNetwork.init();
        break;
      case "unity":
        break;
      case "facebook":
        break;
      default: //"any"
        break;
    }
  }

  Widget getBannerAd() {
    switch (Tools.allData?.ads!.adNetwork!.toLowerCase()) {
      case "admob":
        return const SizedBox();
      case "applovin":
        return applovin.getBanner(Tools.allData!.ads!.ids!.banners![0]);
      case "unity":
        return const SizedBox();
      case "facebook":
        return const SizedBox();
      default: //"any"
        return const SizedBox();
    }
  }

  Widget getMrec() {
    switch (Tools.allData?.ads!.adNetwork!.toLowerCase()) {
      case "admob":
        return const SizedBox();
      case "applovin":
        return applovin.getMrec(Tools.allData!.ads!.ids!.mRecs![0]);
      case "unity":
        return const SizedBox();
      case "facebook":
        return const SizedBox();
      default: //"any"
        return const SizedBox();
    }
  }

  loadInter() async {
    switch (Tools.allData?.ads!.adNetwork!.toLowerCase()) {
      case "admob":
        break;
      case "applovin":
        await applovin.loadInter(Tools.allData!.ads!.ids!.inters![0]);
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
    switch (Tools.allData?.ads!.adNetwork!.toLowerCase()) {
      case "admob":
        break;
      case "applovin":
        await applovin.showInter(Tools.allData!.ads!.ids!.inters![0]);
        break;
      case "unity":
        break;
      case "facebook":
        break;
      default: //"any"
        break;
    }
  }

  loadAndShowInter(BuildContext context, VoidCallback onFinished) async {
    switch (Tools.allData?.ads!.adNetwork!.toLowerCase()) {
      case "admob":
        break;
      case "applovin":
        await applovin.loadAndShowInter(
            context, Tools.allData!.ads!.ids!.inters![0], onFinished);
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
    switch (Tools.allData?.ads!.adNetwork!.toLowerCase()) {
      case "admob":
        break;
      case "applovin":
        applovin.loadReward(Tools.allData!.ads!.ids!.rewards![0]);
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
    switch (Tools.allData?.ads!.adNetwork!.toLowerCase()) {
      case "admob":
        break;
      case "applovin":
        applovin.showReward(Tools.allData!.ads!.ids!.rewards![0]);
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

class AdsModel {
  String defaultNetwork;
  Admob admob;
  Applovin applovin;
  Unity unity;

  AdsModel(
      {required this.admob,
      required this.applovin,
      required this.defaultNetwork,
      required this.unity});

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      admob: Admob.fromJson(json['admob']),
      applovin: Applovin.fromJson(json['applovin']),
      defaultNetwork: json['defaultNetwork'],
      unity: Unity.fromJson(json['unity']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['defaultNetwork'] = defaultNetwork;
    data['admob'] = admob.toJson();
    data['applovin'] = applovin.toJson();
    data['unity'] = unity.toJson();
    return data;
  }
}

class Admob {
  String appId;
  List<String> banner;
  List<String> inter;
  List<String> native;
  List<String> reward;

  Admob(
      {required this.appId,
      required this.banner,
      required this.inter,
      required this.native,
      required this.reward});

  factory Admob.fromJson(Map<String, dynamic> json) {
    return Admob(
      appId: json['appId'],
      banner: List<String>.from(json['banner']),
      inter: List<String>.from(json['inter']),
      native: List<String>.from(json['native']),
      reward: List<String>.from(json['reward']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appId'] = appId;
    data['banner'] = banner;
    data['inter'] = inter;
    data['native'] = native;
    data['reward'] = reward;
    return data;
  }
}

class Applovin {
  String appId;
  List<String> banner;
  List<String> inter;
  List<String> native;
  List<String> reward;

  Applovin(
      {required this.appId,
      required this.banner,
      required this.inter,
      required this.native,
      required this.reward});

  factory Applovin.fromJson(Map<String, dynamic> json) {
    return Applovin(
      appId: json['appId'],
      banner: List<String>.from(json['banner']),
      inter: List<String>.from(json['inter']),
      native: List<String>.from(json['native']),
      reward: List<String>.from(json['reward']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appId'] = appId;
    data['banner'] = banner;
    data['inter'] = inter;
    data['native'] = native;
    data['reward'] = reward;
    return data;
  }
}

class Unity {
  String appId;
  List<String> banner;
  List<String> inter;
  List<String> native;
  List<String> reward;

  Unity(
      {required this.appId,
      required this.banner,
      required this.inter,
      required this.native,
      required this.reward});

  factory Unity.fromJson(Map<String, dynamic> json) {
    return Unity(
      appId: json['appId'],
      banner: List<String>.from(json['banner']),
      inter: List<String>.from(json['inter']),
      native: List<String>.from(json['native']),
      reward: List<String>.from(json['reward']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appId'] = appId;
    data['banner'] = banner;
    data['inter'] = inter;
    data['native'] = native;
    data['reward'] = reward;
    return data;
  }
}
