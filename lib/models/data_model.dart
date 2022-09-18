class DataModel {
  String? title;
  String? icon;
  String? backgroundImg;
  List<String>? messages;
  String? backgroundColor;
  Config? config;
  Ads? ads;

  DataModel(
      {this.title,
      this.icon,
      this.backgroundImg,
      this.messages,
      this.backgroundColor,
      this.config,
      this.ads});

  DataModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    icon = json['icon'];
    backgroundImg = json['backgroundImg'];
    messages = json['messages'].cast<String>();
    backgroundColor = json['backgroundColor'];
    config = json['config'] != null ? Config.fromJson(json['config']) : null;
    ads = json['ads'] != null ? Ads.fromJson(json['ads']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['icon'] = icon;
    data['backgroundImg'] = backgroundImg;
    data['messages'] = messages;
    data['backgroundColor'] = backgroundColor;
    if (config != null) {
      data['config'] = config!.toJson();
    }
    if (ads != null) {
      data['ads'] = ads!.toJson();
    }
    return data;
  }
}

class Config {
  String? currentAppVersion;
  bool? forceUpdate;
  String? title;
  String? body;
  String? updateLink;
  bool? approved;

  Config(
      {this.currentAppVersion,
      this.forceUpdate,
      this.title,
      this.body,
      this.updateLink,
      this.approved});

  Config.fromJson(Map<String, dynamic> json) {
    currentAppVersion = json['currentAppVersion'];
    forceUpdate = json['forceUpdate'];
    title = json['title'];
    body = json['body'];
    updateLink = json['updateLink'];
    approved = json['approved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentAppVersion'] = currentAppVersion;
    data['forceUpdate'] = forceUpdate;
    data['title'] = title;
    data['body'] = body;
    data['updateLink'] = updateLink;
    data['approved'] = approved;
    return data;
  }
}

class Ads {
  String? adNetwork;
  Ids? ids;

  Ads({this.adNetwork, this.ids});

  Ads.fromJson(Map<String, dynamic> json) {
    adNetwork = json['adNetwork'];
    ids = json['ids'] != null ? Ids.fromJson(json['ids']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adNetwork'] = adNetwork;
    if (ids != null) {
      data['ids'] = ids!.toJson();
    }
    return data;
  }
}

class Ids {
  String? appId;
  List<String>? banners;
  List<String>? inters;
  List<String>? rewards;
  List<String>? natives;
  List<String>? mRecs;

  Ids(
      {this.appId,
      this.banners,
      this.inters,
      this.rewards,
      this.natives,
      this.mRecs});

  Ids.fromJson(Map<String, dynamic> json) {
    appId = json['appId'];
    banners = json['banners'].cast<String>();
    inters = json['inters'].cast<String>();
    rewards = json['rewards'].cast<String>();
    natives = json['natives'].cast<String>();
    mRecs = json['mRecs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appId'] = appId;
    data['banners'] = banners;
    data['inters'] = inters;
    data['rewards'] = rewards;
    data['natives'] = natives;
    data['mRecs'] = mRecs;
    return data;
  }
}
