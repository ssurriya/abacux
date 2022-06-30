// To parse this JSON data, do
//
//     final productUnoms = productUnomsFromJson(jsonString);

import 'dart:convert';

ProductUnoms productUnomsFromJson(String str) =>
    ProductUnoms.fromJson(json.decode(str));

String productUnomsToJson(ProductUnoms data) => json.encode(data.toJson());

class ProductUnoms {
  ProductUnoms({
    this.status,
    this.message,
    this.productuoms,
  });

  String status;
  String message;
  List<Productuom> productuoms;

  factory ProductUnoms.fromJson(Map<String, dynamic> json) => ProductUnoms(
        status: json["status"],
        message: json["message"],
        productuoms: List<Productuom>.from(
            json["productuoms"].map((x) => Productuom.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "productuoms": List<dynamic>.from(productuoms.map((x) => x.toJson())),
      };
}

class Productuom {
  Productuom({
    this.id,
    this.companyId,
    this.uomCode,
    this.uomName,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  int id;
  int companyId;
  String uomCode;
  String uomName;
  int isDeleted;
  int createdBy;
  DateTime createdAt;
  dynamic updatedBy;
  dynamic updatedAt;

  factory Productuom.fromJson(Map<String, dynamic> json) => Productuom(
        id: json["id"],
        companyId: json["company_id"],
        uomCode: json["uom_code"],
        uomName: json["uom_name"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "uom_code": uomCode,
        "uom_name": uomName,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_by": updatedBy,
        "updated_at": updatedAt,
      };
}
