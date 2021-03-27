class UserInfo {
  String name;
  bool admin;

  UserInfo(this.name);

  Map<String, dynamic> toJson() => {
        'name': name,
        'admin': admin,
      };
}
