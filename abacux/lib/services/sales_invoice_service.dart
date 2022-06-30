import 'dart:io';

import 'package:abacux/helper/database_helper.dart';
import 'package:abacux/model/customer_model.dart';
import 'package:abacux/model/sales_invoice_details_list.dart';
import 'package:abacux/model/sales_invoice_list.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../config.dart';

class SalesInvoiceService {
  static SalesInvoiceService instance;

  SalesInvoiceService._();

  static SalesInvoiceService getInstance() {
    if (instance == null) {
      instance = new SalesInvoiceService._();
    }
    return instance;
  }

  Customer customer;
  String terms;
  DateTime dateTime;
  DateTime paymentDate;
  List additionalChargeIds;
  SalesInvoiceDetails salesInvoiceDetails;
  String discountInAmt, discountInPercentage;

  setCustomer(Customer customer) {
    this.customer = customer;
  }

  setTerms(String terms) {
    this.terms = terms;
  }

  setDateTime(DateTime dateTime) {
    this.dateTime = dateTime;
  }

  setPaymentDateTime(DateTime paymentDate) {
    this.paymentDate = paymentDate;
  }

  setAdditionalChargeIds(List additionalChargeIds) {
    this.additionalChargeIds = additionalChargeIds;
  }

  setSalesInvoiceDetails(SalesInvoiceDetails salesInvoiceDetails) {
    this.salesInvoiceDetails = salesInvoiceDetails;
  }

  // setSalesInvoiceEditUsingId(SalesInvoiceEditUsingId salesInvoiceEditUsingId) {
  //   this.salesInvoiceEditUsingId = salesInvoiceEditUsingId;
  // }

  setDiscountInAmt(String discountInAmt) {
    this.discountInAmt = discountInAmt;
  }

  setDiscountInPercentage(String discountInPercentage) {
    this.discountInPercentage = discountInPercentage;
  }

  Customer get getCustomer => this.customer;

  DateTime get getDateTime => this.dateTime;

  DateTime get getPaymentDate => this.paymentDate;

  List get getAdditionalChargeIds => this.additionalChargeIds;

  // SalesInvoiceEditUsingId get getSalesInvoiceEditUsingId =>
  //     this.salesInvoiceEditUsingId;

  SalesInvoiceDetails get getSalesInvoiceDetails => this.salesInvoiceDetails;

  String get getDiscountInAmt => this.discountInAmt;

  String get getDiscountInPercentage => this.discountInPercentage;

  String get getTerms => this.terms;

  Future<List<SaleInvoiceList>> getSalesInvoiceList(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Config().apiGetSalesInvoiceList, body: body, headers: headers)
        .then((http.Response response) {
      // final items =
      //     json.decode(response.body)['sale_invoice_list'].cast<Map<String, dynamic>>();

      SalesInvoices salesInvoices = salesInvoicesFromJson(response.body);

      return salesInvoices.saleInvoiceList;
    });
  }

  Future<SalesInvoiceDetails> getSalesInvoiceDetailsList(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Config().apiGetSalesInvoiceDetailsList,
            body: body, headers: headers)
        .then((http.Response response) {
      SalesInvoiceDetails saleInvoiceDetails =
          salesInvoiceDetailsFromJson(response.body);

      return saleInvoiceDetails;
    });
  }

  Future getSalesInvoiceLocalProduct() async {
    Database db = await DatabaseHelper.instance.database;
    var raw = await db.rawQuery("SELECT * FROM SalesInvoiceProduct");
    return raw;
  }

  Future insertSalesInvoiceProductLocal(Map salesInvoiceProduct) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawInsert(
        "INSERT Into SalesInvoiceProduct (id,uuid,product,pid,productId,productUomsId,quantity,basicPrice,price,taxTypeId,taxType,tax,discount,discountAmount,amount,cgst,sgst,igst,salesTax,subTotal)"
        " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
        [
          salesInvoiceProduct['id'],
          salesInvoiceProduct['uuid'],
          salesInvoiceProduct['product'],
          salesInvoiceProduct['pid'],
          salesInvoiceProduct['productId'],
          salesInvoiceProduct['productUomsId'],
          salesInvoiceProduct['quantity'],
          salesInvoiceProduct['basicPrice'],
          salesInvoiceProduct['price'],
          salesInvoiceProduct['taxTypeId'],
          salesInvoiceProduct['taxType'],
          salesInvoiceProduct['tax'],
          salesInvoiceProduct['discount'],
          salesInvoiceProduct['discountAmount'],
          salesInvoiceProduct['amount'],
          salesInvoiceProduct['cgst'],
          salesInvoiceProduct['sgst'],
          salesInvoiceProduct['igst'],
          salesInvoiceProduct['salesTax'],
          salesInvoiceProduct['subTotal']
        ]);

    return raw;
  }

  Future updateSalesInvoiceProductLocal(Map salesInvoiceProduct) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawUpdate("Update SalesInvoiceProduct SET product='" +
        salesInvoiceProduct['product'] +
        "',quantity='" +
        salesInvoiceProduct['quantity'].toString() +
        "',pid='" +
        salesInvoiceProduct['pid'].toString() +
        "'productId='" +
        salesInvoiceProduct['productId'].toString() +
        "',productUomsId='" +
        salesInvoiceProduct['productUomsId'].toString() +
        "',basicPrice='" +
        salesInvoiceProduct['basicPrice'].toString() +
        "',price='" +
        salesInvoiceProduct['price'].toString() +
        "',taxType='" +
        salesInvoiceProduct['taxType'].toString() +
        "',tax='" +
        salesInvoiceProduct['tax'].toString() +
        "',discount='" +
        salesInvoiceProduct['discount'].toString() +
        "',discountAmount='" +
        salesInvoiceProduct['discountAmount'].toString() +
        "',amount='" +
        salesInvoiceProduct['amount'].toString() +
        "',cgst='" +
        salesInvoiceProduct['cgst'].toString() +
        "',sgst='" +
        salesInvoiceProduct['sgst'].toString() +
        "',igst='" +
        salesInvoiceProduct['igst'].toString() +
        "',salesTax='" +
        salesInvoiceProduct['salesTax'].toString() +
        "',subTotal='" +
        salesInvoiceProduct['subTotal'].toString() +
        "' WHERE uuid='" +
        salesInvoiceProduct['uuid'] +
        "'" +
        '');

    return raw;
  }

  Future deleteSalesInvoiceProductUsingUuid(String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db
        .rawDelete("DELETE FROM SalesInvoiceProduct WHERE uuid=?", [uuid]);

    return raw;
  }

  Future deleteAllSalesInvoiceProductToLocal() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete("DELETE FROM SalesInvoiceProduct");

    return raw;
  }

  Future getSalesInvoiceAdditionalCharge() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawQuery("SELECT * FROM SalesInvoiceAdditionalCharges");

    return raw;
  }

  Future insertSalesInvoiceAdditionalChargesToLocal(
      Map<String, dynamic> additionalCharges) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawInsert(
        "INSERT Into SalesInvoiceAdditionalCharges (id,uuid,additonal_charge_name,additional_charge_id,additional_charge_amount,additional_tax_type,additional_tax_percentage,additional_total_amount)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [
          additionalCharges['id'],
          additionalCharges['uuid'],
          additionalCharges['additionalCharge'],
          additionalCharges['additionalChargeId'],
          additionalCharges['amount'],
          additionalCharges['taxType'],
          additionalCharges['tax'],
          additionalCharges['totalAmount'],
        ]);

    return raw;
  }

  Future updateSalesInvoiceAdditionalChargesToLocal(
      Map<String, dynamic> additionalCharges) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawUpdate(
        "Update SalesInvoiceAdditionalCharges SET additonal_charge_name='" +
            additionalCharges['additionalCharge'] +
            "',additional_charge_id='" +
            additionalCharges['additionalChargeId'].toString() +
            "',additional_charge_amount='" +
            additionalCharges['amount'].toString() +
            "',additional_tax_type='" +
            additionalCharges['taxType'].toString() +
            "',additional_tax_percentage='" +
            additionalCharges['tax'].toString() +
            "',additional_total_amount='" +
            additionalCharges['totalAmount'].toString() +
            "' WHERE uuid='" +
            additionalCharges['uuid'] +
            "'" +
            '');

    return raw;
  }

  Future deleteSalesInvoiceAdditionalChargesToLocal(String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete(
        'DELETE FROM SalesInvoiceAdditionalCharges WHERE uuid = ?', [uuid]);

    return raw;
  }

  Future deleteAllSalesInvoiceAdditionalChargesToLocal() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete('DELETE FROM SalesInvoiceAdditionalCharges');

    return raw;
  }
}
