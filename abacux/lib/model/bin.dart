// To parse this JSON data, do
//
//     final bin = binFromJson(jsonString);

import 'dart:convert';

Bin binFromJson(String str) => Bin.fromJson(json.decode(str));

String binToJson(Bin data) => json.encode(data.toJson());

class Bin {
  Bin({
    this.warehouseName,
    this.id,
    this.binName,
  });

  String warehouseName;
  int id;
  String binName;

  factory Bin.fromJson(Map<String, dynamic> json) => Bin(
        warehouseName: json["warehouse_name"],
        id: json["id"],
        binName: json["bin_name"],
      );

  Map<String, dynamic> toJson() => {
        "warehouse_name": warehouseName,
        "id": id,
        "bin_name": binName,
      };
}
