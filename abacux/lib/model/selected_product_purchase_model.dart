import 'dart:convert';

SelectedProductPurchase selectedProductPurchaseFromJson(String str) =>
    SelectedProductPurchase.fromJson(json.decode(str));

String selectedProductPurchaseToJson(SelectedProductPurchase data) =>
    json.encode(data.toJson());

class SelectedProductPurchase {
  SelectedProductPurchase({
    this.id,
    this.companyId,
    this.productName,
    this.productDescription,
    this.hsnCode,
    this.partNo,
    this.avilableStock,
    this.lessStockNotification,
    this.taxClassId,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.productOtherName,
    this.purchaseTaxClassId,
    this.purchasePrice,
    this.taxPercentage,
  });

  int id;
  int companyId;
  String productName;
  String productDescription;
  int hsnCode;
  String partNo;
  int avilableStock;
  int lessStockNotification;
  dynamic taxClassId;
  int isDeleted;
  int createdBy;
  String createdAt;
  int updatedBy;
  String updatedAt;
  String productOtherName;
  int purchaseTaxClassId;
  String purchasePrice;
  int taxPercentage;

  factory SelectedProductPurchase.fromJson(Map<String, dynamic> json) =>
      SelectedProductPurchase(
        id: json["id"],
        companyId: json["company_id"],
        productName: json["product_name"],
        productDescription: json["product_description"],
        hsnCode: json["hsn_code"],
        partNo: json["part_no"],
        avilableStock: json["avilable_stock"],
        lessStockNotification: json["less_stock_notification"],
        taxClassId: json["tax_class_id"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        productOtherName: json["product_other_name"],
        purchaseTaxClassId: json["purchase_tax_class_id"],
        purchasePrice: json["purchase_price"],
        taxPercentage: json["tax_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "product_name": productName,
        "product_description": productDescription,
        "hsn_code": hsnCode,
        "part_no": partNo,
        "avilable_stock": avilableStock,
        "less_stock_notification": lessStockNotification,
        "tax_class_id": taxClassId,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "product_other_name": productOtherName,
        "purchase_tax_class_id": purchaseTaxClassId,
        "purchase_price": purchasePrice,
        "tax_percentage": taxPercentage,
      };
}
