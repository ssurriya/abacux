import 'dart:convert';
import 'package:abacux/config.dart';
import 'package:http/http.dart' as http;
import '../model/additional_charge_model.dart';
import '../model/invoice_groups_model.dart';


class InvoicegroupsService {
  static InvoicegroupsService instance;
  InvoicegroupsService._();

  static InvoicegroupsService getInstance() {
    if (instance == null) {
      instance = new InvoicegroupsService._();
    }
    return instance;
  }

  Future<InvoiceGroups> InvoicegroupsList(Map body) async {
    return await http
        .post(Uri.parse(Config().apiInvoiceGroupList), body: body)
        .then((http.Response response) {
      print(response.body);
      return invoiceGroupsFromJson(response.body);
    }).catchError((e) {
      print(e);
    });
  }

  Future addInvoicegroups(Map body) async {
    return await http
        .post(Uri.parse(Config().apiInvoiceGroupAdd), body: body)
        .then((http.Response response) {;
    return json.decode(response.body);
    });
  }

  Future editInvoicegroups(Map body) async {
    return await http
        .post(Uri.parse(Config().apiInvoiceGroupEdit), body: body)
        .then((http.Response response) {
      print(response);
      return json.decode(response.body);
    });
  }

  Future deleteInvoicegroups(Map body) async {
    return await http
        .post(
      Uri.parse(Config().apiInvoiceGroupDelete),
      body: body,
    )
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }
}
