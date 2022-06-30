// To parse this JSON data, do
//
//     final taxType = taxTypeFromJson(jsonString);

import 'dart:convert';

TaxType taxTypeFromJson(String str) => TaxType.fromJson(json.decode(str));

String taxTypeToJson(TaxType data) => json.encode(data.toJson());

class TaxType {
  TaxType({
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
  String createdAt;
  int updatedBy;
  String updatedAt;

  factory TaxType.fromJson(Map<String, dynamic> json) => TaxType(
        id: json["id"],
        companyId: json["company_id"],
        tax: json["tax"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "tax": tax,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
      };
}
