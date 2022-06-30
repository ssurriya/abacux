// To parse this JSON data, do
//
//     final tax = taxFromJson(jsonString);

import 'dart:convert';

Tax taxFromJson(String str) => Tax.fromJson(json.decode(str));

String taxToJson(Tax data) => json.encode(data.toJson());

class Tax {
  Tax({
    this.status,
    this.message,
    this.taxtypesList,
  });

  String status;
  String message;
  List<TaxtypesList> taxtypesList;

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
    status: json["status"],
    message: json["message"],
    taxtypesList: List<TaxtypesList>.from(json["taxtypes_list"].map((x) => TaxtypesList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "taxtypes_list": List<dynamic>.from(taxtypesList.map((x) => x.toJson())),
  };
}

class TaxtypesList {
  TaxtypesList({
    this.id,
    this.companyId,
    this.tax,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  int id;
  int companyId;
  String tax;
  int isDeleted;
  int createdBy;
  DateTime createdAt;
  dynamic updatedBy;
  dynamic updatedAt;

  factory TaxtypesList.fromJson(Map<String, dynamic> json) => TaxtypesList(
    id: json["id"],
    companyId: json["company_id"],
    tax: json["tax"],
    isDeleted: json["is_deleted"],
    createdBy: json["created_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedBy: json["updated_by"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "tax": tax,
    "is_deleted": isDeleted,
    "created_by": createdBy,
    "created_at": createdAt.toIso8601String(),
    "updated_by": updatedBy,
    "updated_at": updatedAt,
  };
}
