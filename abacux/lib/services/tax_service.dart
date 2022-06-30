import 'dart:convert';

import 'package:abacux/config.dart';
import 'package:abacux/model/tax_mode.dart';
import 'package:http/http.dart' as http;

class TaxService {
  static TaxService instance;
  TaxService._();

  static TaxService getInstance() {
    if (instance == null) {
      instance = new TaxService._();
    }
    return instance;
  }

  Future<Tax> getTaxList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiTax), body: body)
        .then((http.Response response) {
      return taxFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addTax(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAddTax), body: body)
        .then((http.Response response) {
      ;
      return json.decode(response.body);
    });
  }

  Future editTax(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditTax), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteTax(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiDeleteTax),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
