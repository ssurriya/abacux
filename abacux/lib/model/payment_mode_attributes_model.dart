// To parse this JSON data, do
//
//     final paymentModeAttributes = paymentModeAttributesFromJson(jsonString);

import 'dart:convert';

PaymentModeAttributes paymentModeAttributesFromJson(String str) =>
    PaymentModeAttributes.fromJson(json.decode(str));

String paymentModeAttributesToJson(PaymentModeAttributes data) =>
    json.encode(data.toJson());

class PaymentModeAttributes {
  PaymentModeAttributes({
    this.status,
    this.message,
    this.paymentModeAttributes,
  });

  String status;
  String message;
  List<PaymentModeAttribute> paymentModeAttributes;

  factory PaymentModeAttributes.fromJson(Map<String, dynamic> json) =>
      PaymentModeAttributes(
        status: json["status"],
        message: json["message"],
        paymentModeAttributes: List<PaymentModeAttribute>.from(
            json["payment_mode_attributes"]
                .map((x) => PaymentModeAttribute.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "payment_mode_attributes":
            List<dynamic>.from(paymentModeAttributes.map((x) => x.toJson())),
      };
}

class PaymentModeAttribute {
  PaymentModeAttribute({
    this.id,
    this.companyId,
    this.paymentModeId,
    this.paymentModeAttributeName,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.paymentMode,
  });

  int id;
  int companyId;
  int paymentModeId;
  String paymentModeAttributeName;
  int isDeleted;
  int createdBy;
  String createdAt;
  int updatedBy;
  String updatedAt;
  String paymentMode;

  factory PaymentModeAttribute.fromJson(Map<String, dynamic> json) =>
      PaymentModeAttribute(
        id: json["id"],
        companyId: json["company_id"],
        paymentModeId: json["payment_mode_id"],
        paymentModeAttributeName: json["payment_mode_attribute_name"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        paymentMode: json["payment_mode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "payment_mode_id": paymentModeId,
        "payment_mode_attribute_name": paymentModeAttributeName,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy == null ? null : updatedBy,
        "updated_at": updatedAt == null ? null : updatedAt,
        "payment_mode": paymentMode,
      };
}
