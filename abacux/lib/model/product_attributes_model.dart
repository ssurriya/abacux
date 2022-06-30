// To parse this JSON data, do
//
//     final productAttributes = productAttributesFromJson(jsonString);

import 'dart:convert';

ProductAttributes productAttributesFromJson(String str) =>
    ProductAttributes.fromJson(json.decode(str));

String productAttributesToJson(ProductAttributes data) =>
    json.encode(data.toJson());

class ProductAttributes {
  ProductAttributes({
    this.status,
    this.message,
    this.productAttributes,
  });

  String status;
  String message;
  List<ProductAttribute> productAttributes;

  factory ProductAttributes.fromJson(Map<String, dynamic> json) =>
      ProductAttributes(
        status: json["status"],
        message: json["message"],
        productAttributes: List<ProductAttribute>.from(
            json["product_attributes"]
                .map((x) => ProductAttribute.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "product_attributes":
            List<dynamic>.from(productAttributes.map((x) => x.toJson())),
      };
}

class ProductAttribute {
  ProductAttribute({
    this.id,
    this.companyId,
    this.attributeName,
    this.type,
    this.typeValue,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  int id;
  int companyId;
  String attributeName;
  String type;
  String typeValue;
  int isDeleted;
  int createdBy;
  DateTime createdAt;
  dynamic updatedBy;
  dynamic updatedAt;

  factory ProductAttribute.fromJson(Map<String, dynamic> json) =>
      ProductAttribute(
        id: json["id"],
        companyId: json["company_id"],
        attributeName: json["attribute_name"],
        type: json["type"],
        typeValue: json["type_value"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "attribute_name": attributeName,
        "type": type,
        "type_value": typeValue,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_by": updatedBy,
        "updated_at": updatedAt,
      };
}
