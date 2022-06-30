// To parse this JSON data, do
//
//     final purchaseOrderSettings = purchaseOrderSettingsFromJson(jsonString);

import 'dart:convert';

PurchaseOrderSettings purchaseOrderSettingsFromJson(String str) =>
    PurchaseOrderSettings.fromJson(json.decode(str));

String purchaseOrderSettingsToJson(PurchaseOrderSettings data) =>
    json.encode(data.toJson());

class PurchaseOrderSettings {
  PurchaseOrderSettings({
    this.id,
    this.companyId,
    this.prefix,
    this.purchaseOrderStartNumber,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isDeleted,
  });

  int id;
  int companyId;
  String prefix;
  int purchaseOrderStartNumber;
  int status;
  int createdBy;
  DateTime createdAt;
  dynamic updatedBy;
  dynamic updatedAt;
  int isDeleted;

  factory PurchaseOrderSettings.fromJson(Map<String, dynamic> json) =>
      PurchaseOrderSettings(
        id: json["id"],
        companyId: json["company_id"],
        prefix: json["prefix"],
        purchaseOrderStartNumber: json["purchase_order_start_number"],
        status: json["status"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        isDeleted: json["is_deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "prefix": prefix,
        "purchase_order_start_number": purchaseOrderStartNumber,
        "status": status,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "is_deleted": isDeleted,
      };
}
