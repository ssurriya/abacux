import 'dart:convert';

Vendor vendorFromJson(String str) => Vendor.fromJson(json.decode(str));

String vendorToJson(Vendor data) => json.encode(data.toJson());

class Vendor {
  Vendor({
    this.id,
    this.accountHolderId,
    this.vendor_name,
    this.contactNoOne,
    this.contactNoTwo,
    this.gstinNo,
    this.panNo,
    this.vendor_address,
    this.stateName,
    this.stateCode,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.customerEmail,
    this.accountId,
    this.companyName,
    this.shippingAddress,
    this.companyId,
    this.accountHolderTypeId,
    this.accountHolderType,
  });

  int id;
  int accountHolderId;
  String vendor_name;
  int contactNoOne;
  int contactNoTwo;
  String gstinNo;
  String panNo;
  String vendor_address;
  String stateName;
  String stateCode;
  int isDeleted;
  int createdBy;
  String createdAt;
  dynamic updatedBy;
  dynamic updatedAt;
  String customerEmail;
  int accountId;
  String companyName;
  String shippingAddress;
  int companyId;
  int accountHolderTypeId;
  String accountHolderType;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["id"],
        accountHolderId: json["account_holder_id"],
        vendor_name: json["vendor_name"],
        contactNoOne: json["contact_no_one"],
        contactNoTwo: json["contact_no_two"],
        gstinNo: json["gstin_no"],
        panNo: json["pan_no"],
        vendor_address: json["vendor_address"],
        stateName: json["state_name"],
        stateCode: json["state_code"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        customerEmail: json["customer_email"],
        accountId: json["account_id"],
        companyName: json["company_name"],
        shippingAddress: json["shipping_address"],
        companyId: json["company_id"],
        accountHolderTypeId: json["account_holder_type_id"],
        accountHolderType: json["account_holder_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_holder_id": accountHolderId,
        "vendor_name": vendor_name,
        "contact_no_one": contactNoOne,
        "contact_no_two": contactNoTwo,
        "gstin_no": gstinNo,
        "pan_no": panNo,
        "vendor_address": vendor_address,
        "state_name": stateName,
        "state_code": stateCode,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "customer_email": customerEmail,
        "account_id": accountId,
        "company_name": companyName,
        "shipping_address": shippingAddress,
        "company_id": companyId,
        "account_holder_type_id": accountHolderTypeId,
        "account_holder_type": accountHolderType,
      };
}
