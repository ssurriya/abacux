import 'dart:convert';
import 'dart:io';
import 'package:abacux/helper/database_helper.dart';
import 'package:abacux/model/Product_model.dart';
import 'package:abacux/model/bin.dart';
import 'package:abacux/model/purchase_order_edit_using_id.dart';
import 'package:abacux/model/purchase_order_model.dart';
import 'package:abacux/model/taxType_model.dart';
import 'package:abacux/model/vendor_model.dart';
import 'package:sqflite/sqflite.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class PurchaseOrderService {
  static PurchaseOrderService instance;

  PurchaseOrderService._();

  static PurchaseOrderService getInstance() {
    if (instance == null) {
      instance = new PurchaseOrderService._();
    }
    return instance;
  }

  String invoiceNo;
  Vendor vendor;
  DateTime dateTime;
  PurchaseOrderEditUsingId purchaseOrderEditUsingId;
  List additionalChargeIds;
  String discountInAmt, discountInPercentage;

  setInvoiceNo(String invoiceNo) {
    this.invoiceNo = invoiceNo;
  }

  setVendor(Vendor vendor) {
    this.vendor = vendor;
  }

  setDateTime(DateTime dateTime) {
    this.dateTime = dateTime;
  }

  setPurchaseOrderEditUsingId(
      PurchaseOrderEditUsingId purchaseOrderEditUsingId) {
    this.purchaseOrderEditUsingId = purchaseOrderEditUsingId;
  }

  setAdditionalChargeIds(List additionalChargeIds) {
    this.additionalChargeIds = additionalChargeIds;
  }

  setDiscountInAmt(String discountInAmt) {
    this.discountInAmt = discountInAmt;
  }

  setDiscountInPercenatge(String discountInPercentage) {
    this.discountInPercentage = discountInPercentage;
  }

  String get getInvoiceNo => this.getInvoiceNo;

  Vendor get getVendor => this.vendor;

  DateTime get getDateTime => this.dateTime;

  PurchaseOrderEditUsingId get getPurchaseOrderEditUsingIdValue =>
      this.purchaseOrderEditUsingId;

  List get getAdditionalChargeIds => this.additionalChargeIds;

  String get getDiscountInAmt => this.discountInAmt;

  String get getDiscountInPercentage => this.discountInPercentage;

  Future<List<PurchaseOrder>> getPurchaseOrderList(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };
    return await http
        .post(Config().apiGetPurchaseOrderList, body: body, headers: headers)
        .then((http.Response response) {
      print(response.body);
      List<PurchaseOrder> purchaseOrders = [];
      (json.decode(response.body)['listdata'] as List).map((e) {
        purchaseOrders.add(PurchaseOrder.fromJson(e));
      }).toList();
      return purchaseOrders;
    });
  }

  Future<int> getPurchaseOrderNumber(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Config().apiGetPurchaseOrderNo, body: body, headers: headers)
        .then((http.Response response) {
      return json.decode(response.body)['po_no'];
    });
  }

  Future<List<Product>> getPurchaseProduct(Map body) async {
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

  Future<List<Bin>> getBin(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Config().apiGetBin, body: body, headers: headers)
        .then((http.Response response) {
      final items =
          json.decode(response.body)['binname'].cast<Map<String, dynamic>>();

      List<Bin> bins = items.map<Bin>((json) {
        return Bin.fromJson(json);
      }).toList();
      return bins;
    });
  }

  Future<List<TaxType>> getTaxType(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Config().apiGetTaxType, body: body, headers: headers)
        .then((http.Response response) {
      final items =
          json.decode(response.body)['taxtype'].cast<Map<String, dynamic>>();

      List<TaxType> taxTypes = items.map<TaxType>((json) {
        return TaxType.fromJson(json);
      }).toList();
      return taxTypes;
    });
  }

  Future postPurchaseOrderStore(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    print(body);

    final response = await http.post(Uri.parse(Config().apiPurchaseOrderStore),
        body: body, headers: headers);

    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    }
  }

  Future deletePurchaseOrderProductUsingId(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    print(body);

    final response = await http.post(
        Uri.parse(Config().apiDeletePurchaseOrderProduct),
        body: body,
        headers: headers);

    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    }
  }

  Future updatePurchaseOrderStore(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    print(body);

    final response = await http.post(
        Uri.parse(Config().apiUpdatePurchaseOrderStore),
        body: body,
        headers: headers);

    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    }
  }

  Future<PurchaseOrderEditUsingId> getPurchaseOrderEditUsingId(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    print(body);

    final response = await http.post(
        Uri.parse(Config().apiGetPurchaseOrderUsingId),
        body: body,
        headers: headers);

    print(response.body);

    PurchaseOrderEditUsingId purchaseOrderEditUsingId =
        purchaseOrderEditUsingIdFromJson(response.body);

    return purchaseOrderEditUsingId;
  }

  Future deletePurchaseOrderApi(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    print(body);

    final response = await http.post(Uri.parse(Config().apiDeletePurchaseOrder),
        body: body, headers: headers);

    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    }
  }

  Future<int> insertPurchaseProductFromLocal(
      Map<String, dynamic> purchaseProduct) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawInsert(
        "INSERT Into PurchaseProduct (id,uuid,product,pid,productId,productUomsId,quantity,basicPrice,price,taxTypeId,taxType,tax,discount,discountAmount,amount,cgst,sgst,igst,salesTax,subTotal)"
        " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
        [
          purchaseProduct['id'],
          purchaseProduct['uuid'],
          purchaseProduct['product'],
          purchaseProduct['pid'],
          purchaseProduct['productId'],
          purchaseProduct['productUomsId'],
          purchaseProduct['quantity'],
          purchaseProduct['basicPrice'],
          purchaseProduct['price'],
          purchaseProduct['taxTypeId'],
          purchaseProduct['taxType'],
          purchaseProduct['tax'],
          purchaseProduct['discount'],
          purchaseProduct['discountAmount'],
          purchaseProduct['amount'],
          purchaseProduct['cgst'],
          purchaseProduct['sgst'],
          purchaseProduct['igst'],
          purchaseProduct['salesTax'],
          purchaseProduct['subTotal']
        ]);

    return raw;
  }

  Future getPurchaseProductFromLocal() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = db.rawQuery("SELECT * From PurchaseProduct");

    return raw;
  }

  Future updatePurchaseProductToLocal(
      Map<String, dynamic> purchaseProduct, String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    print(purchaseProduct);

    var raw = await db.rawUpdate("Update PurchaseProduct SET product='" +
        purchaseProduct['product'] +
        "',pid='" +
        purchaseProduct['pid'].toString() +
        "',quantity='" +
        purchaseProduct['quantity'].toString() +
        "',productId='" +
        purchaseProduct['productId'].toString() +
        "',basicPrice='" +
        purchaseProduct['basicPrice'].toString() +
        "',price='" +
        purchaseProduct['price'].toString() +
        "',taxType='" +
        purchaseProduct['taxType'].toString() +
        "',tax='" +
        purchaseProduct['tax'].toString() +
        "',discount='" +
        purchaseProduct['discount'].toString() +
        "',discountAmount='" +
        purchaseProduct['discountAmount'].toString() +
        "',amount='" +
        purchaseProduct['amount'].toString() +
        "',cgst='" +
        purchaseProduct['cgst'].toString() +
        "',sgst='" +
        purchaseProduct['sgst'].toString() +
        "',igst='" +
        purchaseProduct['igst'].toString() +
        "',salesTax='" +
        purchaseProduct['salesTax'].toString() +
        "',subTotal='" +
        purchaseProduct['subTotal'].toString() +
        "' WHERE uuid='" +
        purchaseProduct['uuid'] +
        "'" +
        '');

    return raw;
  }

  Future deletePurchaseProductUsingId(String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db
        .rawDelete('DELETE FROM PurchaseProduct WHERE uuid = ?', [uuid]);

    return raw;
  }

  Future deleteAllPurchaseProduct() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete(
      'DELETE FROM PurchaseProduct',
    );

    return raw;
  }

  Future insertPurchaseAdditionalCharges(
      Map<String, dynamic> purchaseAdditionalCharges) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawInsert(
        "INSERT Into PurchaseAdditionalCharges (id,uuid,additionalCharge,additionalChargeId,amount,taxType,tax,totalAmount)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [
          purchaseAdditionalCharges['id'],
          purchaseAdditionalCharges['uuid'],
          purchaseAdditionalCharges['additionalCharge'],
          purchaseAdditionalCharges['additionalChargeId'],
          purchaseAdditionalCharges['amount'],
          purchaseAdditionalCharges['taxType'],
          purchaseAdditionalCharges['tax'],
          purchaseAdditionalCharges['totalAmount'],
        ]);

    return raw;
  }

  Future updatePurchaseAdditionalCharges(
      Map<String, dynamic> purchaseAdditionalCharges) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawUpdate(
        "Update PurchaseAdditionalCharges SET additionalCharge='" +
            purchaseAdditionalCharges['additionalCharge'] +
            "',additionalChargeId='" +
            purchaseAdditionalCharges['additionalChargeId'].toString() +
            "',amount='" +
            purchaseAdditionalCharges['amount'].toString() +
            "',taxType='" +
            purchaseAdditionalCharges['taxType'].toString() +
            "',tax='" +
            purchaseAdditionalCharges['tax'].toString() +
            "',totalAmount='" +
            purchaseAdditionalCharges['totalAmount'].toString() +
            "' WHERE uuid='" +
            purchaseAdditionalCharges['uuid'] +
            "'" +
            '');

    return raw;
  }

  Future deleteAdditionalChargeApi(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    print(body);

    final response = await http.post(
        Uri.parse(Config().apiPurchaseorderDeleteAdditionalChargeUsingId),
        body: body,
        headers: headers);

    print(response.body);

    return jsonDecode(response.body);
  }

  Future getPurchaseAdditionalFromLocal() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawQuery("SELECT * From PurchaseAdditionalCharges");

    return raw;
  }

  Future deletePurchaseAdditionalCharges(String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete(
        'DELETE FROM PurchaseAdditionalCharges WHERE uuid = ?', [uuid]);

    return raw;
  }

  Future deleteAllPurchaseAdditionalCharges() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete('DELETE FROM PurchaseAdditionalCharges');

    return raw;
  }
}
