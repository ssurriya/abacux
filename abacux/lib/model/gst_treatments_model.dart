// To parse this JSON data, do
//
//     final gstTreatments = gstTreatmentsFromJson(jsonString);

import 'dart:convert';

GstTreatments gstTreatmentsFromJson(String str) =>
    GstTreatments.fromJson(json.decode(str));

String gstTreatmentsToJson(GstTreatments data) => json.encode(data.toJson());

class GstTreatments {
  GstTreatments({
    this.status,
    this.message,
    this.accountHolderTypes,
  });

  String status;
  String message;
  List<AccountHolderType> accountHolderTypes;

  factory GstTreatments.fromJson(Map<String, dynamic> json) => GstTreatments(
        status: json["status"],
        message: json["message"],
        accountHolderTypes: List<AccountHolderType>.from(
            json["account_holder_types"]
                .map((x) => AccountHolderType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "account_holder_types":
            List<dynamic>.from(accountHolderTypes.map((x) => x.toJson())),
      };
}

class AccountHolderType {
  AccountHolderType({
    this.id,
    this.gstTreatmentName,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  int id;
  String gstTreatmentName;
  int isDeleted;
  dynamic createdBy;
  dynamic createdAt;
  dynamic updatedBy;
  dynamic updatedAt;

  factory AccountHolderType.fromJson(Map<String, dynamic> json) =>
      AccountHolderType(
        id: json["id"],
        gstTreatmentName: json["gst_treatment_name"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gst_treatment_name": gstTreatmentName,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
      };
}
