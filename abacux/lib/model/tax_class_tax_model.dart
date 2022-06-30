// To parse this JSON data, do
//
//     final taxClassTaxType = taxClassTaxTypeFromJson(jsonString);

import 'dart:convert';

TaxClassTaxType taxClassTaxTypeFromJson(String str) =>
    TaxClassTaxType.fromJson(json.decode(str));

String taxClassTaxTypeToJson(TaxClassTaxType data) =>
    json.encode(data.toJson());

class TaxClassTaxType {
  TaxClassTaxType({
    this.status,
    this.message,
    this.taxClassTax,
  });

  String status;
  String message;
  List<TaxClassTax> taxClassTax;

  factory TaxClassTaxType.fromJson(Map<String, dynamic> json) =>
      TaxClassTaxType(
        status: json["status"],
        message: json["message"],
        taxClassTax: List<TaxClassTax>.from(
            json["tax_class_tax"].map((x) => TaxClassTax.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "tax_class_tax": List<dynamic>.from(taxClassTax.map((x) => x.toJson())),
      };
}

class TaxClassTax {
  TaxClassTax({
    this.id,
    this.taxPercentage,
    this.taxClassName,
    this.taxId,
    this.taxTypeId,
    this.tax,
    this.taxType,
  });

  int id;
  int taxPercentage;
  String taxClassName;
  int taxId;
  int taxTypeId;

  String tax;
  String taxType;

  factory TaxClassTax.fromJson(Map<String, dynamic> json) => TaxClassTax(
        id: json["id"],
        taxPercentage: json["tax_percentage"],
        taxClassName: json["tax_class_name"],
        taxId: json["tax_id"],
        taxTypeId: json["tax_type_id"],
        tax: json["tax"],
        taxType: json["tax_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tax_percentage": taxPercentage,
        "tax_class_name": taxClassName,
        "tax_id": taxId,
        "tax_type_id": taxTypeId,
        "tax": tax,
        "tax_type": taxType,
      };
}
