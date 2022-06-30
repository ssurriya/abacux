// To parse this JSON data, do
//
//     final proformaInvoiceList = proformaInvoiceListFromJson(jsonString);

import 'dart:convert';

ProformaInvoiceList proformaInvoiceListFromJson(String str) =>
    ProformaInvoiceList.fromJson(json.decode(str));

String proformaInvoiceListToJson(ProformaInvoiceList data) =>
    json.encode(data.toJson());

class ProformaInvoiceList {
  ProformaInvoiceList({
    this.id,
    this.invoiceNo,
    this.invoiceDate,
    this.customerName,
    this.paymentDueDate,
    this.taxInfo,
    this.grossTotal,
    this.grandTotal,
    this.invoicePrefix,
  });

  int id;
  String invoiceNo;
  DateTime invoiceDate;
  String customerName;
  dynamic paymentDueDate;
  String taxInfo;
  String grossTotal;
  String grandTotal;
  String invoicePrefix;

  factory ProformaInvoiceList.fromJson(Map<String, dynamic> json) =>
      ProformaInvoiceList(
        id: json["id"],
        invoiceNo: json["invoice_no"],
        invoiceDate: DateTime.parse(json["invoice_date"]),
        customerName: json["customer_name"],
        paymentDueDate: json["payment_due_date"],
        taxInfo: json["tax_info"],
        grossTotal: json["gross_total"],
        grandTotal: json["grand_total"],
        invoicePrefix: json["invoice_prefix"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_no": invoiceNo,
        "invoice_date":
            "${invoiceDate.year.toString().padLeft(4, '0')}-${invoiceDate.month.toString().padLeft(2, '0')}-${invoiceDate.day.toString().padLeft(2, '0')}",
        "customer_name": customerName,
        "payment_due_date": paymentDueDate,
        "tax_info": taxInfo,
        "gross_total": grossTotal,
        "grand_total": grandTotal,
        "invoice_prefix": invoicePrefix,
      };
}
