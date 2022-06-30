// To parse this JSON data, do
//
//     final productEstimate = productEstimateFromJson(jsonString);

import 'dart:convert';

ProductEstimate productEstimateFromJson(String str) =>
    ProductEstimate.fromJson(json.decode(str));

String productEstimateToJson(ProductEstimate data) =>
    json.encode(data.toJson());

class ProductEstimate {
  ProductEstimate({
    this.uuid,
    this.productName,
    this.quantity,
    this.unitOfMeasurement,
    this.rate,
    this.crossRate,
  });

  String uuid;
  String productName;
  int quantity;
  int unitOfMeasurement;
  double rate;
  double crossRate;

  factory ProductEstimate.fromJson(Map<String, dynamic> json) =>
      ProductEstimate(
        uuid: json['uuid'],
        productName: json["productName"],
        quantity: json["quantity"],
        unitOfMeasurement: json["unitOfMeasurement"],
        rate: json["rate"],
        crossRate: json["crossRate"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "productName": productName,
        "quantity": quantity,
        "unitOfMeasurement": unitOfMeasurement,
        "rate": rate,
        "crossRate": crossRate,
      };
}
