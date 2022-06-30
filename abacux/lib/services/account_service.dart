import 'dart:convert';
import 'dart:io';
import 'package:abacux/model/login_model.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class AccountService {
  Future<Login> login(Map body) async {
    //print(Config().apiLogin);
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };
    return await http
        .post(Config().apiLogin, body: body, headers: headers)
        .then((http.Response response) {
      print("ResponseLogin");
      print(response.body);
      print("ResponseLogin");
      return Login.fromJson(json.decode(response.body));
    }).catchError((e) {
      print(e);
    });
  }

  Future logout(Map body) async {
    //print(Config().apiLogin);
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };
    return await http
        .post(Config().apiLogout, body: body, headers: headers)
        .then((http.Response response) {
      print(response.body);
      return jsonDecode(response.body);
    });
  }
}
