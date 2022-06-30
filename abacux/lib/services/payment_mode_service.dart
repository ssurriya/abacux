import 'dart:convert';

import 'package:abacux/config.dart';
import 'package:abacux/model/payment_mode.dart';

import 'package:http/http.dart' as http;

class PaymentModeService {
  static PaymentModeService instance;
  PaymentModeService._();

  static PaymentModeService getInstance() {
    if (instance == null) {
      instance = new PaymentModeService._();
    }
    return instance;
  }

  Future<Paymentmode> paymentModeList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiGetPaymentModeList), body: body)
        .then((http.Response response) {
      print(response.body);
      return paymentmodeFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addPaymentMode(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAddPaymentAttributes), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future editPaymentMode(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditPaymentAttributes), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deletePaymentMode(Map body) async {
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
