import 'dart:convert';

import 'package:abacux/config.dart';
import 'package:abacux/model/financial_year_model.dart';
import 'package:http/http.dart' as http;

class FinancialYearService {
  static FinancialYearService instance;
  FinancialYearService._();

  static FinancialYearService getInstance() {
    if (instance == null) {
      instance = new FinancialYearService._();
    }
    return instance;
  }

  Future<FinancialYear> financialYearList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiGetFinancialYearList), body: body)
        .then((http.Response response) {
      print(response.body);
      return financialYearFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addFinancialYear(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAddFinancialYear), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future editFinancialYear(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditFinancialYear), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteFinancialYear(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiDeleteFinancialYear),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
