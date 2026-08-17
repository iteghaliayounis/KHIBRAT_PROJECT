// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
    final bool success;
    final String message;
    final Data? data;
    final bool requires2fa;
    final String? twoFactorEmail;

    LoginResponseModel({
        required this.success,
        required this.message,
        this.data,
        this.requires2fa = false,
        this.twoFactorEmail,
    });

    LoginResponseModel copyWith({
        bool? success,
        String? message,
        Data? data,
        bool? requires2fa,
        String? twoFactorEmail,
    }) => 
        LoginResponseModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
            requires2fa: requires2fa ?? this.requires2fa,
            twoFactorEmail: twoFactorEmail ?? this.twoFactorEmail,
        );

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
        final rawData = json["data"];
        final dataMap = rawData is Map<String, dynamic>
            ? rawData
            : rawData is Map
                ? Map<String, dynamic>.from(rawData)
                : null;
        final requires2fa = dataMap?["requires_2fa"] == true;

        return LoginResponseModel(
            success: json["success"] == true,
            message: json["message"]?.toString() ?? '',
            requires2fa: requires2fa,
            twoFactorEmail: dataMap?["email"]?.toString(),
            data: (!requires2fa &&
                    dataMap != null &&
                    dataMap["token"] != null)
                ? Data.fromJson(dataMap)
                : null,
        );
    }

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        if (requires2fa) "requires_2fa": true,
    };
}

class Data {
    final User user;
    final Company company;
    final String token;

    Data({
        required this.user,
        required this.company,
        required this.token,
    });

    Data copyWith({
        User? user,
        Company? company,
        String? token,
    }) => 
        Data(
            user: user ?? this.user,
            company: company ?? this.company,
            token: token ?? this.token,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] is Map
            ? User.fromJson(Map<String, dynamic>.from(json["user"] as Map))
            : User(
                id: '',
                companyId: '',
                fullName: '',
                email: json["email"]?.toString() ?? '',
                role: '',
                status: '',
                isFirstLogin: false,
              ),
        company: json["company"] is Map
            ? Company.fromJson(Map<String, dynamic>.from(json["company"] as Map))
            : Company(id: '', name: ''),
        token: json["token"]?.toString() ?? '',
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "company": company.toJson(),
        "token": token,
    };
}

class Company {
    final String id;
    final String name;

    Company({
        required this.id,
        required this.name,
    });

    Company copyWith({
        String? id,
        String? name,
    }) => 
        Company(
            id: id ?? this.id,
            name: name ?? this.name,
        );

    factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class User {
    final String id;
    final String companyId;
    final String fullName;
    final String email;
    final String role;
    final String status;
    final bool isFirstLogin;
    final bool twoFactorEnabled;

    User({
        required this.id,
        required this.companyId,
        required this.fullName,
        required this.email,
        required this.role,
        required this.status,
        required this.isFirstLogin,
        this.twoFactorEnabled = false,
    });

    User copyWith({
        String? id,
        String? companyId,
        String? fullName,
        String? email,
        String? role,
        String? status,
        bool? isFirstLogin,
        bool? twoFactorEnabled,
    }) => 
        User(
            id: id ?? this.id,
            companyId: companyId ?? this.companyId,
            fullName: fullName ?? this.fullName,
            email: email ?? this.email,
            role: role ?? this.role,
            status: status ?? this.status,
            isFirstLogin: isFirstLogin ?? this.isFirstLogin,
            twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"]?.toString() ?? '',
        companyId: json["company_id"]?.toString() ?? '',
        fullName: json["full_name"]?.toString() ?? '',
        email: json["email"]?.toString() ?? '',
        role: json["role"]?.toString() ?? '',
        status: json["status"]?.toString() ?? '',
        isFirstLogin: json["is_first_login"] == true,
        twoFactorEnabled: json["two_factor_enabled"] == true,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "full_name": fullName,
        "email": email,
        "role": role,
        "status": status,
        "is_first_login": isFirstLogin,
        "two_factor_enabled": twoFactorEnabled,
    };
}
