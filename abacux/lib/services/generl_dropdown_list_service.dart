import 'dart:convert';
import 'dart:io';
import 'package:abacux/config.dart';
import 'package:abacux/model/Product_model.dart';
import 'package:abacux/model/amount_type.dart';
import 'package:abacux/model/gst_treatments_model.dart';
import 'package:abacux/model/tcs_tax_model.dart';
import 'package:abacux/model/tds_tax_model.dart';
import 'package:http/http.dart' as http;

class DropdownService {
  //AccountHolderTypeList
  Future accountTypes(Map body) async {
    final response = await http
        .post(Uri.parse(Config().apiAccountHolderTypeList), body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body)['account_holder_types'];
    } else {
      print('Failed to load');
    }
  }

  //Product Umos List
  Future productuoms(Map body) async {
    final response =
        await http.post(Uri.parse(Config().apiProductUoms), body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body)['productuoms'];
    } else {
      print('Failed to load');
    }
  }

  //Tax taxlclasstaxtype
  Future taxclasstaxtype(Map body) async {
    final response =
        await http.post(Uri.parse(Config().apiGetTaxclassTaxType), body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body)['taxlclasstaxtype'];
    } else {
      print('Failed to load');
    }
  }

  //Tax class
  Future taxclass(Map body) async {
    final response =
        await http.post(Uri.parse(Config().apiGetTaxclass), body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body)['tax_classes'];
    } else {
      print('Failed to load');
    }
  }

  //Product Attribute
  Future productattribute(Map body) async {
    final response =
        await http.post(Uri.parse(Config().apiProductAttribute), body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body)['productattribute'];
    } else {
      print('Failed to load');
    }
  }

  Future<List<Product>> getProductList(Map body) async {
    var headers = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    };

    return await http
        .post(Config().apiGetPurchaseProductList, body: body, headers: headers)
        .then((http.Response response) {
      final items =
          json.decode(response.body)['products'].cast<Map<String, dynamic>>();
      List<Product> products = items.map<Product>((json) {
        return Product.fromJson(json);
      }).toList();
      return products;
    });
  }

  Future<List<dynamic>> getAdditionalCharge(Map body) async {
    return await http
        .post(Uri.parse(Config().apiWarehouseBin), body: body)
        .then((response) {
      print(json.decode(response.body));
      List<dynamic> additionalCharges = [];
      json.decode(response.body).map((e) {
        additionalCharges.add(json.decode(e));
      }).toList();
      return additionalCharges;
    }).catchError((onError) {});
  }

  Future<GstTreatments> getGstTreatments(Map body) async {
    return await http
        .post(Uri.parse(Config().apiGetGstTreatment), body: body)
        .then((response) {
      print(response.body);
      return gstTreatmentsFromJson(response.body);
    }).catchError((onError) {});
  }

  Future<TdsTax> getTdsTaxType(Map body) async {
    return await http
        .post(Uri.parse(Config().apiGetTds), body: body)
        .then((response) {
      print(response.body);
      return tdsTaxFromJson(response.body);
    }).catchError((onError) {});
  }

  Future<TcsTax> getTcsTaxType(Map body) async {
    return await http
        .post(Uri.parse(Config().apiGetTcs), body: body)
        .then((response) {
      print(response.body);
      return tcsTaxFromJson(response.body);
    }).catchError((onError) {});
  }

  Future<AmountType> getAmountType(Map body) async {
    return await http
        .post(Uri.parse(Config().apiAmountType), body: body)
        .then((response) {
      print(response.body);
      return amountTypeFromJson(response.body);
    }).catchError((onError) {});
  }
}
