import 'dart:convert';

Permission permissionFromJson(String str) =>
    Permission.fromJson(json.decode(str));

String permissionToJson(Permission data) => json.encode(data.toJson());

class Permission {
  Permission({
    this.status,
    this.message,
    this.token,
    this.innerComapnyMessage,
    this.userId,
    this.companyAuthId,
    this.permissions,
  });

  String status;
  String message;
  String token;
  String innerComapnyMessage;
  String userId;
  String companyAuthId;
  List<String> permissions;

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        innerComapnyMessage: json["inner_comapny_message"],
        userId: json["user_id"],
        companyAuthId: json["company_auth_id"],
        permissions: List<String>.from(json["Permissions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "token": token,
        "inner_comapny_message": innerComapnyMessage,
        "user_id": userId,
        "company_auth_id": companyAuthId,
        "Permissions": List<dynamic>.from(permissions.map((x) => x)),
      };
}
