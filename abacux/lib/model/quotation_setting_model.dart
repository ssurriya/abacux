// To parse this JSON data, do
//
//     final quotationSettingList = quotationSettingListFromJson(jsonString);

import 'dart:convert';

QuotationSettingList quotationSettingListFromJson(String str) =>
    QuotationSettingList.fromJson(json.decode(str));

String quotationSettingListToJson(QuotationSettingList data) =>
    json.encode(data.toJson());

class QuotationSettingList {
  QuotationSettingList({
    this.status,
    this.message,
    this.quotationSettings,
  });

  String status;
  String message;
  List<QuotationSetting> quotationSettings;

  factory QuotationSettingList.fromJson(Map<String, dynamic> json) =>
      QuotationSettingList(
        status: json["status"],
        message: json["message"],
        quotationSettings: List<QuotationSetting>.from(
            json["quotation_settings"]
                .map((x) => QuotationSetting.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "quotation_settings":
            List<dynamic>.from(quotationSettings.map((x) => x.toJson())),
      };
}

class QuotationSetting {
  QuotationSetting({
    this.id,
    this.companyId,
    this.prefix,
    this.quotationStartNumber,
    this.status,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  int id;
  int companyId;
  String prefix;
  int quotationStartNumber;
  int status;
  int isDeleted;
  int createdBy;
  DateTime createdAt;
  int updatedBy;
  DateTime updatedAt;

  factory QuotationSetting.fromJson(Map<String, dynamic> json) =>
      QuotationSetting(
        id: json["id"],
        companyId: json["company_id"],
        prefix: json["prefix"],
        quotationStartNumber: json["quotation_start_number"],
        status: json["status"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "prefix": prefix,
        "quotation_start_number": quotationStartNumber,
        "status": status,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_by": updatedBy,
        "updated_at": updatedAt.toIso8601String(),
      };
}
