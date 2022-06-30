import 'dart:convert';
import 'dart:io';
import 'package:abacux/config.dart';
import 'package:abacux/model/permission_model.dart';
import 'package:http/http.dart' as http;

class PermissionService {
  Future<Permission> getPermission(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Config().apiPermission, body: body, headers: headers)
        .then((http.Response response) {
      print(response.body);

      return Permission.fromJson(json.decode(response.body));
    });
  }
}
