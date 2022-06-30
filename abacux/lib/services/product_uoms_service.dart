import 'dart:convert';
import 'package:abacux/config.dart';
import 'package:http/http.dart' as http;

import '../model/product_unoms_model.dart';

class ProductUomsService {
  static ProductUomsService instance;
  ProductUomsService._();

  static ProductUomsService getInstance() {
    if (instance == null) {
      instance = new ProductUomsService._();
    }
    return instance;
  }

  Future<ProductUnoms> productUomsList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiGetProductUnomsList), body: body)
        .then((http.Response response) {
      return productUnomsFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addProductUoms(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAddProductUnoms), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future editProductUoms(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditProductUnoms), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteProductUoms(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiDeleteProductUnoms),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
