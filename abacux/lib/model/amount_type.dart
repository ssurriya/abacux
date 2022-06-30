// To parse this JSON data, do
//
//     final amountType = amountTypeFromJson(jsonString);

import 'dart:convert';

AmountType amountTypeFromJson(String str) =>
    AmountType.fromJson(json.decode(str));

String amountTypeToJson(AmountType data) => json.encode(data.toJson());

class AmountType {
  AmountType({
    this.status,
    this.message,
    this.taxtype,
  });

  String status;
  String message;
  List<TaxType> taxtype;

  factory AmountType.fromJson(Map<String, dynamic> json) => AmountType(
        status: json["status"],
        message: json["message"],
        taxtype:
            List<TaxType>.from(json["taxtype"].map((x) => TaxType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "taxtype": List<dynamic>.from(taxtype.map((x) => x.toJson())),
      };
}

class TaxType {
  TaxType({
    this.id,
    this.taxType,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  int id;
  String taxType;
  int isDeleted;
  int createdBy;
  String createdAt;
  dynamic updatedBy;
  dynamic updatedAt;

  factory TaxType.fromJson(Map<String, dynamic> json) => TaxType(
        id: json["id"],
        taxType: json["tax_type"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tax_type": taxType,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
      };
}
