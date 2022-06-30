import 'package:abacux/model/purchase_payments_model.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class PurchasePaymentService {
  static PurchasePaymentService instance;

  PurchasePaymentService._();

  static PurchasePaymentService getInstance() {
    if (instance == null) {
      instance = new PurchasePaymentService._();
    }
    return instance;
  }

  Future<PurchasePayments> getPurchasePaymentList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiPurchasePaymentList), body: body)
        .then((http.Response response) {
      print(response.body);
      return purchasePaymentsFromJson(response.body);
    });
  }
}
