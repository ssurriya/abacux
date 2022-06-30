// To parse this JSON data, do
//
//     final purchaseOrder = purchaseOrderFromJson(jsonString);

import 'dart:convert';

PurchaseOrder purchaseOrderFromJson(String str) =>
    PurchaseOrder.fromJson(json.decode(str));

String purchaseOrderToJson(PurchaseOrder data) => json.encode(data.toJson());

class PurchaseOrder {
  PurchaseOrder({
    this.id,
    this.poNo,
    this.poDate,
    this.vendorName,
    this.grossTotal,
    this.grandTotal,
    this.invoicePrefix,
  });

  int id;
  String poNo;
  DateTime poDate;
  String vendorName;
  String grossTotal;
  String grandTotal;
  String invoicePrefix;

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) => PurchaseOrder(
        id: json["id"],
        poNo: json["po_no"],
        poDate: DateTime.parse(json["po_date"]),
        vendorName: json["vendor_name"],
        grossTotal: json["gross_total"],
        grandTotal: json["grand_total"],
        invoicePrefix: json["invoice_prefix"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "po_no": poNo,
        "po_date":
            "${poDate.year.toString().padLeft(4, '0')}-${poDate.month.toString().padLeft(2, '0')}-${poDate.day.toString().padLeft(2, '0')}",
        "vendor_name": vendorName,
        "gross_total": grossTotal,
        "grand_total": grandTotal,
        "invoice_prefix": invoicePrefix,
      };
}
