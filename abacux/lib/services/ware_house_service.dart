import 'dart:convert';
import 'dart:io';

import 'package:abacux/config.dart';
import 'package:abacux/model/ware_houses_list_model.dart';
import 'package:http/http.dart' as http;

class WareHousesService {
  static WareHousesService instance;
  WareHousesService._();

  static WareHousesService getInstance() {
    if (instance == null) {
      instance = new WareHousesService._();
    }
    return instance;
  }

  Future<WarehousesList> wareHouseList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiWarehouseList), body: body)
        .then((http.Response response) {
      print(warehousesListFromJson(response.body));
      return warehousesListFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addWareHouse(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAddWareHouse), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future editWareHouse(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEditWareHouse), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteWareHouse(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiDeleteWareHouse),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
