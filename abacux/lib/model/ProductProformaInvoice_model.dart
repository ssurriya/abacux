// To parse this JSON data, do
//
//     final productProformaInvoice = productProformaInvoiceFromJson(jsonString);

import 'dart:convert';

ProductProformaInvoice productProformaInvoiceFromJson(String str) =>
    ProductProformaInvoice.fromJson(json.decode(str));

String productProformaInvoiceToJson(ProductProformaInvoice data) =>
    json.encode(data.toJson());

class ProductProformaInvoice {
  ProductProformaInvoice({
    this.uuid,
    this.productName,
    this.quantity,
    this.price,
    this.taxType,
    this.tax,
    this.bin,
    this.gstPercentage,
    this.amount,
  });

  String uuid;
  String productName;
  int quantity;
  int price;
  String taxType;
  String tax;
  String bin;
  int gstPercentage;
  int amount;

  factory ProductProformaInvoice.fromJson(Map<String, dynamic> json) =>
      ProductProformaInvoice(
        uuid: json['uuid'],
        productName: json["productName"],
        quantity: json["quantity"],
        price: json["price"],
        taxType: json["taxType"],
        tax: json["tax"],
        bin: json["bin"],
        gstPercentage: json["gstPercentage"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "productName": productName,
        "quantity": quantity,
        "price": price,
        "taxType": taxType,
        "tax": tax,
        "bin": bin,
        "gstPercentage": gstPercentage,
        "amount": amount,
      };
}
