// To parse this JSON data, do
//
//     final orders = ordersFromJson(jsonString);

import 'dart:convert';

Orders ordersFromJson(String str) => Orders.fromJson(json.decode(str));

String ordersToJson(Orders data) => json.encode(data.toJson());

class Orders {
  Orders({
    this.id,
    this.companyId,
    this.vendorId,
    this.poNo,
    this.poDate,
    this.grossTotal,
    this.grandTotal,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.discountInPercentage,
    this.discountInAmount,
    this.taxInfo,
    this.invoicePrefix,
  });

  int id;
  int companyId;
  int vendorId;
  String poNo;
  DateTime poDate;
  String grossTotal;
  String grandTotal;
  int isDeleted;
  int createdBy;
  String createdAt;
  dynamic updatedBy;
  dynamic updatedAt;
  String discountInPercentage;
  String discountInAmount;
  String taxInfo;
  String invoicePrefix;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        id: json["id"],
        companyId: json["company_id"],
        vendorId: json["vendor_id"],
        poNo: json["po_no"],
        poDate: DateTime.parse(json["po_date"]),
        grossTotal: json["gross_total"],
        grandTotal: json["grand_total"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        discountInPercentage: json["discount_in_percentage"],
        discountInAmount: json["discount_in_amount"],
        taxInfo: json["tax_info"],
        invoicePrefix: json["invoice_prefix"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "vendor_id": vendorId,
        "po_no": poNo,
        "po_date":
            "${poDate.year.toString().padLeft(4, '0')}-${poDate.month.toString().padLeft(2, '0')}-${poDate.day.toString().padLeft(2, '0')}",
        "gross_total": grossTotal,
        "grand_total": grandTotal,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "discount_in_percentage": discountInPercentage,
        "discount_in_amount": discountInAmount,
        "tax_info": taxInfo,
        "invoice_prefix": invoicePrefix,
      };
}
