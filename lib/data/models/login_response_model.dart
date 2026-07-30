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
    final Data data;

    LoginResponseModel({
        required this.success,
        required this.message,
        required this.data,
    });

    LoginResponseModel copyWith({
        bool? success,
        String? message,
        Data? data,
    }) => 
        LoginResponseModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
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
        user: User.fromJson(json["user"]),
        company: Company.fromJson(json["company"]),
        token: json["token"],
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

    User({
        required this.id,
        required this.companyId,
        required this.fullName,
        required this.email,
        required this.role,
        required this.status,
        required this.isFirstLogin,
    });

    User copyWith({
        String? id,
        String? companyId,
        String? fullName,
        String? email,
        String? role,
        String? status,
        bool? isFirstLogin,
    }) => 
        User(
            id: id ?? this.id,
            companyId: companyId ?? this.companyId,
            fullName: fullName ?? this.fullName,
            email: email ?? this.email,
            role: role ?? this.role,
            status: status ?? this.status,
            isFirstLogin: isFirstLogin ?? this.isFirstLogin,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        companyId: json["company_id"],
        fullName: json["full_name"],
        email: json["email"],
        role: json["role"],
        status: json["status"],
        isFirstLogin: json["is_first_login"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "full_name": fullName,
        "email": email,
        "role": role,
        "status": status,
        "is_first_login": isFirstLogin,
    };
}
