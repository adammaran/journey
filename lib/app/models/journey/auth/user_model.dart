class UserModel {
  String email;
  String uid;

  UserModel(this.email, this.uid);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(json['email'], json['uid']);
}
