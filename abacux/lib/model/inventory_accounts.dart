// To parse this JSON data, do
//
//     final inventoryAccounts = inventoryAccountsFromJson(jsonString);

import 'dart:convert';

InventoryAccounts inventoryAccountsFromJson(String str) =>
    InventoryAccounts.fromJson(json.decode(str));

String inventoryAccountsToJson(InventoryAccounts data) =>
    json.encode(data.toJson());

class InventoryAccounts {
  InventoryAccounts({
    this.status,
    this.message,
    this.inventoryAccount,
  });

  String status;
  String message;
  List<InventoryAccount> inventoryAccount;

  factory InventoryAccounts.fromJson(Map<String, dynamic> json) =>
      InventoryAccounts(
        status: json["status"],
        message: json["message"],
        inventoryAccount: List<InventoryAccount>.from(
            json["inventoryAccount"].map((x) => InventoryAccount.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "inventoryAccount":
            List<dynamic>.from(inventoryAccount.map((x) => x.toJson())),
      };
}

class InventoryAccount {
  InventoryAccount({
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
  String openingBalance;
  dynamic taxType;
  DateTime openingBalanceDate;

  factory InventoryAccount.fromJson(Map<String, dynamic> json) =>
      InventoryAccount(
        id: json["id"],
        accountGroupId: json["account_group_id"],
        accountName: json["account_name"],
        parentAccountId: json["parent_account_id"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        accountCode: json["account_code"],
        openingBalance:
            json["opening_balance"] == null ? null : json["opening_balance"],
        taxType: json["tax_type"],
        openingBalanceDate: json["opening_balance_date"] == null
            ? null
            : DateTime.parse(json["opening_balance_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_group_id": accountGroupId,
        "account_name": accountName,
        "parent_account_id": parentAccountId,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_by": updatedBy == null ? null : updatedBy,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "account_code": accountCode,
        "opening_balance": openingBalance == null ? null : openingBalance,
        "tax_type": taxType,
        "opening_balance_date": openingBalanceDate == null
            ? null
            : "${openingBalanceDate.year.toString().padLeft(4, '0')}-${openingBalanceDate.month.toString().padLeft(2, '0')}-${openingBalanceDate.day.toString().padLeft(2, '0')}",
      };
}
