import 'dart:convert';
import 'package:abacux/config.dart';
import 'package:http/http.dart' as http;

import '../model/tax_classes_model.dart';

class TaxClassesService {
  static TaxClassesService instance;
  TaxClassesService._();

  static TaxClassesService getInstance() {
    if (instance == null) {
      instance = new TaxClassesService._();
    }
    return instance;
  }

  Future<TaxClasses> TaxClassesList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiTaxclasses), body: body)
        .then((http.Response response) {
      print(response.body);
      return taxClassesFromMap(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addTaxClasses(Map body) async {
    print(body);
    return await http
        .post(Uri.parse(Config().apiAddTaxclasses), body: body)
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }

  Future editTaxClasses(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditTaxclasses), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteTaxClasses(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiDeleteTaxclasses),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
