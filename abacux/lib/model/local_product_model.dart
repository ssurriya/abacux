// To parse this JSON data, do
//
//     final proformaInvoiceProduct = proformaInvoiceProductFromJson(jsonString);

import 'dart:convert';

LocalProduct proformaInvoiceProductFromJson(String str) =>
    LocalProduct.fromJson(json.decode(str));

String proformaInvoiceProductToJson(LocalProduct data) =>
    json.encode(data.toJson());

class LocalProduct {
  LocalProduct({
    this.id,
    this.uuid,
    this.product,
    this.pid,
    this.productId,
    this.productUomsId,
    this.quantity,
    this.basicPrice,
    this.price,
    this.taxTypeId,
    this.taxType,
    this.tax,
    this.discount,
    this.discountAmount,
    this.amount,
    this.cgst,
    this.igst,
    this.sgst,
    this.salesTax,
    this.subTotal,
  });

  int id;
  String uuid;
  String product;
  int pid;
  int productId;
  int productUomsId;
  double quantity;
  double basicPrice;
  double price;
  int taxTypeId;
  int taxType;
  double tax;
  double discount;
  double discountAmount;
  double amount;
  double cgst;
  double igst;
  double sgst;
  double salesTax;
  double subTotal;

  factory LocalProduct.fromJson(Map<String, dynamic> json) => LocalProduct(
        id: json["id"],
        uuid: json["uuid"],
        product: json["product"],
        pid: json['pid'],
        productId: json["productId"],
        productUomsId: json["productUomsId"],
        quantity: json["quantity"],
        basicPrice: json["basicPrice"],
        price: json["price"].toDouble(),
        taxTypeId: json["taxTypeId"],
        taxType: json["taxType"],
        tax: json["tax"],
        discount: json["discount"],
        discountAmount: json["discountAmount"].toDouble(),
        amount: json["amount"],
        cgst: json["cgst"].toDouble(),
        igst: json["igst"],
        sgst: json["sgst"].toDouble(),
        salesTax: json["salesTax"].toDouble(),
        subTotal: json["subTotal"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "product": product,
        "pid": pid,
        "productId": productId,
        "productUomsId": productUomsId,
        "quantity": quantity,
        "basicPrice": basicPrice,
        "price": price,
        "taxTypeId": taxTypeId,
        "taxType": taxType,
        "tax": tax,
        "discount": discount,
        "discountAmount": discountAmount,
        "amount": amount,
        "cgst": cgst,
        "igst": igst,
        "sgst": sgst,
        "salesTax": salesTax,
        "subTotal": subTotal,
      };
}

class LocalAdditionalCharge {
  LocalAdditionalCharge({
    this.id,
    this.uuid,
    this.additonalChargeName,
    this.additionalChargeId,
    this.addtionalChargeAmount,
    this.additionalTaxType,
    this.additionalTaxPercentage,
    this.additionalTotalAmount,
  });

  int id;
  String uuid;
  String additonalChargeName;
  int additionalChargeId;
  double addtionalChargeAmount;
  int additionalTaxType;
  double additionalTaxPercentage;
  double additionalTotalAmount;

  factory LocalAdditionalCharge.fromJson(Map<String, dynamic> json) =>
      LocalAdditionalCharge(
        id: json["id"],
        uuid: json["uuid"],
        additonalChargeName: json["additonal_charge_name"],
        additionalChargeId: json["additional_charge_id"],
        addtionalChargeAmount: json["additional_charge_amount"],
        additionalTaxType: json["additional_tax_type"],
        additionalTaxPercentage: json["additional_tax_percentage"],
        additionalTotalAmount: json["additional_total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "additonal_charge_name": additonalChargeName,
        "additional_charge_id": additionalChargeId,
        "additional_charge_amount": addtionalChargeAmount,
        "additional_tax_type": additionalTaxType,
        "additional_tax_percentage": additionalTaxPercentage,
        "additional_total_amount": additionalTotalAmount,
      };
}
