import 'package:abacux/helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../config.dart';
import 'package:http/http.dart' as http;

class CreditNoteService {
  static CreditNoteService instance;

  CreditNoteService._();

  static CreditNoteService getInstance() {
    if (instance == null) {
      instance = new CreditNoteService._();
    }
    return instance;
  }

  // Product Local CRUD operation - Start

  Future<int> insertCreditNoteProductFromLocal(
      Map<String, dynamic> purchaseBillProduct) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawInsert(
        "INSERT Into CreditNotesProduct (id,uuid,product,pid,productId,productUomsId,quantity,basicPrice,price,taxTypeId,taxType,tax,discount,discountAmount,amount,cgst,sgst,igst,salesTax,subTotal)"
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

  Future getCreditNoteProductFromLocal() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = db.rawQuery("SELECT * From CreditNotesProduct");

    return raw;
  }

  Future updateCreditNoteProductToLocal(
      Map<String, dynamic> purchaseBillProduct, String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    print(purchaseBillProduct);

    var raw = await db.rawUpdate("Update CreditNotesProduct SET product='" +
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

  Future deleteCreditNoteProductUsingId(String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db
        .rawDelete('DELETE FROM CreditNotesProduct WHERE uuid = ?', [uuid]);

    return raw;
  }

  Future deleteAllCreditNoteProduct() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete(
      'DELETE FROM CreditNotesProduct',
    );

    return raw;
  }

  // Product Local CRUD operation - End
}
