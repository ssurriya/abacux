import 'dart:convert';
import 'package:abacux/config.dart';
import 'package:abacux/model/tax_mode.dart';
import 'package:http/http.dart' as http;

import '../model/refferel_model.dart';

class RefferalService {
  static RefferalService instance;
  RefferalService._();

  static RefferalService getInstance() {
    if (instance == null) {
      instance = new RefferalService._();
    }
    return instance;
  }

  Future<Salesperson> RefferalList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEmployeeList), body: body)
        .then((http.Response response) {
      print(response.body);
      return salespersonFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addRefferal(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEmployeeAdd), body: body)
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }

  Future editRefferal(Map body) async {
    return await http
        .post(Uri.parse(Config().apiEmployeeEdit), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteRefferal(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiEmployeeDelete),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
