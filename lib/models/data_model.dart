class DataModel {
  late String title;
  late String icon;
  late String backgroundImg;
  late List<String> messages;
  late Config config;
  late Ads ads;

  DataModel(
      {required this.title,
      required this.icon,
      required this.backgroundImg,
      required this.messages,
      required this.config,
      required this.ads});

  DataModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    icon = json['icon'];
    backgroundImg = json['backgroundImg'];
    messages = json['messages'].cast<String>();
    config = Config.fromJson(json['config']);
    ads = Ads.fromJson(json['ads']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['icon'] = icon;
    data['backgroundImg'] = backgroundImg;
    data['messages'] = messages;
    data['config'] = config.toJson();
    data['ads'] = ads.toJson();

    return data;
  }
}

class Config {
  late String currentAppVersion;
  late bool forceUpdate;
  late String title;
  late String body;
  late String updateLink;
  late bool approved;

  Config(
      {required this.currentAppVersion,
      required this.forceUpdate,
      required this.title,
      required this.body,
      required this.updateLink,
      required this.approved});

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
  late String adNetwork;
  late Ids ids;
  late int frequency;

  Ads({required this.adNetwork, required this.ids, this.frequency = 2});

  Ads.fromJson(Map<String, dynamic> json) {
    adNetwork = json['adNetwork'];
    ids = Ids.fromJson(json['ids']);
    frequency = json['frequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adNetwork'] = adNetwork;
    data['ids'] = ids.toJson();
    data['frequency'] = frequency;
    return data;
  }
}

class Ids {
  late String appId;
  late String banner;
  late String inter;
  late String reward;
  late String native;
  late String appOpen;

  Ids({
    required this.appId,
    required this.banner,
    required this.inter,
    required this.reward,
    required this.native,
    required this.appOpen,
  });

  Ids.fromJson(Map<String, dynamic> json) {
    appId = json['appId'];
    banner = json['banner'];
    inter = json['inter'];
    reward = json['reward'];
    native = json['native'];
    appOpen = json['appOpen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appId'] = appId;
    data['banner'] = banner;
    data['inter'] = inter;
    data['reward'] = reward;
    data['native'] = native;
    data['appOpen'] = appOpen;
    return data;
  }
}
