// To parse this JSON data, do
//
//     final estimateSettingList = estimateSettingListFromJson(jsonString);

import 'dart:convert';

EstimateSettingList estimateSettingListFromJson(String str) =>
    EstimateSettingList.fromJson(json.decode(str));

String estimateSettingListToJson(EstimateSettingList data) =>
    json.encode(data.toJson());

class EstimateSettingList {
  EstimateSettingList({
    this.status,
    this.message,
    this.estimateSettings,
  });

  String status;
  String message;
  List<EstimateSetting> estimateSettings;

  factory EstimateSettingList.fromJson(Map<String, dynamic> json) =>
      EstimateSettingList(
        status: json["status"],
        message: json["message"],
        estimateSettings: List<EstimateSetting>.from(
            json["estimate_settings"].map((x) => EstimateSetting.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "estimate_settings":
            List<dynamic>.from(estimateSettings.map((x) => x.toJson())),
      };
}

class EstimateSetting {
  EstimateSetting({
    this.id,
    this.companyId,
    this.prefix,
    this.estimateStartNumber,
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
  int estimateStartNumber;
  int status;
  int isDeleted;
  int createdBy;
  DateTime createdAt;
  dynamic updatedBy;
  dynamic updatedAt;

  factory EstimateSetting.fromJson(Map<String, dynamic> json) =>
      EstimateSetting(
        id: json["id"],
        companyId: json["company_id"],
        prefix: json["prefix"],
        estimateStartNumber: json["estimate_start_number"],
        status: json["status"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "prefix": prefix,
        "estimate_start_number": estimateStartNumber,
        "status": status,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_by": updatedBy,
        "updated_at": updatedAt,
      };
}
