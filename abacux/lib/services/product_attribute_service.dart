import 'dart:convert';

import 'package:abacux/config.dart';
import 'package:abacux/model/product_attributes_model.dart';
import 'package:http/http.dart' as http;

class ProductAttributeService {
  static ProductAttributeService instance;
  ProductAttributeService._();

  static ProductAttributeService getInstance() {
    if (instance == null) {
      instance = new ProductAttributeService._();
    }
    return instance;
  }

  Future<ProductAttributes> productAttributeList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiGetProductAttributesList), body: body)
        .then((http.Response response) {
      print(response.body);
      return productAttributesFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addProductAttribute(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAddProductAttributes), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future editProductAttribute(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditProductAttributes), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteProductAttribute(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiDeleteProductAttributes),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
