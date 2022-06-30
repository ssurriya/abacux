// To parse this JSON data, do
//
//     final salesperson = salespersonFromJson(jsonString);

import 'dart:convert';

Salesperson salespersonFromJson(String str) => Salesperson.fromJson(json.decode(str));

String salespersonToJson(Salesperson data) => json.encode(data.toJson());

class Salesperson {
  Salesperson({
    this.status,
    this.message,
    this.employee,
  });

  String status;
  String message;
  List<Employee> employee;

  factory Salesperson.fromJson(Map<String, dynamic> json) => Salesperson(
    status: json["status"],
    message: json["message"],
    employee: List<Employee>.from(json["employee"].map((x) => Employee.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "employee": List<dynamic>.from(employee.map((x) => x.toJson())),
  };
}

class Employee {
  Employee({
    this.id,
    this.companyId,
    this.employeeName,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  int id;
  int companyId;
  String employeeName;
  int isDeleted;
  int createdBy;
  DateTime createdAt;
  dynamic updatedBy;
  dynamic updatedAt;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"],
    companyId: json["company_id"],
    employeeName: json["employee_name"],
    isDeleted: json["is_deleted"],
    createdBy: json["created_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedBy: json["updated_by"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "employee_name": employeeName,
    "is_deleted": isDeleted,
    "created_by": createdBy,
    "created_at": createdAt.toIso8601String(),
    "updated_by": updatedBy,
    "updated_at": updatedAt,
  };
}
