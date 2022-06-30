import 'dart:convert';

Estimate estimateFromJson(String str) => Estimate.fromJson(json.decode(str));

String estimateToJson(Estimate data) => json.encode(data.toJson());

class Estimate {
  Estimate({
    this.id,
    this.estimateNo,
    this.estimateDate,
    this.customerName,
    this.grandTotal,
    this.salesid,
    this.estimatePrefix,
  });

  int id;
  String estimateNo;
  DateTime estimateDate;
  String customerName;
  String grandTotal;
  int salesid;
  String estimatePrefix;

  factory Estimate.fromJson(Map<String, dynamic> json) => Estimate(
        id: json["id"],
        estimateNo: json["estimate_no"],
        estimateDate: DateTime.parse(json["estimate_date"]),
        customerName: json["customer_name"],
        grandTotal: json["grand_total"],
        salesid: json["salesid"] == null ? null : json["salesid"],
        estimatePrefix: json["estimate_prefix"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "estimate_no": estimateNo,
        "estimate_date":
            "${estimateDate.year.toString().padLeft(4, '0')}-${estimateDate.month.toString().padLeft(2, '0')}-${estimateDate.day.toString().padLeft(2, '0')}",
        "customer_name": customerName,
        "grand_total": grandTotal,
        "salesid": salesid == null ? null : salesid,
        "estimate_prefix": estimatePrefix,
      };
}
