import 'package:abacux/helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class PurchaseBillService {
  static PurchaseBillService instance;

  PurchaseBillService._();

  static PurchaseBillService getInstance() {
    if (instance == null) {
      instance = new PurchaseBillService._();
    }
    return instance;
  }

  // Product Local CRUD operation - Start

  Future<int> insertPurchaseBillProductFromLocal(
      Map<String, dynamic> purchaseBillProduct) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawInsert(
        "INSERT Into PurchaseBillProduct (id,uuid,product,pid,productId,productUomsId,quantity,basicPrice,price,taxTypeId,taxType,tax,discount,discountAmount,amount,cgst,sgst,igst,salesTax,subTotal)"
        " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
        [
          purchaseBillProduct['id'],
          purchaseBillProduct['uuid'],
          purchaseBillProduct['product'],
          purchaseBillProduct['pid'],
          purchaseBillProduct['productId'],
          purchaseBillProduct['productUomsId'],
          purchaseBillProduct['quantity'],
          purchaseBillProduct['basicPrice'],
          purchaseBillProduct['price'],
          purchaseBillProduct['taxTypeId'],
          purchaseBillProduct['taxType'],
          purchaseBillProduct['tax'],
          purchaseBillProduct['discount'],
          purchaseBillProduct['discountAmount'],
          purchaseBillProduct['amount'],
          purchaseBillProduct['cgst'],
          purchaseBillProduct['sgst'],
          purchaseBillProduct['igst'],
          purchaseBillProduct['salesTax'],
          purchaseBillProduct['subTotal']
        ]);

    return raw;
  }

  Future getPurchaseBillProductFromLocal() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = db.rawQuery("SELECT * From PurchaseBillProduct");

    return raw;
  }

  Future updatePurchaseBillProductToLocal(
      Map<String, dynamic> purchaseBillProduct, String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    print(purchaseBillProduct);

    var raw = await db.rawUpdate("Update PurchaseBillProduct SET product='" +
        purchaseBillProduct['product'] +
        "',pid='" +
        purchaseBillProduct['pid'].toString() +
        "',quantity='" +
        purchaseBillProduct['quantity'].toString() +
        "',productId='" +
        purchaseBillProduct['productId'].toString() +
        "',basicPrice='" +
        purchaseBillProduct['basicPrice'].toString() +
        "',price='" +
        purchaseBillProduct['price'].toString() +
        "',taxType='" +
        purchaseBillProduct['taxType'].toString() +
        "',tax='" +
        purchaseBillProduct['tax'].toString() +
        "',discount='" +
        purchaseBillProduct['discount'].toString() +
        "',discountAmount='" +
        purchaseBillProduct['discountAmount'].toString() +
        "',amount='" +
        purchaseBillProduct['amount'].toString() +
        "',cgst='" +
        purchaseBillProduct['cgst'].toString() +
        "',sgst='" +
        purchaseBillProduct['sgst'].toString() +
        "',igst='" +
        purchaseBillProduct['igst'].toString() +
        "',salesTax='" +
        purchaseBillProduct['salesTax'].toString() +
        "',subTotal='" +
        purchaseBillProduct['subTotal'].toString() +
        "' WHERE uuid='" +
        purchaseBillProduct['uuid'] +
        "'" +
        '');

    return raw;
  }

  Future deletePurchaseBillProductUsingId(String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db
        .rawDelete('DELETE FROM PurchaseBillProduct WHERE uuid = ?', [uuid]);

    return raw;
  }

  Future deleteAllPurchaseBillProduct() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete(
      'DELETE FROM PurchaseBillProduct',
    );

    return raw;
  }

  // Product Local CRUD operation - End

  // Additional Charge Local CRUD operation - Start

  Future insertPurchaseBillAdditionalCharges(
      Map<String, dynamic> purchaseBillAdditionalCharges) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawInsert(
        "INSERT Into PurchaseBillAdditionalCharge (id,uuid,additionalChargeId,additionalCharge,amount,taxType,tax,totalAmount)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [
          purchaseBillAdditionalCharges['id'],
          purchaseBillAdditionalCharges['uuid'],
          purchaseBillAdditionalCharges['additionalChargeId'],
          purchaseBillAdditionalCharges['additionalCharge'],
          purchaseBillAdditionalCharges['amount'],
          purchaseBillAdditionalCharges['taxType'],
          purchaseBillAdditionalCharges['tax'],
          purchaseBillAdditionalCharges['totalAmount'],
        ]);

    return raw;
  }

  Future updatePurchaseBillAdditionalCharges(
      Map<String, dynamic> purchaseBillAdditionalCharges) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawUpdate(
        "Update PurchaseBillAdditionalCharge SET additionalCharge='" +
            purchaseBillAdditionalCharges['additionalCharge'] +
            "',additionalChargeId='" +
            purchaseBillAdditionalCharges['additionalChargeId'].toString() +
            "',amount='" +
            purchaseBillAdditionalCharges['amount'].toString() +
            "',taxType='" +
            purchaseBillAdditionalCharges['taxType'].toString() +
            "',tax='" +
            purchaseBillAdditionalCharges['tax'].toString() +
            "',totalAmount='" +
            purchaseBillAdditionalCharges['totalAmount'].toString() +
            "' WHERE uuid='" +
            purchaseBillAdditionalCharges['uuid'] +
            "'" +
            '');

    return raw;
  }

  Future getPurchaseBillAdditionalFromLocal() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawQuery("SELECT * From PurchaseBillAdditionalCharge");
    return raw;
  }

  Future deletePurchaseBillAdditionalCharges(String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete(
        'DELETE FROM PurchaseBillAdditionalCharge WHERE uuid = ?', [uuid]);

    return raw;
  }

  Future deleteAllPurchaseBillAdditionalCharges() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete('DELETE FROM PurchaseBillAdditionalCharge');

    return raw;
  }

  // Additional Charge Local CRUD operation - End
}
