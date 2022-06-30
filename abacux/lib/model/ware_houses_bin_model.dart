// To parse this JSON data, do
//
//     final warehousesBinList = warehousesBinListFromJson(jsonString);

import 'dart:convert';

WarehousesBinList warehousesBinListFromJson(String str) =>
    WarehousesBinList.fromJson(json.decode(str));

String warehousesBinListToJson(WarehousesBinList data) =>
    json.encode(data.toJson());

class WarehousesBinList {
  WarehousesBinList({
    this.status,
    this.message,
    this.warehousesBinList,
  });

  String status;
  String message;
  List<WarehousesBinListElement> warehousesBinList;

  factory WarehousesBinList.fromJson(Map<String, dynamic> json) =>
      WarehousesBinList(
        status: json["status"],
        message: json["message"],
        warehousesBinList: List<WarehousesBinListElement>.from(
            json["warehousesBin_list"]
                .map((x) => WarehousesBinListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "warehousesBin_list":
            List<dynamic>.from(warehousesBinList.map((x) => x.toJson())),
      };
}

class WarehousesBinListElement {
  WarehousesBinListElement({
    this.id,
    this.companyId,
    this.warehouseId,
    this.binName,
    this.binCode,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.warehouseName,
  });

  int id;
  int companyId;
  int warehouseId;
  String binName;
  String binCode;
  int isDeleted;
  int createdBy;
  String createdAt;
  int updatedBy;
  String updatedAt;
  String warehouseName;

  factory WarehousesBinListElement.fromJson(Map<String, dynamic> json) =>
      WarehousesBinListElement(
        id: json["id"],
        companyId: json["company_id"],
        warehouseId: json["warehouse_id"],
        binName: json["bin_name"],
        binCode: json["bin_code"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        warehouseName: json["warehouse_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "warehouse_id": warehouseId,
        "bin_name": binName,
        "bin_code": binCode,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "warehouse_name": warehouseName,
      };
}
