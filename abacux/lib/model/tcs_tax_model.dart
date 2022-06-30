// To parse this JSON data, do
//
//     final tcsTax = tcsTaxFromJson(jsonString);

import 'dart:convert';

TcsTax tcsTaxFromJson(String str) => TcsTax.fromJson(json.decode(str));

String tcsTaxToJson(TcsTax data) => json.encode(data.toJson());

class TcsTax {
  TcsTax({
    this.status,
    this.message,
    this.tcsTaxType,
  });

  String status;
  String message;
  List<TcsTaxType> tcsTaxType;

  factory TcsTax.fromJson(Map<String, dynamic> json) => TcsTax(
        status: json["status"],
        message: json["message"],
        tcsTaxType: List<TcsTaxType>.from(
            json["tcs_tax_type"].map((x) => TcsTaxType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "tcs_tax_type": List<dynamic>.from(tcsTaxType.map((x) => x.toJson())),
      };
}

class TcsTaxType {
  TcsTaxType({
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
  dynamic createdBy;
  dynamic createdAt;
  dynamic updatedBy;
  dynamic updatedAt;

  factory TcsTaxType.fromJson(Map<String, dynamic> json) => TcsTaxType(
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
