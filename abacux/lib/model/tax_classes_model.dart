// To parse this JSON data, do
//
//     final taxClasses = taxClassesFromMap(jsonString);

import 'dart:convert';

TaxClasses taxClassesFromMap(String str) => TaxClasses.fromMap(json.decode(str));

String taxClassesToMap(TaxClasses data) => json.encode(data.toMap());

class TaxClasses {
  TaxClasses({
    this.status,
    this.message,
    this.taxClassesName,
  });

  String status;
  String message;
  List<TaxClassesName> taxClassesName;

  factory TaxClasses.fromMap(Map<String, dynamic> json) => TaxClasses(
    status: json["status"],
    message: json["message"],
    taxClassesName: List<TaxClassesName>.from(json["tax_classes_name"].map((x) => TaxClassesName.fromJson(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "tax_classes_name": List<dynamic>.from(taxClassesName.map((x) => x.toJson())),
  };
}
class TaxClassesName {
  TaxClassesName({
    this.id,
    this.taxClassName,
    this.taxType,
    this.accountName,
    this.taxTypeId,
    this.accountId,
  });

  int id;
  String taxClassName;
  String taxType;
  String accountName;
  int taxTypeId;
  int accountId;
  factory TaxClassesName.fromJson(Map<String, dynamic> json) => TaxClassesName(
    id: json["id"],
    taxClassName: json["tax_class_name"],
    taxType: json["tax_type"],
    accountName: json["account_name"],
    taxTypeId: json["tax_type_id"],
    accountId: json["acc_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tax_class_name": taxClassName,
    "tax_type": taxType,
    "account_name": accountName,
    "tax_type_id": taxTypeId,
    "acc_id": accountId,

  };
}