import 'dart:convert';
import 'dart:io';
import 'package:abacux/config.dart';
import 'package:abacux/model/Product_model.dart';
import 'package:abacux/model/expense_accounts.dart';
import 'package:abacux/model/income_accounts_model.dart';
import 'package:abacux/model/inventory_accounts.dart';
import 'package:abacux/model/product_groups_model.dart';
import 'package:abacux/model/warehouse_bin_model.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static ProductService instance;

  ProductService._();

  static ProductService getInstance() {
    if (instance == null) {
      instance = new ProductService._();
    }

    return instance;
  }

  Future<List<Product>> ProductList(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Uri.parse(Config().apiGetProduct), body: body, headers: headers)
        .then((http.Response response) {
      print(response.body);
      final items =
          json.decode(response.body)['products'].cast<Map<String, dynamic>>();

      print(items);

      List<Product> products = items.map<Product>((json) {
        return Product.fromJson(json);
      }).toList();
      return products;
    });
  }

  Future insertNewProduct(Map body) async {
    final response =
        await http.post(Uri.parse(Config().apiAddProduct), body: body);
    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    } else {
      print(result);
    }
  }

  Future editProduct(Map body) async {
    final response =
        await http.post(Uri.parse(Config().apiEditProduct), body: body);
    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    } else {
      print(result);
    }
  }

  Future deleteProduct(
    String id,
    String user_id,
    String token,
  ) async {
    final response =
        await http.post(Uri.parse(Config().apiProductDelete), body: {
      "id": id.toString(),
      "user_id": user_id.toString(),
      'token': token.toString(),
    });
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    } else {
      print("Errors:" + result);
    }
  }

  Future<ProductGroups> getProductGroups(Map body) async {
    return await http
        .post(Uri.parse(Config().apiProductGroups), body: body)
        .then((response) {
      return productGroupsFromJson(response.body);
    }).catchError((onError) {});
  }

  // Future<ExpenseAccounts> getExpenseAccounts(Map body) async {
  //   return await http
  //       .post(Uri.parse(Config().apiExpenseAccounts), body: body)
  //       .then((response) {
  //     print(response.body);
  //     return expenseAccountsFromJson(response.body);
  //   }).catchError((onError) {});
  // }

  Future<ExpenseAccounts> getExpenseAccounts(Map body) async {
    return await http
        .post(Uri.parse(Config().apiExpenseAccounts), body: body)
        .then((response) {
      if (response.statusCode == 200)
        return expenseAccountsFromJson(response.body);
    }).catchError((onError) {});
  }

  Future<IncomeAccounts> getIncomeAccounts(Map body) async {
    return await http
        .post(Uri.parse(Config().apiIncomeAccounts), body: body)
        .then((response) {
      return incomeAccountsFromJson(response.body);
    }).catchError((onError) {});
  }

  Future<InventoryAccounts> getInventoryAccount(Map body) async {
    return await http
        .post(Uri.parse(Config().apiInventoryAccount), body: body)
        .then((response) {
      return inventoryAccountsFromJson(response.body);
    }).catchError((onError) {});
  }

  Future<WarehouseBins> getWarehouseBin(Map body) async {
    return await http
        .post(Uri.parse(Config().apiWarehouseBin), body: body)
        .then((response) {
      return warehouseBinsFromJson(response.body);
    }).catchError((onError) {});
  }

  Future<List<dynamic>> getGstTreatment(Map body) async {
    return await http
        .post(Uri.parse(Config().apiWarehouseBin), body: body)
        .then((response) {
      print(json.decode(response.body));
      List<dynamic> gstTreatments = [];
      json.decode(response.body).map((e) {
        gstTreatments.add(json.decode(e));
      }).toList();
      return gstTreatments;
    }).catchError((onError) {});
  }
}
