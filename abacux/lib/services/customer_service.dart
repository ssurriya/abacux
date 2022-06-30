import 'dart:convert';
import 'dart:io';
import 'package:abacux/config.dart';
import 'package:abacux/model/customer_model.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class CustomerService {
  Future<List<Customer>> customerList(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Uri.parse(Config().apiGetCustomer), body: body, headers: headers)
        .then((http.Response response) {
      //Decode the Response body convert to Customer model

      print(response.body);

      final items = json
          .decode(response.body)['Customer_list']
          .cast<Map<String, dynamic>>();

      print(items);

      List<Customer> customers = items.map<Customer>((json) {
        return Customer.fromJson(json);
      }).toList();
      return customers;
    });
  }

  Future insertNewCustomer(Map body) async {
    final response =
        await http.post(Uri.parse(Config().apiAddCustomer), body: body);
    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    } else {
      print(result);
    }
  }

  Future editCustomer(Map body) async {
    final response =
        await http.post(Uri.parse(Config().apiEditCustomer), body: body);
    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return result;
    } else {
      print(result);
    }
  }

  Future deleteCustomer(
    String id,
    String user_id,
    String token,
  ) async {
    final response =
        await http.post(Uri.parse(Config().apiCustomerDelete), body: {
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
