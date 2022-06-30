// To parse this JSON data, do
//
//     final incomeAccounts = incomeAccountsFromJson(jsonString);

import 'dart:convert';

IncomeAccounts incomeAccountsFromJson(String str) =>
    IncomeAccounts.fromJson(json.decode(str));

String incomeAccountsToJson(IncomeAccounts data) => json.encode(data.toJson());

class IncomeAccounts {
  IncomeAccounts({
    this.status,
    this.message,
    this.incomeaccounts,
  });

  String status;
  String message;
  List<Incomeaccount> incomeaccounts;

  factory IncomeAccounts.fromJson(Map<String, dynamic> json) => IncomeAccounts(
        status: json["status"],
        message: json["message"],
        incomeaccounts: List<Incomeaccount>.from(
            json["incomeaccounts"].map((x) => Incomeaccount.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "incomeaccounts":
            List<dynamic>.from(incomeaccounts.map((x) => x.toJson())),
      };
}

class Incomeaccount {
  Incomeaccount({
    this.id,
    this.accountGroupId,
    this.accountName,
    this.parentAccountId,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.accountCode,
    this.openingBalance,
    this.taxType,
    this.openingBalanceDate,
  });

  int id;
  int accountGroupId;
  String accountName;
  int parentAccountId;
  int isDeleted;
  int createdBy;
  DateTime createdAt;
  dynamic updatedBy;
  dynamic updatedAt;
  String accountCode;
  String openingBalance;
  dynamic taxType;
  DateTime openingBalanceDate;

  factory Incomeaccount.fromJson(Map<String, dynamic> json) => Incomeaccount(
        id: json["id"],
        accountGroupId: json["account_group_id"],
        accountName: json["account_name"],
        parentAccountId: json["parent_account_id"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        accountCode: json["account_code"],
        openingBalance: json["opening_balance"],
        taxType: json["tax_type"],
        openingBalanceDate: DateTime.parse(json["opening_balance_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_group_id": accountGroupId,
        "account_name": accountName,
        "parent_account_id": parentAccountId,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "account_code": accountCode,
        "opening_balance": openingBalance,
        "tax_type": taxType,
        "opening_balance_date":
            "${openingBalanceDate.year.toString().padLeft(4, '0')}-${openingBalanceDate.month.toString().padLeft(2, '0')}-${openingBalanceDate.day.toString().padLeft(2, '0')}",
      };
}
