import 'dart:convert';
import 'package:abacux/config.dart';
import 'package:http/http.dart' as http;
import '../model/additional_charge_model.dart';


class AdditionalChargesService {
  static AdditionalChargesService instance;
  AdditionalChargesService._();

  static AdditionalChargesService getInstance() {
    if (instance == null) {
      instance = new AdditionalChargesService._();
    }
    return instance;
  }

  Future<AdditionalCharge> AdditionalChargesList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAdditionalChargeList), body: body)
        .then((http.Response response) {
      print(response.body);
      return additionalChargeFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addAdditionalCharges(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAdditionalChargeAdd), body: body)
        .then((http.Response response) {;
    return json.decode(response.body);
    });
  }

  Future editAdditionalCharges(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAdditionalChargeEdit), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteAdditionalCharges(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiAdditionalChargeDelete),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
