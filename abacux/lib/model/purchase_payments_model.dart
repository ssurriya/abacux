// To parse this JSON data, do
//
//     final purchasePayments = purchasePaymentsFromJson(jsonString);

import 'dart:convert';

PurchasePayments purchasePaymentsFromJson(String str) =>
    PurchasePayments.fromJson(json.decode(str));

String purchasePaymentsToJson(PurchasePayments data) =>
    json.encode(data.toJson());

class PurchasePayments {
  PurchasePayments({
    this.status,
    this.message,
    this.purchaseInvoicesList,
  });

  String status;
  String message;
  List<PurchaseInvoicesList> purchaseInvoicesList;

  factory PurchasePayments.fromJson(Map<String, dynamic> json) =>
      PurchasePayments(
        status: json["status"],
        message: json["message"],
        purchaseInvoicesList: List<PurchaseInvoicesList>.from(
            json["purchase_invoices_list"]
                .map((x) => PurchaseInvoicesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "purchase_invoices_list":
            List<dynamic>.from(purchaseInvoicesList.map((x) => x.toJson())),
      };
}

class PurchaseInvoicesList {
  PurchaseInvoicesList({
    this.id,
    this.invoiceNo,
    this.invoiceDate,
    this.vendorName,
    this.paymentDueDate,
    this.paidStatus,
    this.grandTotal,
    this.grossTotal,
    this.taxInfo,
    this.totalpaid,
  });

  int id;
  String invoiceNo;
  DateTime invoiceDate;
  String vendorName;
  DateTime paymentDueDate;
  int paidStatus;
  String grandTotal;
  String grossTotal;
  String taxInfo;
  String totalpaid;

  factory PurchaseInvoicesList.fromJson(Map<String, dynamic> json) =>
      PurchaseInvoicesList(
        id: json["id"],
        invoiceNo: json["invoice_no"],
        invoiceDate: DateTime.parse(json["invoice_date"]),
        vendorName: json["vendor_name"],
        paymentDueDate: json["payment_due_date"] != null
            ? DateTime.parse(json["payment_due_date"])
            : null,
        paidStatus: json["paid_status"],
        grandTotal: json["grand_total"],
        grossTotal: json["gross_total"],
        taxInfo: json["tax_info"],
        totalpaid: json["totalpaid"] == null ? null : json["totalpaid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_no": invoiceNo,
        "invoice_date":
            "${invoiceDate.year.toString().padLeft(4, '0')}-${invoiceDate.month.toString().padLeft(2, '0')}-${invoiceDate.day.toString().padLeft(2, '0')}",
        "vendor_name": vendorName,
        "payment_due_date":
            "${paymentDueDate.year.toString().padLeft(4, '0')}-${paymentDueDate.month.toString().padLeft(2, '0')}-${paymentDueDate.day.toString().padLeft(2, '0')}",
        "paid_status": paidStatus,
        "grand_total": grandTotal,
        "gross_total": grossTotal,
        "tax_info": taxInfo,
        "totalpaid": totalpaid == null ? null : totalpaid,
      };
}
