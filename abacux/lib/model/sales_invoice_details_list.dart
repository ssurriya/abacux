// To parse this JSON data, do
//
//     final salesInvoiceDetails = salesInvoiceDetailsFromJson(jsonString);

import 'dart:convert';

SalesInvoiceDetails salesInvoiceDetailsFromJson(String str) =>
    SalesInvoiceDetails.fromJson(json.decode(str));

String salesInvoiceDetailsToJson(SalesInvoiceDetails data) =>
    json.encode(data.toJson());

class SalesInvoiceDetails {
  SalesInvoiceDetails({
    this.status,
    this.message,
    this.saleInvoiceDetailsList,
    this.salesInvoiceProducts,
  });

  String status;
  String message;
  List<SaleInvoiceDetailsList> saleInvoiceDetailsList;
  List<SalesInvoiceProduct> salesInvoiceProducts;

  factory SalesInvoiceDetails.fromJson(Map<String, dynamic> json) =>
      SalesInvoiceDetails(
        status: json["status"],
        message: json["message"],
        saleInvoiceDetailsList: List<SaleInvoiceDetailsList>.from(
            json["sale_invoice_details_list"]
                .map((x) => SaleInvoiceDetailsList.fromJson(x))),
        salesInvoiceProducts: List<SalesInvoiceProduct>.from(
            json["sales_invoice_products"]
                .map((x) => SalesInvoiceProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "sale_invoice_details_list":
            List<dynamic>.from(saleInvoiceDetailsList.map((x) => x.toJson())),
        "sales_invoice_products":
            List<dynamic>.from(salesInvoiceProducts.map((x) => x.toJson())),
      };
}

class SaleInvoiceDetailsList {
  SaleInvoiceDetailsList({
    this.salesId,
    this.customerId,
    this.customerName,
    this.invoiceNo,
    this.invoiceDate,
    this.paymentDueDate,
    this.taxInfo,
    this.grossTotal,
    this.grandTotal,
    this.discountInAmount,
    this.discountInPercentage,
    this.subCustomerId,
    this.messageOnInvoice,
    this.emailId,
    this.billingAddress,
    this.productId,
    this.productName,
    this.quantity,
    this.uomId,
    this.ptaxInfo,
    this.pgrossTotal,
    this.pgrandTotal,
    this.pdiscountPercent,
    this.pdiscountAmount,
  });

  int salesId;
  int customerId;
  String customerName;
  String invoiceNo;
  DateTime invoiceDate;
  DateTime paymentDueDate;
  String taxInfo;
  String grossTotal;
  String grandTotal;
  String discountInAmount;
  String discountInPercentage;
  int subCustomerId;
  dynamic messageOnInvoice;
  String emailId;
  String billingAddress;
  int productId;
  String productName;
  int quantity;
  int uomId;
  String ptaxInfo;
  String pgrossTotal;
  String pgrandTotal;
  String pdiscountPercent;
  String pdiscountAmount;

  factory SaleInvoiceDetailsList.fromJson(Map<String, dynamic> json) =>
      SaleInvoiceDetailsList(
        salesId: json["sales_id"],
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        invoiceNo: json["invoice_no"],
        invoiceDate: DateTime.parse(json["invoice_date"]),
        paymentDueDate: DateTime.parse(json["payment_due_date"]),
        taxInfo: json["tax_info"],
        grossTotal: json["gross_total"],
        grandTotal: json["grand_total"],
        discountInAmount: json["discount_in_amount"],
        discountInPercentage: json["discount_in_percentage"],
        subCustomerId: json["sub_customer_id"],
        messageOnInvoice: json["message_on_invoice"],
        emailId: json["email_id"],
        billingAddress: json["billing_address"],
        productId: json["product_id"],
        productName: json["product_name"],
        quantity: json["quantity"],
        uomId: json["uom_id"],
        ptaxInfo: json["ptax_info"],
        pgrossTotal: json["pgross_total"],
        pgrandTotal: json["pgrand_total"],
        pdiscountPercent: json["pdiscount_percent"],
        pdiscountAmount: json["pdiscount_amount"],
      );

  Map<String, dynamic> toJson() => {
        "sales_id": salesId,
        "customer_id": customerId,
        "customer_name": customerName,
        "invoice_no": invoiceNo,
        "invoice_date":
            "${invoiceDate.year.toString().padLeft(4, '0')}-${invoiceDate.month.toString().padLeft(2, '0')}-${invoiceDate.day.toString().padLeft(2, '0')}",
        "payment_due_date":
            "${paymentDueDate.year.toString().padLeft(4, '0')}-${paymentDueDate.month.toString().padLeft(2, '0')}-${paymentDueDate.day.toString().padLeft(2, '0')}",
        "tax_info": taxInfo,
        "gross_total": grossTotal,
        "grand_total": grandTotal,
        "discount_in_amount": discountInAmount,
        "discount_in_percentage": discountInPercentage,
        "sub_customer_id": subCustomerId,
        "message_on_invoice": messageOnInvoice,
        "email_id": emailId,
        "billing_address": billingAddress,
        "product_id": productId,
        "product_name": productName,
        "quantity": quantity,
        "uom_id": uomId,
        "ptax_info": ptaxInfo,
        "pgross_total": pgrossTotal,
        "pgrand_total": pgrandTotal,
        "pdiscount_percent": pdiscountPercent,
        "pdiscount_amount": pdiscountAmount,
      };
}

class SalesInvoiceProduct {
  SalesInvoiceProduct({
    this.productId,
    this.productName,
    this.quantity,
    this.uomId,
    this.ptaxInfo,
    this.pgrossTotal,
    this.pgrandTotal,
    this.pdiscountPercent,
    this.pdiscountAmount,
  });

  int productId;
  String productName;
  int quantity;
  int uomId;
  String ptaxInfo;
  String pgrossTotal;
  String pgrandTotal;
  String pdiscountPercent;
  String pdiscountAmount;

  factory SalesInvoiceProduct.fromJson(Map<String, dynamic> json) =>
      SalesInvoiceProduct(
        productId: json["product_id"],
        productName: json["product_name"],
        quantity: json["quantity"],
        uomId: json["uom_id"],
        ptaxInfo: json["ptax_info"],
        pgrossTotal: json["pgross_total"],
        pgrandTotal: json["pgrand_total"],
        pdiscountPercent: json["pdiscount_percent"],
        pdiscountAmount: json["pdiscount_amount"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "quantity": quantity,
        "uom_id": uomId,
        "ptax_info": ptaxInfo,
        "pgross_total": pgrossTotal,
        "pgrand_total": pgrandTotal,
        "pdiscount_percent": pdiscountPercent,
        "pdiscount_amount": pdiscountAmount,
      };
}
