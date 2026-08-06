class DepartmentModel {
  final String id;
  final String name;

  const DepartmentModel({required this.id, required this.name});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class ProfileModel {
  final String fullName;
  final String email;
  final String phone;
  final String? dateOfBirth;
  final String? gender; // 'male' | 'female'
  final String? nationality;
  final String? residence;
  final String? jobTitle;
  final DepartmentModel? department;
  final String? hireDate;
  final String? profileImageUrl;
  final bool profileCompleted;

  const ProfileModel({
    required this.fullName,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    this.gender,
    this.nationality,
    this.residence,
    this.jobTitle,
    this.department,
    this.hireDate,
    this.profileImageUrl,
    required this.profileCompleted,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      dateOfBirth: json['date_of_birth']?.toString(),
      gender: json['gender']?.toString(),
      nationality: json['nationality']?.toString(),
      residence: json['residence']?.toString(),
      jobTitle: json['job_title']?.toString(),
      department: json['department'] != null
          ? DepartmentModel.fromJson(json['department'] as Map<String, dynamic>)
          : null,
      hireDate: json['hire_date']?.toString(),
      profileImageUrl: json['profile_image_url']?.toString(),
      profileCompleted: json['profile_completed'] == true,
    );
  }

  ProfileModel copyWith({
    String? phone,
    String? residence,
    String? profileImageUrl,
    bool? profileCompleted,
  }) {
    return ProfileModel(
      fullName: fullName,
      email: email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth,
      gender: gender,
      nationality: nationality,
      residence: residence ?? this.residence,
      jobTitle: jobTitle,
      department: department,
      hireDate: hireDate,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      profileCompleted: profileCompleted ?? this.profileCompleted,
    );
  }
}
