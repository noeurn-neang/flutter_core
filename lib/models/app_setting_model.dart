class AppSettingModel {
  int? id;
  String? code;
  String? name;
  String? description;
  String? version;
  int? versionCode;
  String? privacy;
  String? contactUs;

  AppSettingModel(
      {this.id,
        this.code,
        this.name,
        this.description,
        this.version,
        this.versionCode,
        this.privacy,
        this.contactUs,
      });

  AppSettingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    version = json['version'];
    versionCode = json['versionCode'];
    privacy = json['privacy'];
    contactUs = json['contactUs'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['description'] = description;
    data['version'] = version;
    data['versionCode'] = versionCode;
    data['privacy'] = privacy;
    data['contactUs'] = contactUs;
    return data;
  }
}
