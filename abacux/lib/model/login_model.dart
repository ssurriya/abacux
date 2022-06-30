// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
    this.status,
    this.message,
    this.token,
    this.userRoles,
    this.companyRoles,
  });

  String status;
  String message;
  String token;
  List<UserRole> userRoles;
  List<CompanyRole> companyRoles;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        userRoles: List<UserRole>.from(
            json["user_roles"].map((x) => UserRole.fromJson(x))),
        companyRoles: List<CompanyRole>.from(
            json["company_roles"].map((x) => CompanyRole.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "token": token,
        "user_roles": List<dynamic>.from(userRoles.map((x) => x.toJson())),
        "company_roles":
            List<dynamic>.from(companyRoles.map((x) => x.toJson())),
      };
}

class CompanyRole {
  CompanyRole({
    this.id,
    this.roleName,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.companyId,
    this.companyName,
  });

  int id;
  String roleName;
  int isDeleted;
  int createdBy;
  String createdAt;
  int updatedBy;
  String updatedAt;
  int companyId;
  String companyName;

  factory CompanyRole.fromJson(Map<String, dynamic> json) => CompanyRole(
        id: json["id"],
        roleName: json["role_name"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        companyId: json["company_id"],
        companyName: json["company_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_name": roleName,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "company_id": companyId,
        "company_name": companyName,
      };
}

class UserRole {
  UserRole({
    this.id,
    this.userId,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.companyRoleId,
  });

  int id;
  int userId;
  int isDeleted;
  int createdBy;
  String createdAt;
  int updatedBy;
  String updatedAt;
  String companyRoleId;

  factory UserRole.fromJson(Map<String, dynamic> json) => UserRole(
        id: json["id"],
        userId: json["user_id"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"] == null ? 0 : json["updated_by"],
        updatedAt: json["updated_at"] == null ? "" : json["updated_at"],
        companyRoleId: json["company_role_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "company_role_id": companyRoleId,
      };
}
