// To parse this JSON data, do
//
//     final purchaseOrderProduct = purchaseOrderProductFromJson(jsonString);

import 'dart:convert';

PurchaseOrderProduct purchaseOrderProductFromJson(String str) =>
    PurchaseOrderProduct.fromJson(json.decode(str));

String purchaseOrderProductToJson(PurchaseOrderProduct data) =>
    json.encode(data.toJson());

class PurchaseOrderProduct {
  PurchaseOrderProduct({
    this.id,
    this.vendorId,
    this.poNo,
    this.invoicePrefix,
    this.poDate,
    this.grossTotal,
    this.grandTotal,
    this.taxInfo,
    this.discountInAmount,
    this.pid,
    this.purchaseOrderId,
    this.productId,
    this.quantity,
    this.uomId,
    this.purchaseRate,
    this.pgrossTotal,
    this.pgrandTotal,
    this.ptaxInfo,
    this.pdiscount,
    this.basicRate,
    this.pdiscountAmount,
    this.discountInPercentage,
  });

  int id;
  int vendorId;
  String poNo;
  String invoicePrefix;
  DateTime poDate;
  String grossTotal;
  String grandTotal;
  String taxInfo;
  String discountInAmount;
  int pid;
  int purchaseOrderId;
  int productId;
  int quantity;
  int uomId;
  String purchaseRate;
  String pgrossTotal;
  String pgrandTotal;
  String ptaxInfo;
  String pdiscount;
  String basicRate;
  String pdiscountAmount;
  String discountInPercentage;

  factory PurchaseOrderProduct.fromJson(Map<String, dynamic> json) =>
      PurchaseOrderProduct(
        id: json["id"],
        vendorId: json["vendor_id"],
        poNo: json["po_no"],
        invoicePrefix: json["invoice_prefix"],
        poDate: DateTime.parse(json["po_date"]),
        grossTotal: json["gross_total"],
        grandTotal: json["grand_total"],
        taxInfo: json["tax_info"],
        discountInAmount: json["discount_in_amount"],
        pid: json["pid"],
        purchaseOrderId: json["purchase_order_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        uomId: json["uom_id"],
        purchaseRate: json["purchase_rate"],
        pgrossTotal: json["pgross_total"],
        pgrandTotal: json["pgrand_total"],
        ptaxInfo: json["ptax_info"],
        pdiscount: json["pdiscount"],
        basicRate: json["basic_rate"],
        pdiscountAmount: json["pdiscount_amount"],
        discountInPercentage: json["discount_in_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendor_id": vendorId,
        "po_no": poNo,
        "invoice_prefix": invoicePrefix,
        "po_date":
            "${poDate.year.toString().padLeft(4, '0')}-${poDate.month.toString().padLeft(2, '0')}-${poDate.day.toString().padLeft(2, '0')}",
        "gross_total": grossTotal,
        "grand_total": grandTotal,
        "tax_info": taxInfo,
        "discount_in_amount": discountInAmount,
        "pid": pid,
        "purchase_order_id": purchaseOrderId,
        "product_id": productId,
        "quantity": quantity,
        "uom_id": uomId,
        "purchase_rate": purchaseRate,
        "pgross_total": pgrossTotal,
        "pgrand_total": pgrandTotal,
        "ptax_info": ptaxInfo,
        "pdiscount": pdiscount,
        "basic_rate": basicRate,
        "pdiscount_amount": pdiscountAmount,
        "discount_in_percentage": discountInPercentage,
      };
}
