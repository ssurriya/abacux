// To parse this JSON data, do
//
//     final warehouseBins = warehouseBinsFromJson(jsonString);

import 'dart:convert';

WarehouseBins warehouseBinsFromJson(String str) =>
    WarehouseBins.fromJson(json.decode(str));

String warehouseBinsToJson(WarehouseBins data) => json.encode(data.toJson());

class WarehouseBins {
  WarehouseBins({
    this.status,
    this.message,
    this.warehouseBin,
  });

  String status;
  String message;
  List<WarehouseBin> warehouseBin;

  factory WarehouseBins.fromJson(Map<String, dynamic> json) => WarehouseBins(
        status: json["status"],
        message: json["message"],
        warehouseBin: List<WarehouseBin>.from(
            json["warehouseBin"].map((x) => WarehouseBin.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "warehouseBin": List<dynamic>.from(warehouseBin.map((x) => x.toJson())),
      };
}

class WarehouseBin {
  WarehouseBin({
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

  factory WarehouseBin.fromJson(Map<String, dynamic> json) => WarehouseBin(
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
      };
}
