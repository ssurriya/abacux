import 'dart:convert';

import 'package:abacux/config.dart';
import 'package:abacux/model/quotation_setting_model.dart';
import 'package:http/http.dart' as http;

class QuotationSettingService {
  static QuotationSettingService instance;
  QuotationSettingService._();

  static QuotationSettingService getInstance() {
    if (instance == null) {
      instance = new QuotationSettingService._();
    }
    return instance;
  }

  Future<QuotationSettingList> quotationSettingList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiGetQuotationSettings), body: body)
        .then((http.Response response) {
      return quotationSettingListFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addQuotationSetting(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAddQuotationSettings), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future editQuotationSetting(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditQuotationSettings), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteQuotationSetting(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiDeleteQuotationSettings),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
