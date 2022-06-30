// To parse this JSON data, do
//
//     final postProducts = postProductsFromJson(jsonString);

import 'dart:convert';

List<Map<String, double>> postProductsFromJson(String str) =>
    List<Map<String, double>>.from(json.decode(str).map((x) =>
        Map.from(x).map((k, v) => MapEntry<String, double>(k, v.toDouble()))));

String postProductsToJson(List<Map<String, double>> data) =>
    json.encode(List<dynamic>.from(data.map(
        (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))));

// To parse this JSON data, do
//
//     final postAdditionalCharge = postAdditionalChargeFromJson(jsonString);

List<PostAdditionalCharge> postAdditionalChargeFromJson(String str) =>
    List<PostAdditionalCharge>.from(
        json.decode(str).map((x) => PostAdditionalCharge.fromJson(x)));

String postAdditionalChargeToJson(List<PostAdditionalCharge> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostAdditionalCharge {
  PostAdditionalCharge({
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

  factory PostAdditionalCharge.fromJson(Map<String, dynamic> json) =>
      PostAdditionalCharge(
        additonalChargeName: json["additonal_charge_name"],
        addtionalChargeAmount: json["addtional_charge_amount"],
        additionalTaxType: json["additional_tax_type"],
        additionalTaxPercentage: json["additional_tax_percentage"],
        additionalTotalAmount: json["additional_total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "additonal_charge_name": additonalChargeName,
        "addtional_charge_amount": addtionalChargeAmount,
        "additional_tax_type": additionalTaxType,
        "additional_tax_percentage": additionalTaxPercentage,
        "additional_total_amount": additionalTotalAmount,
      };
}

// To parse this JSON data, do
//
//     final postGstGroupName = postGstGroupNameFromJson(jsonString);

List<String> postGstGroupNameFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String postGstGroupNameToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));

// To parse this JSON data, do
//
//     final postGstGroup = postGstGroupFromJson(jsonString);

List<double> postGstGroupFromJson(String str) =>
    List<double>.from(json.decode(str).map((x) => x));

String postGstGroupToJson(List<double> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
