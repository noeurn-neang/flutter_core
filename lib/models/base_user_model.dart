abstract class BaseUserModel {
  int? id;
  String? email;

  BaseUserModel({
    this.id,
    this.email,
  });

  BaseUserModel.fromJson(Map<String, dynamic> json) {
    var employee = json['employee'];
    id = json['id'];
    email = employee['email'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    return data;
  }
}
