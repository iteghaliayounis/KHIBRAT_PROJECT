class UserModel {
  final dynamic id;
  final String? name;
  final String? email;
  final bool isFirstLogin;
  final Map<String, dynamic> raw;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.isFirstLogin = false,
    this.raw = const {},
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? json['full_name'],
      email: json['email'],
      isFirstLogin: json['is_first_login'] == true ||
          json['first_login'] == true ||
          json['must_change_password'] == true,
      raw: Map<String, dynamic>.from(json), // 👈 ضمان النمط الصريح
    );
  }

  Map<String, dynamic> toJson() {
    if (raw.isNotEmpty) return raw;
    return {
      'id': id,
      'full_name': name,
      'email': email,
      'is_first_login': isFirstLogin,
    };
  }
}