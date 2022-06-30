// To parse this JSON data, do
//
//     final purchaseOrderStore = purchaseOrderStoreFromJson(jsonString);

import 'dart:convert';

PurchaseOrderStore purchaseOrderStoreFromJson(String str) =>
    PurchaseOrderStore.fromJson(json.decode(str));

String purchaseOrderStoreToJson(PurchaseOrderStore data) =>
    json.encode(data.toJson());

class PurchaseOrderStore {
  PurchaseOrderStore({
    this.userId,
    this.companyId,
    this.token,
    this.prefix,
    this.poNo,
    this.vendorId,
    this.poNoSettings,
    this.hiddenPrefix,
    this.poDate,
    this.product,
    this.gstgroup,
    this.gstgroupname,
    this.additionalCharge,
    this.discountotalPercentage,
    this.discount,
    this.grossTotal,
    this.grandTotal,
  });

  int userId;
  int companyId;
  String token;
  String prefix;
  String poNo;
  int vendorId;
  dynamic poNoSettings;
  String hiddenPrefix;
  String poDate;
  List<dynamic> product;
  List<double> gstgroup;
  List<String> gstgroupname;
  List<AdditionalCharge> additionalCharge;
  double discountotalPercentage;
  double discount;
  double grossTotal;
  double grandTotal;

  factory PurchaseOrderStore.fromJson(Map<String, dynamic> json) =>
      PurchaseOrderStore(
        userId: json["user_id"],
        companyId: json["company_id"],
        token: json["token"],
        prefix: json["prefix"],
        poNo: json["po_no"],
        vendorId: json["vendor_id"],
        poNoSettings: json["po_no_settings"],
        hiddenPrefix: json["hidden_prefix"],
        poDate: json["po_date"],
        product: List<Map<String, double>>.from(json["product"].map((x) =>
            Map.from(x)
                .map((k, v) => MapEntry<String, double>(k, v.toDouble())))),
        gstgroup: List<double>.from(json["gstgroup"].map((x) => x.toDouble())),
        gstgroupname: List<String>.from(json["gstgroupname"].map((x) => x)),
        additionalCharge: List<AdditionalCharge>.from(
            json["additionalCharge"].map((x) => AdditionalCharge.fromJson(x))),
        discountotalPercentage: json["discountotal_percentage"].toDouble(),
        discount: json["discount"].toDouble(),
        grossTotal: json["gross_total"].toDouble(),
        grandTotal: json["grand_total"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "company_id": companyId,
        "token": token,
        "prefix": prefix,
        "po_no": poNo,
        "vendor_id": vendorId,
        "po_no_settings": poNoSettings,
        "hidden_prefix": hiddenPrefix,
        "po_date": poDate,
        "product": List<dynamic>.from(product.map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "gstgroup": List<dynamic>.from(gstgroup.map((x) => x)),
        "gstgroupname": List<dynamic>.from(gstgroupname.map((x) => x)),
        "additionalCharge":
            List<dynamic>.from(additionalCharge.map((x) => x.toJson())),
        "discountotal_percentage": discountotalPercentage,
        "discount": discount,
        "gross_total": grossTotal,
        "grand_total": grandTotal,
      };
}

class AdditionalCharge {
  AdditionalCharge({
    this.additonalChargeName,
    this.addtionalChargeAmount,
    this.additionalTaxType,
    this.additionalTaxPercentage,
    this.additionalTotalAmount,
  });

  String additonalChargeName;
  double addtionalChargeAmount;
  int additionalTaxType;
  double additionalTaxPercentage;
  double additionalTotalAmount;

  factory AdditionalCharge.fromJson(Map<String, dynamic> json) =>
      AdditionalCharge(
        additonalChargeName: json["additonal_charge_name"],
        addtionalChargeAmount: json["addtional_charge_amount"].toDouble(),
        additionalTaxType: json["additional_tax_type"].toDouble(),
        additionalTaxPercentage: json["additional_tax_percentage"],
        additionalTotalAmount: json["additional_total_amount"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "additonal_charge_name": additonalChargeName,
        "addtional_charge_amount": addtionalChargeAmount,
        "additional_tax_type": additionalTaxType,
        "additional_tax_percentage": additionalTaxPercentage,
        "additional_total_amount": additionalTotalAmount,
      };
}
