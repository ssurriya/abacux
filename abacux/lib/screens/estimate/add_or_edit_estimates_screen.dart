import 'dart:convert';

import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/check_box.dart';
import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/common/drop_down.dart';
import 'package:abacux/common/text_field.dart';
import 'package:abacux/helper/custom_string_helper.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/Product_model.dart';
import 'package:abacux/model/customer_model.dart';
import 'package:abacux/model/estimate_edit_using_id.dart';
import 'package:abacux/services/customer_service.dart';
import 'package:abacux/services/estimate_service.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';

import 'add_estimate_product_screen.dart';
import 'add_or_edit_additional_charges.dart';

import 'package:http/http.dart' as http;

class AddOrEditEstimatesScreen extends StatefulWidget {
  const AddOrEditEstimatesScreen({this.estimateEditUsingId});

  final EstimateEditUsingId estimateEditUsingId;

  @override
  _AddOrEditEstimatesScreenState createState() =>
      _AddOrEditEstimatesScreenState();
}

class _AddOrEditEstimatesScreenState extends State<AddOrEditEstimatesScreen> {
  var _formKey = GlobalKey<FormState>();

  TextEditingController billPrefix = TextEditingController();
  TextEditingController poNo = TextEditingController();
  TextEditingController vendorName = TextEditingController();
  TextEditingController purchaseOrderDate = TextEditingController();
  TextEditingController _subTotal = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController _cgst = TextEditingController();
  TextEditingController _sgst = TextEditingController();
  TextEditingController _igst = TextEditingController();
  TextEditingController _salesTax = TextEditingController();
  TextEditingController _totalDiscountAmt = TextEditingController();
  TextEditingController _totalDiscountPrecentage = TextEditingController();
  TextEditingController _roundOffAmount = TextEditingController();
  TextEditingController total = TextEditingController();

  DateTime _date = DateTime.now();
  int num = 100;
  double intialvalue = 0;
  double totaladdtionalvalue = 0;
  bool _isEdit = false;

  bool _isVisible = true;

  void viewDiscount() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  List<Customer> _customerList = [];
  Customer _selectedCustomer;

  List<Customer> _referal = [];
  Customer _selectedReferal;

  int userId, companyId, purchaseOrderNumber;
  String token;

  List<dynamic> productList = [];

  List<dynamic> additionalChargesList = [];

  List<String> _types = ["+ Add", "- Reduce"];
  String _selectedType;

  EstimateEditUsingId _estimateEditUsingId;
  int estimateId; // For Edit Purpose only
  List additionalChargeIds = []; // For Edit Purpose only
  int estimateProductIndex = 0; // is Edit only
  int additionalChargeIndex = 0; // Is Edit only
  List<Product> _productList = []; // is Edit only
  Product _selectedProduct;
  int deleteEstimateId;

  bool _isProductListVisible = true;
  bool _isAdditionalChargeVisible = true;
  bool _isLoading = false;
  bool _isAutoRoundOff = false;

  bool referal = false, groups = false, none = true, referalGroups = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check Internet Connection
    CheckConnectivity.getInstance().checkConnectivity(context);
  }

  @override
  void initState() {
    super.initState();

    // _getEstimateEditUsingId(); //Only use If Estimate Edit Id Saved in service get method
    // _getAdditionalChargeId(); //Only use If Estimate additional charge Id Saved in service get method
    // _getEstimateProductIndex();
    // _getAdditionalIndex();
    _getUserAndCompanyId();
    _setDateTime();

    _getEstimateProduct();
    _getAdditionalChargesValueFromLocal();

    _getCustomer();
    _getDateTime();

    _estimateEditUsingId = EstimateService.getInstance().getEstimateEditUsingId;
    if (_estimateEditUsingId == null) {
      if (widget.estimateEditUsingId != null) {
        setState(() {
          _isEdit = true;
          _isVisible = true;
          _isLoading = true;
          _estimateEditUsingId = widget.estimateEditUsingId;
          deleteEstimateId = widget.estimateEditUsingId.estimatesVal.id;
          EstimateService.getInstance()
              .setEstimateEditUsingId(_estimateEditUsingId);
          _loadEstimateValue(_estimateEditUsingId);
        });
      }
    } else {
      _isEdit = true;
      _isVisible = true;
      _selectedCustomer = EstimateService.getInstance().getCustomer;
      additionalChargeIds = EstimateService.getInstance().getAdditionalChargeId;
      deleteEstimateId = _estimateEditUsingId.estimatesVal.id;
      _loadUnchangedValue(_estimateEditUsingId);
    }
  }

  _getCustomer() {
    Customer customer = EstimateService.getInstance().getCustomer;
    setState(() {
      if (customer != null) {
        _selectedCustomer = customer;
      }
    });
  }

  _getDateTime() {
    DateTime dateTime = EstimateService.getInstance().getDateTime;
    setState(() {
      if (dateTime != null) {
        _date = dateTime;
        purchaseOrderDate.text = _dateFormat(_date);
      }
    });
  }

  _getEstimateProduct() async {
    setState(() {
      productList = [];
    });
    await EstimateService.getInstance()
        .getEstimateProductFromLocal()
        .then((value) {
      value.map((e) {
        setState(() {
          productList.add(e);
        });
      }).toList();
    });

    _calculateTotal();
  }

  _calculateTotal() {
    double totalBasicPrice = 0.0,
        salesTax = 0.0,
        subTotal = 0.0,
        cgst = 0.0,
        igst = 0.0,
        sgst = 0.0;
    setState(() {
      productList.map((e) {
        totalBasicPrice += e['amount'];
        salesTax += e['salesTax'];
        subTotal += e['subTotal'];
        cgst += e['cgst'];
        sgst += e['sgst'];
        igst += e['igst'];
      }).toList();

      total.text = totalBasicPrice.toString();
      _salesTax.text = salesTax.toString();
      _subTotal.text = subTotal.toString();
      _cgst.text = cgst.toString();
      _sgst.text = sgst.toString();
      _igst.text = igst.toString();

      String discountInAmt = EstimateService.getInstance().getDiscountInAmt;
      String discountInPercentage =
          EstimateService.getInstance().getDiscountInPercentage;
      _totalDiscountAmt.text = discountInAmt == null
          ? widget.estimateEditUsingId != null
              ? widget.estimateEditUsingId.estimatesVal.discountInAmount
              : intialvalue.toString()
          : discountInAmt;
      _totalDiscountPrecentage.text = discountInPercentage == null
          ? widget.estimateEditUsingId != null
              ? widget.estimateEditUsingId.estimatesVal.discountInPercentage
              : intialvalue.toString()
          : discountInPercentage;
      updatePrecentageToDiscountAmt();
    });
  }

  _calculateAdditionalTotal() {
    double totalAmount = 0.0;

    setState(() {
      additionalChargesList.map((e) {
        totalAmount += e['totalAmount'];
      }).toList();
      totaladdtionalvalue = double.parse(totalAmount.toString());

      total.text =
          (double.parse(total.text) + totalAmount - totaladdtionalvalue)
              .toString();
      updatePrecentageToDiscountAmt();
      print(total.text);
    });
  }

  _getAdditionalChargesValueFromLocal() async {
    setState(() {
      additionalChargesList = [];
    });
    await EstimateService.getInstance()
        .getEstimateAdditionalFromLocal()
        .then((value) {
      print(value);
      setState(() {
        value.map((e) {
          additionalChargesList.add(e);
        }).toList();
      });
      _calculateAdditionalTotal();
    });
  }

  _setDateTime() {
    purchaseOrderDate.text = _dateFormat(_date);
  }

  // Get User And Company ID
  _getUserAndCompanyId() async {
    await Storage().readInt("userId").then((value) {
      userId = value;
    });
    await Storage().readString("token").then((value) {
      token = value;
    });
    await Storage().readInt("selectedCompanyId").then((value) {
      companyId = value;
    });

    _getProductList();

    // Call Customer listing service
    _getCustomerList();

    // Call Estimate Settings
    _getEstimateSettings();

    // Get Estimate Invoice Number
    if (!_isEdit) {
      _getEstimateNo();
    }
  }

  // Get Customer Listing
  _getCustomerList() async {
    Map body = {
      'user_id': userId.toString(),
      'token': token.toString(),
      'company_id': companyId.toString(),
    };
    print("Customer User $body");
    await CustomerService().customerList(body).then((value) {
      setState(() {
        _customerList = value;
        _referal = value;
      });
    }).catchError((onError) {
      _showFlushBar("Try Again Later", Icons.error_outline, Colors.red);
    });
    _sortByName();
  }

  _sortByName() {
    setState(() {
      _customerList.sort((a, b) {
        print("${a.customerName}:${b.customerName}");
        return a.customerName == null
            ? 0
            : b.customerName == null
                ? 0
                : a.customerName
                    .toLowerCase()
                    .compareTo(b.customerName.toLowerCase());
      });
    });
  }

  _getEstimateSettings() async {
    Map body = {
      "user_id": userId.toString(),
      "company_id": companyId.toString(),
      "token": token
    };
    await EstimateService.getInstance().getEstimateSettings(body).then((value) {
      print(value);
      value.map((e) {
        print(e);
        setState(() {
          billPrefix.text = e['prefix'];
          // poNo.text = e['estimate_start_number'].toString();
        });
      }).toList();
    }).catchError((error) {
      print(error);
      _showFlushBar("Try Again Later", Icons.error_outline, Colors.red);
    });
  }

  _getEstimateNo() async {
    Map body = {"user_id": userId.toString(), "token": token};

    await EstimateService.getInstance().getEstimateNo(body).then((value) {
      print(value);
      setState(() {
        poNo.text = value.toString();
      });
    }).catchError((error) {
      _showFlushBar("Try Again Later", Icons.error_outline, Colors.red);
    });
  }

  _getProductList() async {
    Map body = {
      "user_id": userId.toString(),
      "company_id": companyId.toString(),
      "token": token
    };
    print(body);
    await EstimateService.getInstance().getEstimateProduct(body).then((value) {
      setState(() {
        _productList = value;
      });
    });
  }

  _showFlushBar(String message, IconData icon, Color color) {
    Flushbar(
      icon: Icon(
        icon,
        size: 28.0,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(8),
      duration: Duration(seconds: 5),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: color,
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    )..show(context);
  }

  // Is Edit - Start

  _loadUnchangedValue(EstimateEditUsingId estimateEditUsingId) {
    estimateId = estimateEditUsingId.estimatesVal.id;
    poNo.text = estimateEditUsingId.estimatesVal.estimateNo;
    _date = DateTime.parse(estimateEditUsingId.estimatesVal.estimateDate);
    purchaseOrderDate.text = _dateFormat(_date);
    EstimateService.getInstance().setDateTime(_date);
  }

  _loadEstimateValue(EstimateEditUsingId estimateEditUsingId) async {
    await Future.delayed(Duration(milliseconds: 2000), () {
      // Do something
    });

    setState(() {
      _loadUnchangedValue(estimateEditUsingId);

      _customerList.isNotEmpty
          ? _selectedCustomer = _customerList.firstWhere((element) =>
              element.id == estimateEditUsingId.estimatesVal.customerId)
          : null;

      // Set Customer
      EstimateService.getInstance().setCustomer(_selectedCustomer);

      _totalDiscountAmt.text =
          estimateEditUsingId.estimatesVal.discountInAmount;
      _totalDiscountPrecentage.text =
          estimateEditUsingId.estimatesVal.discountInPercentage;

      //Set Discount in Amt & Percentage
      EstimateService.getInstance().setDiscountInAmt(_totalDiscountAmt.text);
      EstimateService.getInstance()
          .setDiscountInPercentage(_totalDiscountPrecentage.text);

      _isVisible = true;

      String taxInfoStr =
          estimateEditUsingId.estimatesVal.taxInfo.replaceAll('/', "");
      List taxInfoList = jsonDecode(taxInfoStr);
      print(taxInfoList);
      taxInfoList.map((e) {
        print(e);
        setState(() {
          if (e['key'] == "SGST") {
            _sgst.text = e['value'].toString();
          } else if (e['key'] == "CGST") {
            _cgst.text = e['value'].toString();
          } else if (e['key'] == "IGST") {
            _igst.text = e['value'].toString();
          } else if (e['key'] == "totaltax") {
            _salesTax.text = e['value'].toString();
          }
        });
      }).toList();

      //insert Proforma Invoice Product To Local
      for (int i = 0; i < estimateEditUsingId.estimatesProducts.length; i++) {
        _productList.isNotEmpty
            ? _selectedProduct = _productList.firstWhere((element) =>
                element.id ==
                estimateEditUsingId.estimatesProducts[i].productId)
            : null;
        String productTaxInfo = estimateEditUsingId.estimatesProducts[i].taxInfo
            .replaceAll("/", "");
        Map productTaxInfoBody = jsonDecode(productTaxInfo);
        Map body = _createBodyToInsertProduct(
            i,
            estimateEditUsingId.estimatesProducts[i],
            _selectedProduct,
            productTaxInfoBody);

        EstimateService.getInstance().insertEstimateProductFromLocal(body);
      }

      //insert Proforma Additional Charges To Local
      for (int i = 0; i < estimateEditUsingId.additionalCharges.length; i++) {
        additionalChargeIds.add(estimateEditUsingId.additionalCharges[i].id);
        String additionalTaxInfo = estimateEditUsingId
            .additionalCharges[i].taxPercentage
            .replaceAll("/", "");
        Map productTaxInfoBody = jsonDecode(additionalTaxInfo);
        Map body = _createBodyToInsertAdditionalCharge(
            i, estimateEditUsingId.additionalCharges[i], productTaxInfoBody);

        EstimateService.getInstance().insertEstimateAdditionalCharges(body);
      }

      //Set AdditionalCharge Ids
      EstimateService.getInstance().setAdditionalChargeId(additionalChargeIds);

      _getEstimateProduct();
      _getAdditionalChargesValueFromLocal();
      print("AddSefvice${EstimateService.getInstance().getAdditionalChargeId}");
      _isLoading = false;
    });
  }

  _createBodyToInsertProduct(int id, EstimatesProduct estimatesProduct,
      Product _product, Map taxInfo) {
    return {
      "id": id,
      "uuid": Uuid().v1(),
      "product": _product.productName,
      "pid": estimatesProduct.pid,
      "productId": _product.id,
      "productUomsId": _product.umosId,
      "quantity": estimatesProduct.quantity.toDouble(),
      "basicPrice": double.parse(_product.purchasePrice),
      "price": double.parse(estimatesProduct.salesRate),
      "taxType": int.parse(taxInfo['tax_type']),
      "tax": taxInfo['tax_percentage'] != "["
          ? double.parse(taxInfo['tax_percentage'])
          : 0.0,
      "discount": double.parse(estimatesProduct.discountInPercentage),
      "discountAmount": double.parse(estimatesProduct.discountInAmount),
      "amount": double.parse(estimatesProduct.grandTotal),
      "cgst": taxInfo['CGST9'] != null
          ? double.parse(taxInfo['CGST9'])
          : taxInfo['CGST14'] != null
              ? double.parse(taxInfo['CGST14'])
              : 0.0,
      "sgst": taxInfo['SGST9'] != null
          ? double.parse(taxInfo['SGST9'])
          : taxInfo['SGST14'] != null
              ? double.parse(taxInfo['SGST14'])
              : 0.0,
      "igst":
          taxInfo['IGST12.0'] != null ? double.parse(taxInfo['IGST12.0']) : 0.0,
      "salesTax": double.parse(taxInfo['tax_amount']),
      "subTotal": double.parse(estimatesProduct.grossTotal)
    };
  }

  _createBodyToInsertAdditionalCharge(
      int id, AdditionalCharge additionalCharge, Map taxInfoBody) {
    return {
      "id": id,
      "uuid": Uuid().v1(),
      "additionalChargeId": additionalCharge.id,
      "additionalCharge": additionalCharge.additonalChargeName,
      "amount": double.parse(additionalCharge.addtionalChargeAmount),
      "taxType": double.parse(taxInfoBody['tax_type']),
      "tax": double.parse(taxInfoBody['tax_percentage']),
      "totalAmount": double.parse(additionalCharge.totalAmount),
    };
  }

  // Is Edit - End

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _clearEstimateLocalDate();
        Navigator.pushReplacementNamed(context, "/estimates");
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.96),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppConstant().appThemeColor,
              ),
              onPressed: () {
                _clearEstimateLocalDate();
              }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isEdit ? "Edit Estimate Order" : "Add Estimate Order",
                style: TextStyle(color: Colors.black),
              ),
              _isEdit
                  ? Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: AppConstant().appThemeColor,
                          ),
                          onPressed: () async {
                            _showModelDialog("Delete",
                                "Are you sure want to delete the estimate details?",
                                buttonText1: "No",
                                buttonText2: "Yes", onPressedButton1: () {
                              Navigator.of(context).pop();
                            }, onPressedButton2: () {
                              _deleteEstimateDetails(deleteEstimateId);
                            });
                          }),
                    )
                  : Container(),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    createBodyForEstimateStore();
                  }
                },
                child: Icon(
                  Icons.save,
                  color: AppConstant().appThemeColor,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: _isEdit
                  ? _isLoading
                      ? Center(
                          heightFactor: 8,
                          child: CircularProgressIndicator(
                            strokeWidth: 4.0,
                            backgroundColor: AppConstant().appThemeColor,
                          ),
                        )
                      : _getColumnWidget()
                  : _getColumnWidget(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getColumnWidget() {
    return Column(
      children: [
        textField(billPrefix, "Bill Prefix", isRead: true),
        textField(poNo, "Invoice No", isRead: true),
        dateTextField(),
        dropDown("Customer Name", _selectedCustomer, _customerList,
            (Customer customer) {
          return customer.customerName;
        }, onchanged: (Customer customer) {
          setState(() {
            _selectedCustomer = customer;
            _selectedReferal = null;
          });
        }),
        Row(
          children: [
            CircularCheckbox(
                value: referal,
                onChanged: (value) {
                  setState(() {
                    referal = value;
                    if (value) {
                      groups = false;
                      none = false;
                    }
                  });
                }),
            _checkBoxText("Referal"),
            CircularCheckbox(
                value: groups,
                onChanged: (value) {
                  setState(() {
                    groups = value;
                    if (value) {
                      referal = false;
                      none = false;
                    }
                  });
                }),
            _checkBoxText("Groups"),
            CircularCheckbox(
                value: none,
                onChanged: (value) {
                  setState(() {
                    none = value;
                    if (value) {
                      groups = false;
                      referal = false;
                    }
                  });
                }),
            _checkBoxText("None"),
          ],
        ),
        Visibility(
          visible: referal,
          child: Row(
            children: [
              Checkbox(
                  value: none,
                  onChanged: (value) {
                    setState(() {
                      referalGroups = value;
                    });
                  }),
              _checkBoxText("Groups"),
            ],
          ),
        ),
        Visibility(
          visible: referal,
          child: dropDown("Referal Name", _selectedReferal, _referal,
              (Customer customer) {
            return customer.customerName;
          }, onchanged: (Customer customer) {
            _selectedReferal = customer;

            print(_selectedCustomer);
          }),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0, left: 10.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddEstimateProductScreen(
                            isUpdate: _isEdit,
                          )));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: AppConstant().appThemeColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        'Add product',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          letterSpacing: 1.0,
                          color: AppConstant().appThemeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              productList.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _isProductListVisible = !_isProductListVisible;
                        });
                      },
                      child: _productAndAdditionalChargeListVisibility(
                          _isProductListVisible, productList.length),
                    )
                  : Container(),
              productList.isEmpty && additionalChargesList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: _getAdditionalChargeWidget(),
                    )
                  : Container(),
            ],
          ),
        ),
        productList.isEmpty
            ? Container()
            : Visibility(
                visible: _isProductListVisible,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 25.0, left: 10, right: 10),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(
                            //   color: Colors.grey.withOpacity(0.6),
                            // ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Text(
                                            '#${index + 1}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Container(
                                          width: 210,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              '${productList[index]['product']}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '\u{20B9} ${productList[index]['amount']}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Discount: ${productList[index]['discount']}% ',
                                      style: TextStyle(
                                          fontSize: 15, letterSpacing: 0.5),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Qty: ${productList[index]['quantity']}  | ',
                                          style: TextStyle(
                                              fontSize: 15, letterSpacing: 0.5),
                                        ),
                                        Text(
                                          'Price :${productList[index]['basicPrice']}',
                                          style: TextStyle(
                                              fontSize: 15, letterSpacing: 0.5),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            _showModelDialog("Delete",
                                                "Are you sure want to delete this product ?",
                                                buttonText1: "No",
                                                buttonText2: "Yes",
                                                onPressedButton1: () {
                                              Navigator.of(context).pop();
                                            }, onPressedButton2: () {
                                              _deleteProductusingPid(
                                                productList[index]['uuid'],
                                                productList[index]['pid'],
                                              );
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.delete,
                                              size: 24,
                                              color:
                                                  AppConstant().appThemeColor,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print(productList[index]);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddEstimateProductScreen(
                                                          productValue:
                                                              productList[
                                                                  index],
                                                          isUpdate: _isEdit,
                                                        )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 18.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.edit,
                                                size: 24,
                                                color:
                                                    AppConstant().appThemeColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    );
                  },
                ),
              ),
        productList.isEmpty && additionalChargesList.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 10.0),
                child: _getAdditionalChargeWidget(),
              ),
        additionalChargesList.isEmpty
            ? Container()
            : _getAdditionalChargesItem(),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Flexible(
                child: textField(_subTotal, "\u{20B9}  Sub Total",
                    isRead: true, isRow: true),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Flexible(
                  child: textField(_igst, "\u{20B9}  IGST",
                      isRow: true, isRead: true)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Flexible(
                  child: textField(_sgst, "\u{20B9}  SGST",
                      isRow: true, isRead: true)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Flexible(
                  child: textField(_cgst, "\u{20B9}  CGST",
                      isRow: true, isRead: true)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Flexible(
                  child: textField(_salesTax, "\u{20B9}  Sales Tax",
                      isRow: true, isRead: true)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              viewDiscount();
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 10.0, bottom: 10.0),
            child: Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: AppConstant().appThemeColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    'Add Discount',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      letterSpacing: 1.0,
                      color: AppConstant().appThemeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _isVisible,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Flexible(
                    child: textField(
                  _totalDiscountPrecentage,
                  "% Percentage",
                  isRow: true,
                  isRead: false,
                  onchanged: (value) {
                    updatePrecentageToDiscountAmt();
                    //Set Discount in Amt
                    EstimateService.getInstance()
                        .setDiscountInPercentage(value);
                  },
                )),
                Flexible(
                    child: textField(_totalDiscountAmt, "\u{20B9} Amount ",
                        isRow: true, isRead: false, onchanged: (value) {
                  updateDiscountAmtTOprecentage();
                  //Set Discount in Amt
                  EstimateService.getInstance().setDiscountInAmt(value);
                })),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Flexible(
              child: dropDown("Type", _selectedType, _types, (value) {
                return value;
              }, onchanged: (value) {
                _selectedCustomer = value;
              }, isRow: true),
            ),
            Flexible(
              child: textField(_roundOffAmount, "\u{20B9} Round Off Amount",
                  isRead: _isAutoRoundOff ? true : false),
            ),
          ],
        ),
        Row(
          children: [
            Checkbox(
                value: _isAutoRoundOff,
                activeColor: AppConstant().appThemeColor,
                onChanged: (value) {
                  setState(() {
                    _isAutoRoundOff = !_isAutoRoundOff;
                    if (value) {
                      _roundOffAmount = TextEditingController();
                      _selectedType = null;
                    }
                  });
                }),
            Text(
              "Auto Round Off",
              style: TextStyle(
                fontFamily: 'Poppins',
                letterSpacing: 1.0,
                color: AppConstant().appThemeColor,
              ),
            )
          ],
        ),
        textField(total, "\u{20B9}  Total", isRead: true),
      ],
    );
  }

  _checkBoxText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _getAdditionalChargeWidget() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EstimateAdditionalCharges(
                      isUpdate: _isEdit,
                    )));
          },
          child: Row(
            children: [
              Icon(
                Icons.add_circle_outline,
                color: AppConstant().appThemeColor,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  'Additional Charges',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    letterSpacing: 1.0,
                    color: AppConstant().appThemeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        additionalChargesList.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isAdditionalChargeVisible = !_isAdditionalChargeVisible;
                  });
                },
                child: _productAndAdditionalChargeListVisibility(
                    _isAdditionalChargeVisible, additionalChargesList.length),
              )
            : Container(),
      ],
    );
  }

  Widget _getAdditionalChargesItem() {
    return Visibility(
      visible: _isAdditionalChargeVisible,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: additionalChargesList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 10, right: 10),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(
                  //   color: Colors.grey.withOpacity(0.6),
                  // ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text(
                                  '#${index + 1}',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '${additionalChargesList[index]['additionalCharge']}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\u{20B9} ${additionalChargesList[index]['totalAmount']}',
                            style: TextStyle(
                                fontSize: 20,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Tax: ${additionalChargesList[index]['tax']}% ',
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 0.5),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  _showModelDialog(
                                      "Delete", "Are you sure want to delete ?",
                                      buttonText1: "No",
                                      buttonText2: "Yes", onPressedButton1: () {
                                    Navigator.of(context).pop();
                                  }, onPressedButton2: () {
                                    _deleteAdditionalChargeUsingId(
                                        additionalChargesList[index]['uuid'],
                                        additionalChargesList[index]
                                            ['additionalChargeId']);
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.delete,
                                    size: 24,
                                    color: AppConstant().appThemeColor,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          EstimateAdditionalCharges(
                                            productValue:
                                                additionalChargesList[index],
                                            isUpdate: _isEdit,
                                          )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.edit,
                                      size: 24,
                                      color: AppConstant().appThemeColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }

  Widget textField(TextEditingController controller, String hintText,
      {IconData prefixIcon,
      bool isRow = false,
      IconData suffixIcon,
      Function validator,
      Function onchanged,
      bool isRead = false}) {
    return Padding(
      padding: isRow ? const EdgeInsets.all(0.0) : const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: CustomTextFormField(
            controller,
            hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            validator: validator,
            onchanged: onchanged,
            isRead: isRead,
          ),
        ),
      ),
    );
  }

  Widget dropDown(String labelText, dynamic selectedValue, List<dynamic> items,
      Function itemAsString,
      {String errorText = "",
      Function onchanged,
      Function validator,
      bool isValidate = true,
      bool isRow = false}) {
    return Padding(
      padding: isRow
          ? const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 4.0)
          : const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 0.4,
            margin: isRow
                ? EdgeInsets.all(0)
                : EdgeInsets.only(top: 10, bottom: 10),
            child: DropDown(
              labelText,
              selectedValue,
              items,
              itemAsString,
              errorText: errorText,
              onchanged: onchanged,
              isValidate: isValidate,
            ),
          ),
        ),
      ),
    );
  }

  Widget dateTextField() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _selectListDateFrom(context);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        readOnly: true,
                        controller: purchaseOrderDate,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w400),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _selectListDateFrom(context);
                        },
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w600),
                          suffixIcon: Icon(
                            Icons.date_range,
                            color: AppConstant().appThemeColor,
                          ),
                          fillColor: Color(0xFFEEEEFF),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateDiscountAmtTOprecentage() {
    if (total.text.trim() != '') {
      try {
        double _discountAmount = double.parse(_totalDiscountAmt.text);
        double _salestaxprice = double.parse(_salesTax.text);
        double _subtotalprice = double.parse(_subTotal.text);
        double _finalPrice =
            _salestaxprice + _subtotalprice + totaladdtionalvalue;
        double _discountPrecendage = (_discountAmount / _finalPrice) * num;
        print(_discountAmount);
        print(_finalPrice);
        _totalDiscountPrecentage.text =
            CustomStringHelper().formattDoubleToString(_discountPrecendage);
        total.text = CustomStringHelper()
            .formattDoubleToString((_finalPrice) - _discountAmount);
        EstimateService.getInstance()
            .setDiscountInPercentage(_totalDiscountPrecentage.text);
      } on Exception catch (exception) {} catch (error) {}
    }
  }

  updatePrecentageToDiscountAmt() {
    if (total.text.trim() != '') {
      try {
        double _discountPrecentage =
            double.parse(_totalDiscountPrecentage.text);
        double _salestaxprice = double.parse(_salesTax.text);
        double _subtotalprice = double.parse(_subTotal.text);
        double _finalPrice =
            _salestaxprice + _subtotalprice + totaladdtionalvalue;
        double _discountPrice = ((_finalPrice * _discountPrecentage) / num);
        _totalDiscountAmt.text =
            CustomStringHelper().formattDoubleToString(_discountPrice);
        total.text = CustomStringHelper()
            .formattDoubleToString((_finalPrice) - _discountPrice);

        print("total " + total.text);

        //Set Discount in Percentage
        EstimateService.getInstance().setDiscountInAmt(_totalDiscountAmt.text);
      } on Exception catch (exception) {} catch (error) {}
    }
  }

  Widget _productAndAdditionalChargeListVisibility(bool isVisible, int count) {
    return new Row(children: <Widget>[
      new Icon(
        isVisible
            ? Icons.keyboard_arrow_down_outlined
            : Icons.keyboard_arrow_up_outlined,
        size: 38,
        color: AppConstant().appThemeColor,
      ),
      isVisible
          ? Container()
          : count != null && count != 0
              ? Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.7)),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(),
    ]);
  }

  Future<Null> _selectListDateFrom(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2100));

    setState(() {
      _date = pickedDate;
      purchaseOrderDate.text = _dateFormat(_date);
      EstimateService.getInstance().setDateTime(pickedDate);
    });
  }

  // Date Format
  String _dateFormat(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  _showModelDialog(String title, String content,
      {String buttonText1,
      String buttonText2,
      Function onPressedButton1,
      Function onPressedButton2}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(content),
        actions: [
          buttonText1 != null
              ? ElevatedButton(
                  onPressed: onPressedButton1,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF393939)),
                  ),
                  child: Text(buttonText1),
                )
              : Container(),
          buttonText2 != null
              ? ElevatedButton(
                  onPressed: onPressedButton2,
                  //Navigator.of(context).pop(true),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF393939)),
                  ),
                  child: Text(buttonText2),
                )
              : Container(),
        ],
      ),
    );
  }

  createBodyForEstimateStore() {
    List productids = [];
    List uomIds = [];
    List quantities = [];
    List baseRates = [];
    List salesRate = [];
    List pTaxTypes = [];
    List ptaxInfos = [];
    List pDiscounts = [];
    List pDiscountAmounts = [];
    List pGrandTotals = [];
    List pGrossTotals = [];
    List pTaxAmounts = [];
    List additionalChargeNames = [];
    List additionalChargeAmounts = [];
    List additionalTaxTypes = [];
    List additionalTaxPercentages = [];
    List additionalTotalAmounts = [];

    productList.map((e) {
      print(e);
      productids.add(e['productId']);
      uomIds.add(e['productUomsId']);
      quantities.add(e['quantity'].toInt());
      baseRates.add(e['basicPrice']);
      salesRate.add(e['price']);
      pTaxTypes.add(e['taxType']);
      ptaxInfos.add(e['tax']);
      pDiscounts.add(e['discount']);
      pDiscountAmounts.add(e['discountAmount']);
      pGrandTotals.add(e['amount']);
      pGrossTotals.add(e['subTotal']);
      pTaxAmounts.add(e['salesTax']);
    }).toList();

    additionalChargesList.map((e) {
      additionalChargeNames.add(e['additionalCharge']);
      additionalChargeAmounts.add(e['amount']);
      additionalTaxTypes.add(e['taxType']);
      additionalTaxPercentages.add(e['tax']);
      additionalTotalAmounts.add(e['totalAmount']);
    }).toList();

    double totalTax = double.parse(_igst.text) +
        double.parse(_cgst.text) +
        double.parse(_sgst.text);

    List<String> _gstgroupname = ["SGST", "CGST", "IGST", "totaltax"];

    List _gstgroup = [
      stringAsFixed(double.parse(_sgst.text)).toString(),
      stringAsFixed(double.parse(_cgst.text)).toString(),
      stringAsFixed(double.parse(_igst.text)).toString(),
      stringAsFixed(totalTax).toString()
    ];

    Map body = {
      "user_id": userId.toString(),
      "company_id": companyId.toString(),
      "token": token.toString(),
      "prefix": billPrefix.text,
      "estimate_no": poNo.text,
      "customer_id": _selectedCustomer.id.toString(),
      "estimate_settings": "1",
      "hidden_prefix": "EO",
      "estimate_date": _date.toString(),
      "product_id": productids.toString(),
      "uom_id": uomIds.toString(),
      "quantity": quantities.toString(),
      "base_rate": baseRates.toString(),
      // "purchase_rate": "[7627.119,600]",
      "sales_rate": salesRate.toString(),
      "ptaxtype": pTaxTypes.toString(),
      "ptax_info": ptaxInfos.toString(),
      "pdiscount": pDiscounts.toString(),
      "pdiscountamount": pDiscountAmounts.toString(),
      "pgrand_total": pGrandTotals.toString(),
      "pgross_total": pGrossTotals.toString(),
      "ptax_amount": pTaxAmounts.toString(),
      "gstgroup": _gstgroup.toString(),
      "gstgroupname": _gstgroupname.toString(),
      "additonal_charge_name": additionalChargeNames.toString(),
      "addtional_charge_amount": additionalChargeAmounts.toString(),
      "additional_tax_type": additionalTaxTypes.toString(),
      "additional_tax_percentage": additionalTaxPercentages.toString(),
      "additional_total_amount": additionalTotalAmounts.toString(),
      "discountotal_percentage":
          double.parse(_totalDiscountPrecentage.text).toString(),
      "discount":
          stringAsFixed(double.parse(_totalDiscountAmt.text)).toString(),
      "gross_total": stringAsFixed(double.parse(_subTotal.text)).toString(),
      "grand_total": stringAsFixed(double.parse(total.text)).toString()
    };

    if (_isEdit) {
      body["estimate_id"] = estimateId.toString();
      if (additionalChargeNames.length > additionalChargeIds.length) {
        int count = additionalChargeNames.length - additionalChargeIds.length;
        for (int i = 1; i <= count; i++) {
          additionalChargeIds.add(0);
        }
      }
      body["additional_charge_id"] = additionalChargeIds.toString();
    }

    postEstimateStore(body);
  }

  double stringAsFixed(double value) {
    return double.parse((value).toStringAsFixed(3));
  }

  _deleteProductusingPid(String uuid, int pid) async {
    if (_isEdit) {
      Map body = {
        "user_id": userId.toString(),
        "company_id": companyId.toString(),
        "token": token,
        "pid": pid.toString()
      };
      // Delete api for estimate product
      await EstimateService.getInstance()
          .deleteProductUsingPid(body)
          .then((value) {
        // Delete Local data
        EstimateService.getInstance().deleteEstimateProductUsingId(uuid);
        Navigator.of(context).pop();
        _getEstimateProduct();
      }).catchError((onError) {
        _showModelDialog(
          "Error",
          "Try again later",
          buttonText1: "Ok",
          onPressedButton1: () {
            Navigator.of(context).pop();
          },
        );
      });
    } else {
      // Delete Local data
      EstimateService.getInstance().deleteEstimateProductUsingId(uuid);
      Navigator.of(context).pop();
      _getEstimateProduct();
    }
  }

  _deleteAdditionalChargeUsingId(String uuid, int id) async {
    if (_isEdit) {
      Map body = {
        "user_id": userId.toString(),
        // "company_id": companyId.toString(),
        "token": token,
        "deleteid": id.toString()
      };

      // Delete api for estimate product
      await EstimateService.getInstance()
          .deleteAdditionalChargeApi(body)
          .then((value) {
        // Delete Local data
        EstimateService.getInstance().deleteEstimateAdditionalCharges(uuid);
        Navigator.of(context).pop();
        _getAdditionalChargesValueFromLocal();
      }).catchError((onError) {
        _showModelDialog(
          "Error",
          "Try again later",
          buttonText1: "Ok",
          onPressedButton1: () {
            Navigator.of(context).pop();
          },
        );
      });
    } else {
      await EstimateService.getInstance()
          .deleteEstimateAdditionalCharges(uuid)
          .then((value) {
        _getEstimateProduct();
        _getAdditionalChargesValueFromLocal();
      });
    }
  }

  _deleteEstimateDetails(int id) async {
    Map body = {
      "user_id": userId.toString(),
      "company_id": companyId.toString(),
      "token": token,
      "id": id.toString()
    };
    await EstimateService.getInstance().deleteEstimateApi(body).then((value) {
      _clearEstimateLocalDate(isShowToast: true, isDelete: true);
      Navigator.of(context).pop();
      Navigator.pushNamed(context, "/estimates");
    });
  }

  postEstimateStore(Map body) async {
    String _body = jsonEncode(body);
    print(_body);
    print(body);
    if (_isEdit) {
      await EstimateService.getInstance()
          .updateEstimateStore(body)
          .then((value) async {
        _clearEstimateLocalDate(isShowToast: true);
      }).catchError((error) async {
        _showFlushBar("Try Again Later", Icons.error_outline, Colors.red);
      });
    } else {
      await EstimateService.getInstance()
          .postEstimateStore(body)
          .then((value) async {
        _clearEstimateLocalDate(isShowToast: true);
      }).catchError((error) async {
        _showFlushBar("Try Again Later", Icons.error_outline, Colors.red);
      });
    }
  }

  _printScreen() async {
    var url = Uri.parse("http://sp.abacux.io/salesinvoice_print/1");
    http.Response responses = await http.get(url);
    var pdfData = responses.bodyBytes;
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }

  _clearEstimateLocalDate(
      {bool isShowToast = false, bool isDelete = false}) async {
    await EstimateService.getInstance().deleteAllEstimateProduct();
    await EstimateService.getInstance().deleteAllEstimateAdditionalCharges();
    await EstimateService.getInstance().setCustomer(null);
    await EstimateService.getInstance().setDateTime(null);
    await EstimateService.getInstance().setEstimateEditUsingId(null);
    await EstimateService.getInstance().setAdditionalChargeId(null);
    await EstimateService.getInstance().setDiscountInAmt(null);
    await EstimateService.getInstance().setDiscountInPercentage(null);

    Navigator.pushReplacementNamed(context, '/estimates');
    if (isShowToast)
      Fluttertoast.showToast(
          msg: isDelete
              ? "Deleted Successfully"
              : _isEdit
                  ? "Update Estimate Details Successfully"
                  : "Added Estimate Details Sccessfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green.withOpacity(0.7),
          fontSize: 16.0);
  }
}
