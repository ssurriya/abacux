// To parse this JSON data, do
//
//     final proformaInvoiceEditUsingId = proformaInvoiceEditUsingIdFromJson(jsonString);

import 'dart:convert';

ProformaInvoiceEditUsingId proformaInvoiceEditUsingIdFromJson(String str) =>
    ProformaInvoiceEditUsingId.fromJson(json.decode(str));

String proformaInvoiceEditUsingIdToJson(ProformaInvoiceEditUsingId data) =>
    json.encode(data.toJson());

class ProformaInvoiceEditUsingId {
  ProformaInvoiceEditUsingId({
    this.status,
    this.message,
    this.proformainvoices,
    this.proformaInvoiceProducts,
    this.additionalCharges,
  });

  String status;
  String message;
  ProformaInvoices proformainvoices;
  List<ProformaProduct> proformaInvoiceProducts;
  List<AdditionalCharge> additionalCharges;

  factory ProformaInvoiceEditUsingId.fromJson(Map<String, dynamic> json) =>
      ProformaInvoiceEditUsingId(
        status: json["status"],
        message: json["message"],
        proformainvoices: ProformaInvoices.fromJson(json["proformainvoices"]),
        proformaInvoiceProducts: List<ProformaProduct>.from(
            json["proforma_products"].map((x) => ProformaProduct.fromJson(x))),
        additionalCharges: List<AdditionalCharge>.from(
            json["additional_charges"]
                .map((x) => AdditionalCharge.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "proformainvoices": proformainvoices.toJson(),
        "proforma_products":
            List<dynamic>.from(proformaInvoiceProducts.map((x) => x.toJson())),
        "additional_charges":
            List<dynamic>.from(additionalCharges.map((x) => x.toJson())),
      };
}

class AdditionalCharge {
  AdditionalCharge({
    this.id,
    this.proformaInvoiceId,
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
  int proformaInvoiceId;
  String additonalChargeName;
  String addtionalChargeAmount;
  String taxPercentage;
  String totalAmount;
  int isDeleted;
  int createdBy;
  String createdAt;
  dynamic updatedBy;
  dynamic updatedAt;

  factory AdditionalCharge.fromJson(Map<String, dynamic> json) =>
      AdditionalCharge(
        id: json["id"],
        proformaInvoiceId: json["proforma_invoice_id"],
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
        "proforma_invoice_id": proformaInvoiceId,
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

class ProformaProduct {
  ProformaProduct({
    this.pid,
    this.proformaInvoiceId,
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
  int proformaInvoiceId;
  int productId;
  int quantity;
  int uomId;
  String purchaseRate;
  String grossTotal;
  String taxInfo;
  String discountInPercentage;
  String discountInAmount;
  String grandTotal;

  factory ProformaProduct.fromJson(Map<String, dynamic> json) =>
      ProformaProduct(
        pid: json["pid"],
        proformaInvoiceId: json["proforma_invoice_id"],
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
        "proforma_invoice_id": proformaInvoiceId,
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

class ProformaInvoices {
  ProformaInvoices({
    this.id,
    this.companyId,
    this.customerId,
    this.invoiceNo,
    this.invoiceDate,
    this.taxInfo,
    this.grossTotal,
    this.grandTotal,
    this.discountInAmount,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.paymentDueDate,
    this.productSalesPriceTypeId,
    this.invoicePrefix,
    this.discountInPercentage,
  });

  int id;
  int companyId;
  int customerId;
  String invoiceNo;
  String invoiceDate;
  String taxInfo;
  String grossTotal;
  String grandTotal;
  String discountInAmount;
  int isDeleted;
  int createdBy;
  String createdAt;
  dynamic updatedBy;
  dynamic updatedAt;
  dynamic paymentDueDate;
  dynamic productSalesPriceTypeId;
  String invoicePrefix;
  String discountInPercentage;

  factory ProformaInvoices.fromJson(Map<String, dynamic> json) =>
      ProformaInvoices(
        id: json["id"],
        companyId: json["company_id"],
        customerId: json["customer_id"],
        invoiceNo: json["invoice_no"],
        invoiceDate: json["invoice_date"],
        taxInfo: json["tax_info"],
        grossTotal: json["gross_total"],
        grandTotal: json["grand_total"],
        discountInAmount: json["discount_in_amount"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        paymentDueDate: json["payment_due_date"],
        productSalesPriceTypeId: json["product_sales_price_type_id"],
        invoicePrefix: json["invoice_prefix"],
        discountInPercentage: json["discount_in_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "customer_id": customerId,
        "invoice_no": invoiceNo,
        "invoice_date": invoiceDate,
        "tax_info": taxInfo,
        "gross_total": grossTotal,
        "grand_total": grandTotal,
        "discount_in_amount": discountInAmount,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "payment_due_date": paymentDueDate,
        "product_sales_price_type_id": productSalesPriceTypeId,
        "invoice_prefix": invoicePrefix,
        "discount_in_percentage": discountInPercentage,
      };
}
