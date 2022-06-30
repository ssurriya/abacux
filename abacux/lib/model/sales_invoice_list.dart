// To parse this JSON data, do
//
//     final salesInvoices = salesInvoicesFromJson(jsonString);

import 'dart:convert';

SalesInvoices salesInvoicesFromJson(String str) => SalesInvoices.fromJson(json.decode(str));

String salesInvoicesToJson(SalesInvoices data) => json.encode(data.toJson());

class SalesInvoices {
    SalesInvoices({
        this.status,
        this.message,
        this.saleInvoiceList,
    });

    String status;
    String message;
    List<SaleInvoiceList> saleInvoiceList;

    factory SalesInvoices.fromJson(Map<String, dynamic> json) => SalesInvoices(
        status: json["status"],
        message: json["message"],
        saleInvoiceList: List<SaleInvoiceList>.from(json["sale_invoice_list"].map((x) => SaleInvoiceList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "sale_invoice_list": List<dynamic>.from(saleInvoiceList.map((x) => x.toJson())),
    };
}

class SaleInvoiceList {
    SaleInvoiceList({
        this.salesId,
        this.customerName,
        this.invoiceNo,
        this.invoiceDate,
    });

    int salesId;
    String customerName;
    String invoiceNo;
    DateTime invoiceDate;

    factory SaleInvoiceList.fromJson(Map<String, dynamic> json) => SaleInvoiceList(
        salesId: json["sales_id"],
        customerName: json["customer_name"],
        invoiceNo: json["invoice_no"],
        invoiceDate: DateTime.parse(json["invoice_date"]),
    );

    Map<String, dynamic> toJson() => {
        "sales_id": salesId,
        "customer_name": customerName,
        "invoice_no": invoiceNo,
        "invoice_date": "${invoiceDate.year.toString().padLeft(4, '0')}-${invoiceDate.month.toString().padLeft(2, '0')}-${invoiceDate.day.toString().padLeft(2, '0')}",
    };
}
