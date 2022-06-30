import 'dart:convert';

import 'package:abacux/config.dart';
import 'package:abacux/model/product_groups_model.dart';
import 'package:http/http.dart' as http;

class ProductGroupService {
  static ProductGroupService instance;
  ProductGroupService._();

  static ProductGroupService getInstance() {
    if (instance == null) {
      instance = new ProductGroupService._();
    }
    return instance;
  }

  Future<ProductGroups> getProductGroups(Map body) async {
    return await http
        .post(Uri.parse(Config().apiProductGroups), body: body)
        .then((response) {
      return productGroupsFromJson(response.body);
    }).catchError((onError) {});
  }

  Future addProductGroup(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAddProductGroups), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future editProductGroup(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditProductGroups), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteProductGroup(Map body) async {
    return await http
        .post(Uri.parse(Config().apiDeleteProductGroups), body: body)
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
