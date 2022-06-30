import 'dart:convert';
import 'dart:io';
import 'package:abacux/config.dart';
import 'package:abacux/helper/database_helper.dart';
import 'package:abacux/model/Product_model.dart';
import 'package:abacux/model/customer_model.dart';
import 'package:abacux/model/estimate_edit_using_id.dart';
import 'package:abacux/model/estimate_model.dart';
import 'package:abacux/model/taxType_model.dart';
import 'package:abacux/model/vendor_model.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class EstimateService {
  static EstimateService instance;
  EstimateService._();

  static EstimateService getInstance() {
    if (instance == null) {
      instance = new EstimateService._();
    }
    return instance;
  }

  Customer customer;
  DateTime dateTime;
  EstimateEditUsingId estimateEditUsingId;
  List additionalChargeIds;
  String discountInAmt;
  String discountInPercentage;

  setCustomer(Customer customer) {
    this.customer = customer;
  }

  setDateTime(DateTime dateTime) {
    this.dateTime = dateTime;
  }

  setEstimateEditUsingId(EstimateEditUsingId estimateEditUsingId) {
    this.estimateEditUsingId = estimateEditUsingId;
  }

  setAdditionalChargeId(List additionalChargeIds) {
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

  EstimateEditUsingId get getEstimateEditUsingId => this.estimateEditUsingId;

  List get getAdditionalChargeId => this.additionalChargeIds;

  String get getDiscountInAmt => this.discountInAmt;

  String get getDiscountInPercentage => this.discountInPercentage;

  Future<List<Estimate>> estimateList(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Uri.parse(Config().apiGetEstimate), body: body, headers: headers)
        .then((http.Response response) {
      //Decode the Response body convert to Customer model

      print(response.body);

      final items =
          json.decode(response.body)['listdata'].cast<Map<String, dynamic>>();

      print(items);
      List<Estimate> estimate = items.map<Estimate>((json) {
        return Estimate.fromJson(json);
      }).toList();
      return estimate;
    });
  }

  Future<EstimateEditUsingId> getEstimateListUsingId(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Uri.parse(Config().apiGetEstimateUsingId),
            body: body, headers: headers)
        .then((http.Response response) {
      //Decode the Response body convert to Customer model

      print(response.body);

      EstimateEditUsingId estimateEditUsingId =
          estimateEditUsingIdFromJson(response.body);
      return estimateEditUsingId;
    });
  }

  Future deleteProductUsingPid(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Uri.parse(Config().apiDeleteEstimateProduct),
            body: body, headers: headers)
        .then((http.Response response) {
      //Decode the Response body convert to Customer model

      print(response.body);

      return jsonDecode(response.body);
    });
  }

  Future<int> getEstimateNumber(Map body) async {
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

  Future<List<Product>> getEstimateProduct(Map body) async {
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

  Future getEstimateSettings(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Config().apiEstimateSettings, body: body, headers: headers)
        .then((http.Response response) {
      return json.decode(response.body)['get_estimate_settings'];
    });
  }

  Future getEstimateNo(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Config().apiGetEstimateNo, body: body, headers: headers)
        .then((http.Response response) {
      print(response.body);
      return json.decode(response.body)['estimate_no'];
    });
  }

  Future postEstimateStore(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    print(body);

    return await http
        .post(Uri.parse(Config().apiEstimateStore),
            body: body, headers: headers)
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }

  Future updateEstimateStore(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    print(body);

    final response = await http.post(Uri.parse(Config().apiUpdateEstimateStore),
        body: body, headers: headers);

    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    }
  }

  Future deleteAdditionalChargeApi(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    print(body);

    final response = await http.post(
        Uri.parse(Config().apiEstimateDeleteAdditionalChargeUsingId),
        body: body,
        headers: headers);

    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    }
  }

  Future deleteEstimateApi(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    print(body);

    final response = await http.post(Uri.parse(Config().apiDeleteEstimate),
        body: body, headers: headers);

    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    }
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

  Future<int> insertEstimateProductFromLocal(
      Map<String, dynamic> estimateProduct) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawInsert(
        "INSERT Into EstimateProduct (id,uuid,product,pid,productId,productUomsId,quantity,basicPrice,price,taxType,tax,discount,discountAmount,amount,cgst,sgst,igst,salesTax,subTotal)"
        " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
        [
          estimateProduct['id'],
          estimateProduct['uuid'],
          estimateProduct['product'],
          estimateProduct['pid'],
          estimateProduct['productId'],
          estimateProduct['productUomsId'],
          estimateProduct['quantity'],
          estimateProduct['basicPrice'],
          estimateProduct['price'],
          estimateProduct['taxType'],
          estimateProduct['tax'],
          estimateProduct['discount'],
          estimateProduct['discountAmount'],
          estimateProduct['amount'],
          estimateProduct['cgst'],
          estimateProduct['sgst'],
          estimateProduct['igst'],
          estimateProduct['salesTax'],
          estimateProduct['subTotal']
        ]);

    return raw;
  }

  Future getEstimateProductFromLocal() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = db.rawQuery("SELECT * From EstimateProduct");

    return raw;
  }

  Future updateEstimateProductToLocal(
      Map<String, dynamic> estimateProduct, String uuid) async {
    Database db = await DatabaseHelper.instance.database;
    var raw = await db.rawUpdate("Update EstimateProduct SET product='" +
        estimateProduct['product'] +
        "',pid='" +
        estimateProduct['pid'].toString() +
        "'productId='" +
        estimateProduct['productId'].toString() +
        "',productUomsId='" +
        estimateProduct['productUomsId'].toString() +
        "',quantity='" +
        estimateProduct['quantity'].toString() +
        "',basicPrice='" +
        estimateProduct['basicPrice'].toString() +
        "',price='" +
        estimateProduct['price'].toString() +
        "',taxType='" +
        estimateProduct['taxType'].toString() +
        "',tax='" +
        estimateProduct['tax'].toString() +
        "',discount='" +
        estimateProduct['discount'].toString() +
        "',estimateProduct='" +
        estimateProduct['discountAmount'].toString() +
        "',amount='" +
        estimateProduct['amount'].toString() +
        "',cgst='" +
        estimateProduct['cgst'].toString() +
        "',sgst='" +
        estimateProduct['sgst'].toString() +
        "',igst='" +
        estimateProduct['igst'].toString() +
        "',salesTax='" +
        estimateProduct['salesTax'].toString() +
        "',subTotal='" +
        estimateProduct['subTotal'].toString() +
        "' WHERE uuid='" +
        estimateProduct['uuid'] +
        "'" +
        '');

    return raw;
  }

  Future deleteEstimateProductUsingId(String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db
        .rawDelete('DELETE FROM EstimateProduct WHERE uuid = ?', [uuid]);

    return raw;
  }

  Future deleteAllEstimateProduct() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete(
      'DELETE FROM EstimateProduct',
    );

    return raw;
  }

  Future insertEstimateAdditionalCharges(
      Map<String, dynamic> estimateAdditionalCharges) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawInsert(
        "INSERT Into EstimateAdditionalCharges (id,uuid,additionalChargeId,additionalCharge,amount,taxType,tax,totalAmount)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [
          estimateAdditionalCharges['id'],
          estimateAdditionalCharges['uuid'],
          estimateAdditionalCharges['additionalChargeId'],
          estimateAdditionalCharges['additionalCharge'],
          estimateAdditionalCharges['amount'],
          estimateAdditionalCharges['taxType'],
          estimateAdditionalCharges['tax'],
          estimateAdditionalCharges['totalAmount'],
        ]);

    return raw;
  }

  Future updateEstimateAdditionalCharges(
      Map<String, dynamic> estimateAdditionalCharges) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawUpdate(
        "Update EstimateAdditionalCharges SET additionalCharge='" +
            estimateAdditionalCharges['additionalCharge'] +
            "',additionalChargeId='" +
            estimateAdditionalCharges['additionalChargeId'].toString() +
            "',amount='" +
            estimateAdditionalCharges['amount'].toString() +
            "',taxType='" +
            estimateAdditionalCharges['taxType'].toString() +
            "',tax='" +
            estimateAdditionalCharges['tax'].toString() +
            "',totalAmount='" +
            estimateAdditionalCharges['totalAmount'].toString() +
            "' WHERE uuid='" +
            estimateAdditionalCharges['uuid'] +
            "'" +
            '');

    return raw;
  }

  Future getEstimateAdditionalFromLocal() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawQuery("SELECT * From EstimateAdditionalCharges");
    return raw;
  }

  Future deleteEstimateAdditionalCharges(String uuid) async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete(
        'DELETE FROM EstimateAdditionalCharges WHERE uuid = ?', [uuid]);

    return raw;
  }

  Future deleteAllEstimateAdditionalCharges() async {
    Database db = await DatabaseHelper.instance.database;

    var raw = await db.rawDelete('DELETE FROM EstimateAdditionalCharges');

    return raw;
  }
}
