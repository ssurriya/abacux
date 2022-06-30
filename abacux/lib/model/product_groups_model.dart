// To parse this JSON data, do
//
//     final productGroups = productGroupsFromJson(jsonString);

import 'dart:convert';

ProductGroups productGroupsFromJson(String str) =>
    ProductGroups.fromJson(json.decode(str));

String productGroupsToJson(ProductGroups data) => json.encode(data.toJson());

class ProductGroups {
  ProductGroups({
    this.status,
    this.message,
    this.productgroups,
  });

  String status;
  String message;
  List<Productgroup> productgroups;

  factory ProductGroups.fromJson(Map<String, dynamic> json) => ProductGroups(
        status: json["status"],
        message: json["message"],
        productgroups: List<Productgroup>.from(
            json["productgroups"].map((x) => Productgroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "productgroups":
            List<dynamic>.from(productgroups.map((x) => x.toJson())),
      };
}

class Productgroup {
  Productgroup({
    this.id,
    this.companyId,
    this.productGroupName,
    this.productHsnCode,
    this.productGroupUomId,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  int id;
  int companyId;
  String productGroupName;
  String productHsnCode;
  int productGroupUomId;
  int isDeleted;
  int createdBy;
  DateTime createdAt;
  int updatedBy;
  DateTime updatedAt;

  factory Productgroup.fromJson(Map<String, dynamic> json) => Productgroup(
        id: json["id"],
        companyId: json["company_id"],
        productGroupName: json["product_group_name"],
        productHsnCode: json["product_hsn_code"],
        productGroupUomId: json["product_group_uom_id"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "product_group_name": productGroupName,
        "product_hsn_code": productHsnCode,
        "product_group_uom_id": productGroupUomId,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_by": updatedBy == null ? null : updatedBy,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
