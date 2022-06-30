// To parse this JSON data, do
//
//     final purchaseOrderEditUsingId = purchaseOrderEditUsingIdFromJson(jsonString);

import 'dart:convert';

PurchaseOrderEditUsingId purchaseOrderEditUsingIdFromJson(String str) =>
    PurchaseOrderEditUsingId.fromJson(json.decode(str));

String purchaseOrderEditUsingIdToJson(PurchaseOrderEditUsingId data) =>
    json.encode(data.toJson());

class PurchaseOrderEditUsingId {
  PurchaseOrderEditUsingId({
    this.status,
    this.message,
    this.purchaseOrders,
    this.purchaseOrderProducts,
    this.additionalCharges,
  });

  String status;
  String message;
  PurchaseOrders purchaseOrders;
  List<PurchaseOrderProduct> purchaseOrderProducts;
  List<AdditionalCharge> additionalCharges;

  factory PurchaseOrderEditUsingId.fromJson(Map<String, dynamic> json) =>
      PurchaseOrderEditUsingId(
        status: json["status"],
        message: json["message"],
        purchaseOrders: PurchaseOrders.fromJson(json["purchase_orders"]),
        purchaseOrderProducts: List<PurchaseOrderProduct>.from(
            json["purchase_order_products"]
                .map((x) => PurchaseOrderProduct.fromJson(x))),
        additionalCharges: List<AdditionalCharge>.from(
            json["additional_charges"]
                .map((x) => AdditionalCharge.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "purchase_orders": purchaseOrders.toJson(),
        "purchase_order_products":
            List<dynamic>.from(purchaseOrderProducts.map((x) => x.toJson())),
        "additional_charges":
            List<dynamic>.from(additionalCharges.map((x) => x.toJson())),
      };
}

class AdditionalCharge {
  AdditionalCharge({
    this.id,
    this.purchaseOrderId,
    this.additonalChargeName,
    this.addtionalChargeAmount,
    this.taxPercentage,
    this.totalAmount,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  int id;
  int purchaseOrderId;
  String additonalChargeName;
  String addtionalChargeAmount;
  String taxPercentage;
  String totalAmount;
  int isDeleted;
  int createdBy;
  String createdAt;
  int updatedBy;
  String updatedAt;

  factory AdditionalCharge.fromJson(Map<String, dynamic> json) =>
      AdditionalCharge(
        id: json["id"],
        purchaseOrderId: json["purchase_order_id"],
        additonalChargeName: json["additonal_charge_name"],
        addtionalChargeAmount: json["addtional_charge_amount"],
        taxPercentage: json["tax_percentage"],
        totalAmount: json["total_amount"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "purchase_order_id": purchaseOrderId,
        "additonal_charge_name": additonalChargeName,
        "addtional_charge_amount": addtionalChargeAmount,
        "tax_percentage": taxPercentage,
        "total_amount": totalAmount,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
      };
}

class PurchaseOrderProduct {
  PurchaseOrderProduct({
    this.pid,
    this.purchaseOrderId,
    this.productId,
    this.quantity,
    this.uomId,
    this.purchaseRate,
    this.grossTotal,
    this.taxInfo,
    this.discountInPercentage,
    this.discountInAmount,
    this.grandTotal,
  });

  int pid;
  int purchaseOrderId;
  int productId;
  int quantity;
  int uomId;
  String purchaseRate;
  String grossTotal;
  String taxInfo;
  String discountInPercentage;
  String discountInAmount;
  String grandTotal;

  factory PurchaseOrderProduct.fromJson(Map<String, dynamic> json) =>
      PurchaseOrderProduct(
        pid: json["pid"],
        purchaseOrderId: json["purchase_order_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        uomId: json["uom_id"],
        purchaseRate: json["purchase_rate"],
        grossTotal: json["gross_total"],
        taxInfo: json["tax_info"],
        discountInPercentage: json["discount_in_percentage"],
        discountInAmount: json["discount_in_amount"],
        grandTotal: json["grand_total"],
      );

  Map<String, dynamic> toJson() => {
        "pid": pid,
        "purchase_order_id": purchaseOrderId,
        "product_id": productId,
        "quantity": quantity,
        "uom_id": uomId,
        "purchase_rate": purchaseRate,
        "gross_total": grossTotal,
        "tax_info": taxInfo,
        "discount_in_percentage": discountInPercentage,
        "discount_in_amount": discountInAmount,
        "grand_total": grandTotal,
      };
}

class PurchaseOrders {
  PurchaseOrders({
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
  String poDate;
  String grossTotal;
  String grandTotal;
  int isDeleted;
  int createdBy;
  String createdAt;
  int updatedBy;
  String updatedAt;
  String discountInPercentage;
  String discountInAmount;
  String taxInfo;
  String invoicePrefix;

  factory PurchaseOrders.fromJson(Map<String, dynamic> json) => PurchaseOrders(
        id: json["id"],
        companyId: json["company_id"],
        vendorId: json["vendor_id"],
        poNo: json["po_no"],
        poDate: json["po_date"],
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
        "po_date": poDate,
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
