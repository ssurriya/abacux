import 'dart:convert';

import 'package:abacux/config.dart';
import 'package:abacux/model/estimate_setting_list_model.dart';
import 'package:http/http.dart' as http;

class EstimateSettingService {
  static EstimateSettingService instance;
  EstimateSettingService._();

  static EstimateSettingService getInstance() {
    if (instance == null) {
      instance = new EstimateSettingService._();
    }
    return instance;
  }

  Future<EstimateSettingList> estimateSettingsList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiGetEstimateSettingsList), body: body)
        .then((http.Response response) {
      return estimateSettingListFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addEstimateSettings(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAddEstimateSettings), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future editEstimateSettings(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditEstimateSettings), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteEstimateSettings(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiDeleteEstimateSettings),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
