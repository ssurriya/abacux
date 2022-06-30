import 'dart:convert';

Product ProductFromJson(String str) => Product.fromJson(json.decode(str));

String ProductToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
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
    this.attributeId,
    this.umosId,
    this.attributeValue,
    this.purchaseTaxClassId,
    this.salesTaxClassId,
    this.purchasePriceInclusiveTax,
    this.salesPriceInclusiveTax,
    this.purchasePrice,
    this.salesPrice,
    this.taxClassTaxId,
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
  int attributeId;
  int umosId;
  String attributeValue;
  int purchaseTaxClassId;
  int salesTaxClassId;
  int purchasePriceInclusiveTax;
  int salesPriceInclusiveTax;
  String purchasePrice;
  String salesPrice;
  int taxClassTaxId;
  int taxPercentage;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        companyId: json["company_id"],
        productName: json["product_name"] == null ? null : json["product_name"],
        productDescription: json["product_description"] == null
            ? null
            : json["product_description"],
        hsnCode: json["hsn_code"] == null ? null : json["hsn_code"],
        partNo: json["part_no"] == null ? null : json["part_no"],
        avilableStock:
            json["avilable_stock"] == null ? null : json["avilable_stock"],
        lessStockNotification: json["less_stock_notification"] == null
            ? null
            : json["less_stock_notification"],
        taxClassId: json["tax_class_id"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        productOtherName: json["product_other_name"] == null
            ? null
            : json["product_other_name"],
        attributeId: json["attribute_id"] == null ? null : json["attribute_id"],
        umosId: json["uom_id"] == null ? null : json["uom_id"],
        attributeValue:
            json["attribute_value"] == null ? null : json["attribute_value"],
        purchaseTaxClassId: json["purchase_tax_class_id"] == null
            ? null
            : json["purchase_tax_class_id"],
        salesTaxClassId: json["sales_tax_class_id"] == null
            ? null
            : json["sales_tax_class_id"],
        purchasePriceInclusiveTax: json["purchase_price_inclusive_tax"] == null
            ? null
            : json["purchase_price_inclusive_tax"],
        salesPriceInclusiveTax: json["sales_price_inclusive_tax"] == null
            ? null
            : json["sales_price_inclusive_tax"],
        purchasePrice:
            json["purchase_price"] == null ? null : json["purchase_price"],
        salesPrice: json["sales_price"] == null ? null : json["sales_price"],
        taxClassTaxId:
            json["tax_class_tax_id"] == null ? null : json["tax_class_tax_id"],
        taxPercentage:
            json["tax_percentage"] == null ? null : json["tax_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "product_name": productName == null ? null : productName,
        "product_description":
            productDescription == null ? null : productDescription,
        "hsn_code": hsnCode == null ? null : hsnCode,
        "part_no": partNo == null ? null : partNo,
        "avilable_stock": avilableStock == null ? null : avilableStock,
        "less_stock_notification":
            lessStockNotification == null ? null : lessStockNotification,
        "tax_class_id": taxClassId,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy == null ? null : updatedBy,
        "updated_at": updatedAt == null ? null : updatedAt,
        "product_other_name":
            productOtherName == null ? null : productOtherName,
        "attribute_id": attributeId == null ? null : attributeId,
        "uom_id": umosId == null ? null : umosId,
        "attribute_value": attributeValue == null ? null : attributeValue,
        "purchase_tax_class_id":
            purchaseTaxClassId == null ? null : purchaseTaxClassId,
        "sales_tax_class_id": salesTaxClassId == null ? null : salesTaxClassId,
        "purchase_price_inclusive_tax": purchasePriceInclusiveTax == null
            ? null
            : purchasePriceInclusiveTax,
        "sales_price_inclusive_tax":
            salesPriceInclusiveTax == null ? null : salesPriceInclusiveTax,
        "purchase_price": purchasePrice == null ? null : purchasePrice,
        "sales_price": salesPrice == null ? null : salesPrice,
        "tax_class_tax_id": taxClassTaxId == null ? null : taxClassTaxId,
        "tax_percentage": taxPercentage == null ? null : taxPercentage,
      };
}
