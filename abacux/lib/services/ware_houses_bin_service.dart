import 'dart:convert';

import 'package:abacux/config.dart';
import 'package:abacux/model/ware_houses_bin_model.dart';
import 'package:http/http.dart' as http;

class WareHousesBinService {
  static WareHousesBinService instance;
  WareHousesBinService._();

  static WareHousesBinService getInstance() {
    if (instance == null) {
      instance = new WareHousesBinService._();
    }
    return instance;
  }

  Future<WarehousesBinList> wareHouseBinList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiWarehouseBinList), body: body)
        .then((http.Response response) {
      print(response.body);
      return warehousesBinListFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addWareHouseBin(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAddWareHouseBin), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future editWareHouseBin(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditWareHouseBin), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteWareHouseBin(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiDeleteWareHouseBin),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
