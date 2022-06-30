import 'dart:convert';
import 'dart:io';

import 'package:abacux/config.dart';
import 'package:abacux/model/vendor_model.dart';
import 'package:http/http.dart' as http;

class VendorService {
  Future<List<Vendor>> vendorList(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Uri.parse(Config().apiGetVendor), body: body, headers: headers)
        .then((http.Response response) {
      //Decode the Response body convert to Customer model

      print(response.body);

      final items = json
          .decode(response.body)['Vendor_list']
          .cast<Map<String, dynamic>>();

      print(items);
      List<Vendor> vendor = items.map<Vendor>((json) {
        return Vendor.fromJson(json);
      }).toList();
      return vendor;
    });
  }

  Future insertNewVendor(Map body) async {
    final response =
        await http.post(Uri.parse(Config().apiAddVendor), body: body);
    print(response.body);
    var result = json.decode(response.body);
    if (response.statusCode == 200) {
      return result;
    } else {
      print(result);
    }
  }

  Future editVendor(Map body) async {
    final response =
        await http.post(Uri.parse(Config().apiEditVendor), body: body);
    print(response.body);
    var result = json.decode(response.body);
    if (response.statusCode == 200) {
      return result;
    } else {
      print(result);
    }
  }

  Future deleteVendor(
    String id,
    String user_id,
    String token,
  ) async {
    // print(id);
    // String user_id = '21';
    // String token = 'JrluLUZgH9U0Xd4hvbQoqOzLE';
    // String token = await Storage().readString("token");
    // String user_id = await Storage().readString("user_id");
    final response =
        await http.post(Uri.parse(Config().apiVendorDelete), body: {
      "id": id.toString(),
      "user_id": user_id.toString(),
      'token': token.toString(),
    });
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    } else {
      print("Errors:" + result);
    }
  }
}
