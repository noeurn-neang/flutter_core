class BaseUserModel {
  BaseUserModel({
    this.id,
    this.email,
  });

  int? id;
  String? email;

  BaseUserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        email = json['email'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
      };
}
