class UserModel {
  final int id;
  final String fullName;
  final String email;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] as int,
      fullName: json["full_name"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      isActive: json["is_active"] == true,
    );
  }
}
