// To parse this JSON data, do
//
//     final financialYear = financialYearFromJson(jsonString);

import 'dart:convert';

FinancialYear financialYearFromJson(String str) =>
    FinancialYear.fromJson(json.decode(str));

String financialYearToJson(FinancialYear data) => json.encode(data.toJson());

class FinancialYear {
  FinancialYear({
    this.status,
    this.message,
    this.financialYear,
  });

  String status;
  String message;
  List<FinancialYearElement> financialYear;

  factory FinancialYear.fromJson(Map<String, dynamic> json) => FinancialYear(
        status: json["status"],
        message: json["message"],
        financialYear: List<FinancialYearElement>.from(json["financial_year"]
            .map((x) => FinancialYearElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "financial_year":
            List<dynamic>.from(financialYear.map((x) => x.toJson())),
      };
}

class FinancialYearElement {
  FinancialYearElement({
    this.id,
    this.companyId,
    this.fromDate,
    this.toDate,
    this.status,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.decimal,
  });

  int id;
  int companyId;
  DateTime fromDate;
  DateTime toDate;
  int status;
  int isDeleted;
  int createdBy;
  String createdAt;
  int updatedBy;
  String updatedAt;
  int decimal;

  factory FinancialYearElement.fromJson(Map<String, dynamic> json) =>
      FinancialYearElement(
        id: json["id"],
        companyId: json["company_id"],
        fromDate: DateTime.parse(json["from_date"]),
        toDate: DateTime.parse(json["to_date"]),
        status: json["status"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        decimal: json["decimal"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "from_date":
            "${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
        "to_date":
            "${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}",
        "status": status,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "decimal": decimal,
      };
}
