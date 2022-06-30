import 'dart:convert';

import 'package:abacux/config.dart';
import 'package:abacux/model/payment_mode_attributes_model.dart';
import 'package:http/http.dart' as http;

class PaymentAttributesService {
  static PaymentAttributesService instance;
  PaymentAttributesService._();

  static PaymentAttributesService getInstance() {
    if (instance == null) {
      instance = new PaymentAttributesService._();
    }
    return instance;
  }

  Future<PaymentModeAttributes> paymentAttributesList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiGetPaymentAttributeList), body: body)
        .then((http.Response response) {
      print(response.body);
      return paymentModeAttributesFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addPaymentAttributes(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAddPaymentAttributes), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future editPaymentAttributes(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditPaymentAttributes), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deletePaymentAttributes(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiDeletePaymentAttributes),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
