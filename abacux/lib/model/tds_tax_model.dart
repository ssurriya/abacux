// To parse this JSON data, do
//
//     final tdsTax = tdsTaxFromJson(jsonString);

import 'dart:convert';

TdsTax tdsTaxFromJson(String str) => TdsTax.fromJson(json.decode(str));

String tdsTaxToJson(TdsTax data) => json.encode(data.toJson());

class TdsTax {
  TdsTax({
    this.status,
    this.message,
    this.tdsTax,
  });

  String status;
  String message;
  List<TdsTaxElement> tdsTax;

  factory TdsTax.fromJson(Map<String, dynamic> json) => TdsTax(
        status: json["status"],
        message: json["message"],
        tdsTax: List<TdsTaxElement>.from(
            json["tds_tax"].map((x) => TdsTaxElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "tds_tax": List<dynamic>.from(tdsTax.map((x) => x.toJson())),
      };
}

class TdsTaxElement {
  TdsTaxElement({
    this.id,
    this.tdsTaxTypeId,
    this.taxPercentage,
    this.taxName,
    this.tdsPayableAccount,
    this.tdsReceivableAccount,
    this.higherTdsRate,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.companyId,
    this.higherTdsStatus,
  });

  int id;
  int tdsTaxTypeId;
  String taxPercentage;
  String taxName;
  int tdsPayableAccount;
  int tdsReceivableAccount;
  dynamic higherTdsRate;
  int isDeleted;
  int createdBy;
  String createdAt;
  dynamic updatedBy;
  dynamic updatedAt;
  int companyId;
  int higherTdsStatus;

  factory TdsTaxElement.fromJson(Map<String, dynamic> json) => TdsTaxElement(
        id: json["id"],
        tdsTaxTypeId: json["tds_tax_type_id"],
        taxPercentage: json["tax_percentage"],
        taxName: json["tax_name"],
        tdsPayableAccount: json["tds_payable_account"] == null
            ? null
            : json["tds_payable_account"],
        tdsReceivableAccount: json["tds_receivable_account"] == null
            ? null
            : json["tds_receivable_account"],
        higherTdsRate: json["higher_tds_rate"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        companyId: json["company_id"],
        higherTdsStatus: json["higher_tds_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tds_tax_type_id": tdsTaxTypeId,
        "tax_percentage": taxPercentage,
        "tax_name": taxName,
        "tds_payable_account":
            tdsPayableAccount == null ? null : tdsPayableAccount,
        "tds_receivable_account":
            tdsReceivableAccount == null ? null : tdsReceivableAccount,
        "higher_tds_rate": higherTdsRate,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "company_id": companyId,
        "higher_tds_status": higherTdsStatus,
      };
}
