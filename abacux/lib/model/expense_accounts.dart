// To parse this JSON data, do
//
//     final expenseAccounts = expenseAccountsFromJson(jsonString);

import 'dart:convert';

ExpenseAccounts expenseAccountsFromJson(String str) =>
    ExpenseAccounts.fromJson(json.decode(str));

String expenseAccountsToJson(ExpenseAccounts data) =>
    json.encode(data.toJson());

class ExpenseAccounts {
  ExpenseAccounts({
    this.status,
    this.message,
    this.expanseaccounts,
  });

  String status;
  String message;
  List<Expanseaccount> expanseaccounts;

  factory ExpenseAccounts.fromJson(Map<String, dynamic> json) =>
      ExpenseAccounts(
        status: json["status"],
        message: json["message"],
        expanseaccounts: List<Expanseaccount>.from(
            json["expanseaccounts"].map((x) => Expanseaccount.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "expanseaccounts":
            List<dynamic>.from(expanseaccounts.map((x) => x.toJson())),
      };
}

class Expanseaccount {
  Expanseaccount({
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
  int updatedBy;
  DateTime updatedAt;
  String accountCode;
  dynamic openingBalance;
  dynamic taxType;
  dynamic openingBalanceDate;

  factory Expanseaccount.fromJson(Map<String, dynamic> json) => Expanseaccount(
        id: json["id"],
        accountGroupId: json["account_group_id"],
        accountName: json["account_name"],
        parentAccountId: json["parent_account_id"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        accountCode: json["account_code"],
        openingBalance: json["opening_balance"],
        taxType: json["tax_type"],
        openingBalanceDate: json["opening_balance_date"],
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
        "updated_at": updatedAt.toIso8601String(),
        "account_code": accountCode,
        "opening_balance": openingBalance,
        "tax_type": taxType,
        "opening_balance_date": openingBalanceDate,
      };
}
