// To parse this JSON data, do
//
//     final paymentmode = paymentmodeFromJson(jsonString);

import 'dart:convert';

Paymentmode paymentmodeFromJson(String str) =>
    Paymentmode.fromJson(json.decode(str));

String paymentmodeToJson(Paymentmode data) => json.encode(data.toJson());

class Paymentmode {
  Paymentmode({
    this.status,
    this.message,
    this.paymentmodeList,
  });

  String status;
  String message;
  List<PaymentmodeList> paymentmodeList;

  factory Paymentmode.fromJson(Map<String, dynamic> json) => Paymentmode(
        status: json["status"],
        message: json["message"],
        paymentmodeList: List<PaymentmodeList>.from(
            json["paymentmode_list"].map((x) => PaymentmodeList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "paymentmode_list":
            List<dynamic>.from(paymentmodeList.map((x) => x.toJson())),
      };
}

class PaymentmodeList {
  PaymentmodeList({
    this.id,
    this.companyId,
    this.paymentMode,
    this.attributeStatus,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  int id;
  int companyId;
  String paymentMode;
  int attributeStatus;
  int isDeleted;
  int createdBy;
  DateTime createdAt;
  int updatedBy;
  DateTime updatedAt;

  factory PaymentmodeList.fromJson(Map<String, dynamic> json) =>
      PaymentmodeList(
        id: json["id"],
        companyId: json["company_id"],
        paymentMode: json["payment_mode"],
        attributeStatus: json["attribute_status"],
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
        "payment_mode": paymentMode,
        "attribute_status": attributeStatus,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_by": updatedBy == null ? null : updatedBy,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
