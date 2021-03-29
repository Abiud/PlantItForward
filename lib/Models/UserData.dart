class UserData {
  String name;
  String role;

  UserData(
    this.name,
  );

  Map<String, dynamic> toJson() => {
        'name': name,
        'role': role,
      };

  bool isAdmin() {
    return role == "admin";
  }
}
