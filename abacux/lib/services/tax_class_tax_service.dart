import 'dart:convert';

import 'package:abacux/config.dart';
import 'package:abacux/model/tax_class_tax_model.dart';
import 'package:http/http.dart' as http;

class TaxClassTaxService {
  static TaxClassTaxService instance;
  TaxClassTaxService._();

  static TaxClassTaxService getInstance() {
    if (instance == null) {
      instance = new TaxClassTaxService._();
    }
    return instance;
  }

  Future<TaxClassTaxType> taxClassesTaxList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiTaxClassTax), body: body)
        .then((http.Response response) {
      print(response.body);
      return taxClassTaxTypeFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addTaxClasses(Map body) async {
    print(body);
    return await http
        .post(Uri.parse(Config().apiAddTaxClassTax), body: body)
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }

  Future editTaxClasses(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditTaxClassTax), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteTaxClasses(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiDeleteTaxClassTax),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
