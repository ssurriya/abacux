import 'dart:convert';
import 'dart:io';

import 'package:abacux/helper/database_helper.dart';
import 'package:abacux/model/Product_model.dart';
import 'package:abacux/model/customer_model.dart';
import 'package:abacux/model/proforma_invoice_edit_using_id.dart';
import 'package:abacux/model/proforma_invoice_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../config.dart';

class ProformaInvoiceService {
  static ProformaInvoiceService instance;

  ProformaInvoiceService._();

  static ProformaInvoiceService getInstance() {
    if (instance == null) {
      instance = new ProformaInvoiceService._();
    }
    return instance;
  }

  Customer customer;
  DateTime dateTime;
  ProformaInvoiceEditUsingId proformaInvoiceEditUsingId;
  List additionalChargeIds;
  String discountInAmt, discountInPercentage;

  setCustomer(Customer customer) {
    this.customer = customer;
  }

  setDateTime(DateTime dateTime) {
    this.dateTime = dateTime;
  }

  setProformaInvoiceEditUsingId(
      ProformaInvoiceEditUsingId proformaInvoiceEditUsingId) {
    this.proformaInvoiceEditUsingId = proformaInvoiceEditUsingId;
  }

  setAdditionalChargeIds(List additionalChargeIds) {
    this.additionalChargeIds = additionalChargeIds;
  }

  setDiscountInAmt(String discountInAmt) {
    this.discountInAmt = discountInAmt;
  }

  setDiscountInPercentage(String discountInPercentage) {
    this.discountInPercentage = discountInPercentage;
  }

  Customer get getCustomer => this.customer;

  DateTime get getDateTime => this.dateTime;

  ProformaInvoiceEditUsingId get getProformaInvoiceEditUsingIdFromLocal =>
      this.proformaInvoiceEditUsingId;

  List get getAdditionalChargeIds => this.additionalChargeIds;

  String get getDiscountInAmt => this.discountInAmt;

  String get getDiscountInPercentage => this.discountInPercentage;

  Future<List<ProformaInvoiceList>> getProfromaInvoiceListFromApi(
      Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Config().apiGetProfromaInvoiceList, body: body, headers: headers)
        .then((http.Response response) {
      final items =
          json.decode(response.body)['listdata'].cast<Map<String, dynamic>>();

      List<ProformaInvoiceList> proformaInvoicelist =
          items.map<ProformaInvoiceList>((json) {
        return ProformaInvoiceList.fromJson(json);
      }).toList();
      return proformaInvoicelist;
    });
  }

  Future<List<Product>> getProfromaProduct(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Config().apiGetPurchaseProductList, body: body, headers: headers)
        .then((http.Response response) {
      final items =
          json.decode(response.body)['products'].cast<Map<String, dynamic>>();
      List<Product> products = items.map<Product>((json) {
        return Product.fromJson(json);
      }).toList();
      return products;
    });
  }

  Future getProformaSettings(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Config().apiGetProformaInvoiceSettings,
            body: body, headers: headers)
        .then((http.Response response) {
      print(response.body);
      return json.decode(response.body)['quotation_settings'];
    });
  }

  Future getProformaInvoiceNo(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Config().apiGetProformaInvoiceNo, body: body, headers: headers)
        .then((http.Response response) {
      return json.decode(response.body)['proforma_invoice_no'];
    });
  }

  Future postProformaInvoiceStore(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    print(body);

    final response = await http.post(
        Uri.parse(Config().apiProformaInvoiceStore),
        body: body,
        headers: headers);

    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    }
  }

  Future updateProformaInvoiceStore(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    print(body);

    final response = await http.post(
        Uri.parse(Config().apiUpdateProformaInvoiceStore),
        body: body,
        headers: headers);

    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    }
  }

  Future deleteProformaInvoiceApi(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    print(body);

    final response = await http.post(
        Uri.parse(Config().apiDeleteProformaInvoice),
        body: body,
        headers: headers);

    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    }
  }

  Future<ProformaInvoiceEditUsingId> getProformaInvoiceEditUsingId(
      Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    final response = await http.post(
        Uri.parse(Config().apiGetProformaInvoiceUsingId),
        body: body,
        headers: headers);

    print(response.body);
    ProformaInvoiceEditUsingId proformaInvoiceEditUsingId =
        proformaInvoiceEditUsingIdFromJson(response.body);

    print(proformaInvoiceEditUsingId);

    return proformaInvoiceEditUsingId;
  }

  Future deleteProformaProductUsingPid(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    final response = await http.post(
        Uri.parse(Config().apiDeleteProformaInvoiceProduct),
        body: body,
        headers: headers);

    print(response.body);

    return jsonDecode(response.body);
  }

  Future<int> insertProformaInvoiceProductToLocal(Map profromaProduct) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawInsert(
        "INSERT Into ProformaInvoiceProduct (id,uuid,product,pid,productId,productUomsId,quantity,basicPrice,price,taxTypeId,taxType,tax,discount,discountAmount,amount,cgst,sgst,igst,salesTax,subTotal)"
        " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
        [
          profromaProduct['id'],
          profromaProduct['uuid'],
          profromaProduct['product'],
          profromaProduct['pid'],
          profromaProduct['productId'],
          profromaProduct['productUomsId'],
          profromaProduct['quantity'],
          profromaProduct['basicPrice'],
          profromaProduct['price'],
          profromaProduct['taxTypeId'],
          profromaProduct['taxType'],
          profromaProduct['tax'],
          profromaProduct['discount'],
          profromaProduct['discountAmount'],
          profromaProduct['amount'],
          profromaProduct['cgst'],
          profromaProduct['sgst'],
          profromaProduct['igst'],
          profromaProduct['salesTax'],
          profromaProduct['subTotal']
        ]);

    return raw;
  }

  Future getProformaInvoiceFromLocal() async {
    Database db = await DatabaseHelper.instance.database;
    var raw = await db.rawQuery("SELECT * From ProformaInvoiceProduct");
    return raw;
  }

  Future<int> updateProformaInvoiceProductToLocal(Map profromaProdcut) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawUpdate("Update ProformaInvoiceProduct SET product='" +
        profromaProdcut['product'] +
        "',quantity='" +
        profromaProdcut['quantity'].toString() +
        "',pid='" +
        profromaProdcut['pid'].toString() +
        "'productId='" +
        profromaProdcut['productId'].toString() +
        "',productUomsId='" +
        profromaProdcut['productUomsId'].toString() +
        "',basicPrice='" +
        profromaProdcut['basicPrice'].toString() +
        "',price='" +
        profromaProdcut['price'].toString() +
        "',taxType='" +
        profromaProdcut['taxType'].toString() +
        "',tax='" +
        profromaProdcut['tax'].toString() +
        "',discount='" +
        profromaProdcut['discount'].toString() +
        "',discountAmount='" +
        profromaProdcut['discountAmount'].toString() +
        "',amount='" +
        profromaProdcut['amount'].toString() +
        "',cgst='" +
        profromaProdcut['cgst'].toString() +
        "',sgst='" +
        profromaProdcut['sgst'].toString() +
        "',igst='" +
        profromaProdcut['igst'].toString() +
        "',salesTax='" +
        profromaProdcut['salesTax'].toString() +
        "',subTotal='" +
        profromaProdcut['subTotal'].toString() +
        "' WHERE uuid='" +
        profromaProdcut['uuid'] +
        "'" +
        '');

    return raw;
  }

  Future deleteProductUsingUuidToLocal(String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db
        .rawDelete("DELETE FROM ProformaInvoiceProduct WHERE uuid=?", [uuid]);

    return raw;
  }

  Future deleteAllProductToLocal() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete("DELETE FROM ProformaInvoiceProduct");

    return raw;
  }

  Future insertProformaAdditionalChargesToLocal(
      Map<String, dynamic> additionalCharges) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawInsert(
        "INSERT Into ProformaInvoiceAdditionalCharges (id,uuid,additonal_charge_name,additional_charge_id,additional_charge_amount,additional_tax_type,additional_tax_percentage,additional_total_amount)"
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

  Future updateProformaAdditionalChargesToLocal(
      Map<String, dynamic> additionalCharges) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawUpdate(
        "Update ProformaInvoiceAdditionalCharges SET additonal_charge_name='" +
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

  Future getProformaAdditionalChargesFromLocal() async {
    Database db = await DatabaseHelper.instance.database;

    var raw =
        await db.rawQuery("SELECT * From ProformaInvoiceAdditionalCharges");

    return raw;
  }

  Future deleteAdditionalChargeApi(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    final response = await http.post(
        Uri.parse(Config().apiProformaInvoiceDeleteAdditionalChargeUsingId),
        body: body,
        headers: headers);

    print(response.body);

    return jsonDecode(response.body);
  }

  Future deleteProformaAdditionalChargesToLocal(String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete(
        'DELETE FROM ProformaInvoiceAdditionalCharges WHERE uuid = ?', [uuid]);

    return raw;
  }

  Future deleteAllProformaAdditionalChargesToLocal() async {
    Database db = await DatabaseHelper.instance.database;

    var raw =
        await db.rawDelete('DELETE FROM ProformaInvoiceAdditionalCharges');

    return raw;
  }
}
