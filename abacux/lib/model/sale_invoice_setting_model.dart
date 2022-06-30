// To parse this JSON data, do
//
//     final saleInvoiceSettingList = saleInvoiceSettingListFromJson(jsonString);

import 'dart:convert';

SaleInvoiceSettingList saleInvoiceSettingListFromJson(String str) =>
    SaleInvoiceSettingList.fromJson(json.decode(str));

String saleInvoiceSettingListToJson(SaleInvoiceSettingList data) =>
    json.encode(data.toJson());

class SaleInvoiceSettingList {
  SaleInvoiceSettingList({
    this.status,
    this.message,
    this.salesinvoiceSettings,
  });

  String status;
  String message;
  List<SalesinvoiceSetting> salesinvoiceSettings;

  factory SaleInvoiceSettingList.fromJson(Map<String, dynamic> json) =>
      SaleInvoiceSettingList(
        status: json["status"],
        message: json["message"],
        salesinvoiceSettings: List<SalesinvoiceSetting>.from(
            json["salesinvoiceSettings"]
                .map((x) => SalesinvoiceSetting.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "salesinvoiceSettings":
            List<dynamic>.from(salesinvoiceSettings.map((x) => x.toJson())),
      };
}

class SalesinvoiceSetting {
  SalesinvoiceSetting({
    this.id,
    this.companyId,
    this.prefix,
    this.salesInvoiceStartNumber,
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
  String salesInvoiceStartNumber;
  int status;
  int isDeleted;
  int createdBy;
  String createdAt;
  int updatedBy;
  String updatedAt;

  factory SalesinvoiceSetting.fromJson(Map<String, dynamic> json) =>
      SalesinvoiceSetting(
        id: json["id"],
        companyId: json["company_id"],
        prefix: json["prefix"],
        salesInvoiceStartNumber: json["sales_invoice_start_number"],
        status: json["status"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "prefix": prefix,
        "sales_invoice_start_number": salesInvoiceStartNumber,
        "status": status,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy == null ? null : updatedBy,
        "updated_at": updatedAt == null ? null : updatedAt,
      };
}
