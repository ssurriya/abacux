// To parse this JSON data, do
//
//     final additionalCharge = additionalChargeFromJson(jsonString);

import 'dart:convert';

AdditionalCharge additionalChargeFromJson(String str) =>
    AdditionalCharge.fromJson(json.decode(str));

String additionalChargeToJson(AdditionalCharge data) =>
    json.encode(data.toJson());

class AdditionalCharge {
  AdditionalCharge({
    this.status,
    this.message,
    this.masteradditioncharge,
  });

  String status;
  String message;
  List<Masteradditioncharge> masteradditioncharge;

  factory AdditionalCharge.fromJson(Map<String, dynamic> json) =>
      AdditionalCharge(
        status: json["status"],
        message: json["message"],
        masteradditioncharge: List<Masteradditioncharge>.from(
            json["masteradditioncharge"]
                .map((x) => Masteradditioncharge.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "masteradditioncharge":
            List<dynamic>.from(masteradditioncharge.map((x) => x.toJson())),
      };
}

class Masteradditioncharge {
  Masteradditioncharge({
    this.id,
    this.companyId,
    this.additionalChargeName,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.accountId,
    this.accountName,
  });

  int id;
  int companyId;
  String additionalChargeName;
  int isDeleted;
  int createdBy;
  String createdAt;
  dynamic updatedBy;
  dynamic updatedAt;
  int accountId;
  String accountName;

  factory Masteradditioncharge.fromJson(Map<String, dynamic> json) =>
      Masteradditioncharge(
        id: json["id"],
        companyId: json["company_id"],
        additionalChargeName: json["additional_charge_name"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        accountId: json["account_id"],
        accountName: json["account_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "additional_charge_name": additionalChargeName,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "account_id": accountId,
        "account_name": accountName,
      };
}
