// To parse this JSON data, do
//
//     final estimateEditUsingId = estimateEditUsingIdFromJson(jsonString);

import 'dart:convert';

EstimateEditUsingId estimateEditUsingIdFromJson(String str) =>
    EstimateEditUsingId.fromJson(json.decode(str));

String estimateEditUsingIdToJson(EstimateEditUsingId data) =>
    json.encode(data.toJson());

class EstimateEditUsingId {
  EstimateEditUsingId({
    this.status,
    this.message,
    this.estimatesVal,
    this.estimatesProducts,
    this.additionalCharges,
  });

  String status;
  String message;
  EstimatesVal estimatesVal;
  List<EstimatesProduct> estimatesProducts;
  List<AdditionalCharge> additionalCharges;

  factory EstimateEditUsingId.fromJson(Map<String, dynamic> json) =>
      EstimateEditUsingId(
        status: json["status"],
        message: json["message"],
        estimatesVal: EstimatesVal.fromJson(json["estimates_val"]),
        estimatesProducts: List<EstimatesProduct>.from(
            json["estimates_products"]
                .map((x) => EstimatesProduct.fromJson(x))),
        additionalCharges: List<AdditionalCharge>.from(
            json["additional_charges"]
                .map((x) => AdditionalCharge.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "estimates_val": estimatesVal.toJson(),
        "estimates_products":
            List<dynamic>.from(estimatesProducts.map((x) => x.toJson())),
        "additional_charges":
            List<dynamic>.from(additionalCharges.map((x) => x.toJson())),
      };
}

class AdditionalCharge {
  AdditionalCharge({
    this.id,
    this.estimateId,
    this.additonalChargeName,
    this.addtionalChargeAmount,
    this.taxPercentage,
    this.totalAmount,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  int id;
  int estimateId;
  String additonalChargeName;
  String addtionalChargeAmount;
  String taxPercentage;
  String totalAmount;
  int isDeleted;
  int createdBy;
  String createdAt;
  dynamic updatedBy;
  dynamic updatedAt;

  factory AdditionalCharge.fromJson(Map<String, dynamic> json) =>
      AdditionalCharge(
        id: json["id"],
        estimateId: json["estimate_id"],
        additonalChargeName: json["additonal_charge_name"],
        addtionalChargeAmount: json["addtional_charge_amount"],
        taxPercentage: json["tax_percentage"],
        totalAmount: json["total_amount"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "estimate_id": estimateId,
        "additonal_charge_name": additonalChargeName,
        "addtional_charge_amount": addtionalChargeAmount,
        "tax_percentage": taxPercentage,
        "total_amount": totalAmount,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
      };
}

class EstimatesProduct {
  EstimatesProduct({
    this.pid,
    this.estimateId,
    this.productId,
    this.quantity,
    this.uomId,
    this.salesRate,
    this.grossTotal,
    this.taxInfo,
    this.discountInPercentage,
    this.discountInAmount,
    this.grandTotal,
  });

  int pid;
  int estimateId;
  int productId;
  int quantity;
  int uomId;
  String salesRate;
  String grossTotal;
  String taxInfo;
  String discountInPercentage;
  String discountInAmount;
  String grandTotal;

  factory EstimatesProduct.fromJson(Map<String, dynamic> json) =>
      EstimatesProduct(
        pid: json["pid"],
        estimateId: json["estimate_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        uomId: json["uom_id"],
        salesRate: json["sales_rate"],
        grossTotal: json["gross_total"],
        taxInfo: json["tax_info"],
        discountInPercentage: json["discount_in_percentage"],
        discountInAmount: json["discount_in_amount"],
        grandTotal: json["grand_total"],
      );

  Map<String, dynamic> toJson() => {
        "pid": pid,
        "estimate_id": estimateId,
        "product_id": productId,
        "quantity": quantity,
        "uom_id": uomId,
        "sales_rate": salesRate,
        "gross_total": grossTotal,
        "tax_info": taxInfo,
        "discount_in_percentage": discountInPercentage,
        "discount_in_amount": discountInAmount,
        "grand_total": grandTotal,
      };
}

class EstimatesVal {
  EstimatesVal({
    this.id,
    this.companyId,
    this.customerId,
    this.estimateNo,
    this.estimateDate,
    this.grossTotal,
    this.grandTotal,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.productSalesPriceTypeId,
    this.taxInfo,
    this.discountInPercentage,
    this.discountInAmount,
    this.estimatePrefix,
  });

  int id;
  int companyId;
  int customerId;
  String estimateNo;
  String estimateDate;
  String grossTotal;
  String grandTotal;
  int isDeleted;
  int createdBy;
  String createdAt;
  dynamic updatedBy;
  dynamic updatedAt;
  dynamic productSalesPriceTypeId;
  String taxInfo;
  String discountInPercentage;
  String discountInAmount;
  String estimatePrefix;

  factory EstimatesVal.fromJson(Map<String, dynamic> json) => EstimatesVal(
        id: json["id"],
        companyId: json["company_id"],
        customerId: json["customer_id"],
        estimateNo: json["estimate_no"],
        estimateDate: json["estimate_date"],
        grossTotal: json["gross_total"],
        grandTotal: json["grand_total"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        productSalesPriceTypeId: json["product_sales_price_type_id"],
        taxInfo: json["tax_info"],
        discountInPercentage: json["discount_in_percentage"],
        discountInAmount: json["discount_in_amount"],
        estimatePrefix: json["estimate_prefix"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "customer_id": customerId,
        "estimate_no": estimateNo,
        "estimate_date": estimateDate,
        "gross_total": grossTotal,
        "grand_total": grandTotal,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "product_sales_price_type_id": productSalesPriceTypeId,
        "tax_info": taxInfo,
        "discount_in_percentage": discountInPercentage,
        "discount_in_amount": discountInAmount,
        "estimate_prefix": estimatePrefix,
      };
}
