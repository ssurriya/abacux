import 'dart:convert';

import 'package:abacux/config.dart';
import 'package:abacux/model/sale_invoice_setting_model.dart';
import 'package:http/http.dart' as http;

class SaleInvoiceSettingService {
  static SaleInvoiceSettingService instance;
  SaleInvoiceSettingService._();

  static SaleInvoiceSettingService getInstance() {
    if (instance == null) {
      instance = new SaleInvoiceSettingService._();
    }
    return instance;
  }

  Future<SaleInvoiceSettingList> saleInvoiceSettingList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiGetSaleInvoiceSettings), body: body)
        .then((http.Response response) {
      return saleInvoiceSettingListFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addSaleInvoiceSetting(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAddSaleInvoiceSettings), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future editSaleInvoiceSetting(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditSaleInvoiceSettings), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteSaleInvoiceSetting(Map body) async {
    return await http
        .post(Uri.parse(Config().apiDeleteSaleInvoiceSettings), body: body)
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
