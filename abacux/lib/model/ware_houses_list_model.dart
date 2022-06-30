// To parse this JSON data, do
//
//     final warehousesList = warehousesListFromJson(jsonString);

import 'dart:convert';

WarehousesList warehousesListFromJson(String str) =>
    WarehousesList.fromJson(json.decode(str));

String warehousesListToJson(WarehousesList data) => json.encode(data.toJson());

class WarehousesList {
  WarehousesList({
    this.status,
    this.message,
    this.warehousesList,
  });

  String status;
  String message;
  List<WarehousesListElement> warehousesList;

  factory WarehousesList.fromJson(Map<String, dynamic> json) => WarehousesList(
        status: json["status"],
        message: json["message"],
        warehousesList: List<WarehousesListElement>.from(json["warehouses_list"]
            .map((x) => WarehousesListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "warehouses_list":
            List<dynamic>.from(warehousesList.map((x) => x.toJson())),
      };
}

class WarehousesListElement {
  WarehousesListElement({
    this.id,
    this.companyId,
    this.warehouseCode,
    this.warehouseName,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  int id;
  int companyId;
  String warehouseCode;
  String warehouseName;
  int isDeleted;
  int createdBy;
  DateTime createdAt;
  int updatedBy;
  DateTime updatedAt;

  factory WarehousesListElement.fromJson(Map<String, dynamic> json) =>
      WarehousesListElement(
        id: json["id"],
        companyId: json["company_id"],
        warehouseCode: json["warehouse_code"],
        warehouseName: json["warehouse_name"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "warehouse_code": warehouseCode,
        "warehouse_name": warehouseName,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_by": updatedBy,
        "updated_at": updatedAt.toIso8601String(),
      };
}
