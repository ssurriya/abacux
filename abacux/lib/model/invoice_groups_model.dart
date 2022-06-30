// To parse this JSON data, do
//
//     final invoiceGroups = invoiceGroupsFromJson(jsonString);

import 'dart:convert';

InvoiceGroups invoiceGroupsFromJson(String str) => InvoiceGroups.fromJson(json.decode(str));

String invoiceGroupsToJson(InvoiceGroups data) => json.encode(data.toJson());

class InvoiceGroups {
  InvoiceGroups({
    this.status,
    this.message,
    this.employee,
  });

  String status;
  String message;
  List<Employee> employee;

  factory InvoiceGroups.fromJson(Map<String, dynamic> json) => InvoiceGroups(
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
    this.invoiceGroupTitle,
    this.customerId,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.customerName,
    this.companyId,
  });

  int id;
  String invoiceGroupTitle;
  int customerId;
  int isDeleted;
  int createdBy;
  String createdAt;
  dynamic updatedBy;
  dynamic updatedAt;
  String customerName;
  int companyId;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"],
    invoiceGroupTitle: json["invoice_group_title"],
    customerId: json["customer_id"],
    isDeleted: json["is_deleted"],
    createdBy: json["created_by"],
    createdAt: json["created_at"],
    updatedBy: json["updated_by"],
    updatedAt: json["updated_at"],
    customerName: json["customer_name"],
    companyId: json["company_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_group_title": invoiceGroupTitle,
    "customer_id": customerId,
    "is_deleted": isDeleted,
    "created_by": createdBy,
    "created_at": createdAt,
    "updated_by": updatedBy,
    "updated_at": updatedAt,
    "customer_name": customerName,
    "company_id": companyId,
  };
}
