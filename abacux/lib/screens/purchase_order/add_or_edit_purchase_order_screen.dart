import 'dart:convert';

import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/helper/custom_string_helper.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/Product_model.dart';
import 'package:abacux/model/purchase_order_edit_using_id.dart';
import 'package:abacux/model/vendor_model.dart';
import 'package:abacux/screens/purchase_order/add_or_edit_adiditional%20_charges.dart';
import 'package:abacux/screens/purchase_order/add_or_edit_product_purchase_order.dart';
import 'package:abacux/services/purchase_order_service.dart';
import 'package:abacux/services/vendor_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddOrEditPurchaseOrderScreen extends StatefulWidget {
  const AddOrEditPurchaseOrderScreen({this.purchaseOrder});

  final PurchaseOrderEditUsingId purchaseOrder;

  @override
  _AddOrEditPurchaseOrderScreenState createState() =>
      _AddOrEditPurchaseOrderScreenState();
}

class _AddOrEditPurchaseOrderScreenState
    extends State<AddOrEditPurchaseOrderScreen> {
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

  TextEditingController total = TextEditingController();

  PurchaseOrderEditUsingId _purchaseOrderEditUsingId;

  DateTime _date = DateTime.now();
  int num = 100;
  double intialvalue = 0;
  bool _isEdit = false;
  int purchaseOrderId; // For Edit Purpose only
  double totaladdtionalvalue = 0;
  bool _isVisible = true;
  bool _isProductListVisible = true;
  bool _isAdditionalChargeVisible = true;
  bool _isLoading = false;

  void viewDiscount() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  List<Vendor> _vendorDetails = [];
  Vendor _selectedVendor;

  int userId, companyId, purchaseOrderNumber;
  String token;

  List<dynamic> productList = [];

  List<dynamic> additionalChargesList = [];

  List<Product> _productList = [];
  Product _selectedProduct;

  List additionalChargeIds = [];

  int purchaseOrderDeleteId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check Internet Connection
    CheckConnectivity.getInstance().checkConnectivity(context);
  }

  @override
  void initState() {
    super.initState();
    billPrefix.text = "PO";
    _setDateTime();
    _getUserAndCompanyId();
    if (widget.purchaseOrder == null) {
      _getPurchaseProduct();
      _getAdditionalChargesValueFromLocal();
    }
    _getVendor();
    _getDateTime();

    _purchaseOrderEditUsingId =
        PurchaseOrderService.getInstance().getPurchaseOrderEditUsingIdValue;

    if (_purchaseOrderEditUsingId == null) {
      if (widget.purchaseOrder != null) {
        setState(() {
          _isEdit = true;
          _isVisible = true;
          _isLoading = true;
          _purchaseOrderEditUsingId = widget.purchaseOrder;
          purchaseOrderDeleteId = widget.purchaseOrder.purchaseOrders.id;
          PurchaseOrderService.getInstance()
              .setPurchaseOrderEditUsingId(widget.purchaseOrder);
          _loadPurchaseOrderEditUsingId(widget.purchaseOrder);
        });
      }
    } else {
      setState(() {
        _isEdit = true;
        _isVisible = true;
        additionalChargeIds =
            PurchaseOrderService.getInstance().getAdditionalChargeIds;
        purchaseOrderDeleteId = _purchaseOrderEditUsingId.purchaseOrders.id;
        _selectedVendor = PurchaseOrderService.getInstance().getVendor;
        _loadUnchangedValue(_purchaseOrderEditUsingId);
      });
    }
  }

  // Is Edit Start

  _loadUnchangedValue(PurchaseOrderEditUsingId purchaseOrderEditUsingId) {
    setState(() {
      poNo.text = purchaseOrderEditUsingId.purchaseOrders.poNo;
      _date = DateTime.parse(purchaseOrderEditUsingId.purchaseOrders.poDate);
      purchaseOrderDate.text = _dateFormat(_date);
    });
  }

  _loadPurchaseOrderEditUsingId(
      PurchaseOrderEditUsingId purchaseOrderEditUsingId) async {
    await Future.delayed(Duration(milliseconds: 3000), () {
      // Do something
    });

    setState(() {
      _loadUnchangedValue(purchaseOrderEditUsingId);

      _vendorDetails.isNotEmpty
          ? _selectedVendor = _vendorDetails.firstWhere((element) =>
              element.id == purchaseOrderEditUsingId.purchaseOrders.vendorId)
          : null;

      // Set Vendor details
      PurchaseOrderService.getInstance().setVendor(_selectedVendor);

      _totalDiscountAmt.text =
          purchaseOrderEditUsingId.purchaseOrders.discountInAmount;
      _totalDiscountPrecentage.text =
          purchaseOrderEditUsingId.purchaseOrders.discountInPercentage;
      // Set Discount in amount and percentage
      PurchaseOrderService.getInstance()
          .setDiscountInAmt(_totalDiscountAmt.text);
      PurchaseOrderService.getInstance()
          .setDiscountInPercenatge(_totalDiscountPrecentage.text);
      _subTotal.text = purchaseOrderEditUsingId.purchaseOrders.grossTotal;
      total.text = purchaseOrderEditUsingId.purchaseOrders.grandTotal;

      _isVisible = true;

      String taxInfo =
          purchaseOrderEditUsingId.purchaseOrders.taxInfo.replaceAll('/', "");
      List taxInfoBody = jsonDecode(taxInfo);
      taxInfoBody.map((e) {
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
    });

    print("SGST ${_sgst.text} - ${_cgst.text} - ${_igst.text}");

    //insert Proforma Invoice Product To Local
    for (int i = 0;
        i < purchaseOrderEditUsingId.purchaseOrderProducts.length;
        i++) {
      _productList.isNotEmpty
          ? _selectedProduct = _productList.firstWhere((element) {
              print(
                  "element.id ${element.id} - purchaseOrderProducts ${purchaseOrderEditUsingId.purchaseOrderProducts[i].productId}");
              return element.id ==
                  purchaseOrderEditUsingId.purchaseOrderProducts[i].productId;
            })
          : null;
      String productTaxInfo = purchaseOrderEditUsingId
          .purchaseOrderProducts[i].taxInfo
          .replaceAll("/", "");
      Map productTaxInfoBody = jsonDecode(productTaxInfo);
      Map body = _createBodyForProduct(
          i,
          purchaseOrderEditUsingId.purchaseOrderProducts[i],
          _selectedProduct,
          productTaxInfoBody);

      PurchaseOrderService.getInstance().insertPurchaseProductFromLocal(body);
    }

    //insert Proforma Additional Charges To Local
    for (int i = 0;
        i < purchaseOrderEditUsingId.additionalCharges.length;
        i++) {
      additionalChargeIds.add(purchaseOrderEditUsingId.additionalCharges[i].id);
      String additionalTaxInfo = purchaseOrderEditUsingId
          .additionalCharges[i].taxPercentage
          .replaceAll("/", "");
      Map productTaxInfoBody = jsonDecode(additionalTaxInfo);
      Map body = _createBodyForAdditional(
          i, purchaseOrderEditUsingId.additionalCharges[i], productTaxInfoBody);

      PurchaseOrderService.getInstance().insertPurchaseAdditionalCharges(body);
    }

    PurchaseOrderService.getInstance()
        .setAdditionalChargeIds(additionalChargeIds);

    _getPurchaseProduct();
    _getAdditionalChargesValueFromLocal();
    setState(() {
      _isLoading = false;
    });
  }

  _createBodyForProduct(int id, PurchaseOrderProduct purchaseOrderproduct,
      Product product, Map productTaxInfoBody) {
    return {
      "id": id,
      "uuid": Uuid().v1(),
      "product": product.productName,
      "pid": purchaseOrderproduct.pid,
      "productId": product.id,
      "productUomsId": purchaseOrderproduct.uomId,
      "quantity": purchaseOrderproduct.quantity.toDouble(),
      "basicPrice": double.parse(product.purchasePrice),
      "price": double.parse(product.salesPrice),
      "taxTypeId": 0,
      "taxType": double.parse(productTaxInfoBody["tax_type"]),
      "tax": productTaxInfoBody["tax_percentage"] != "["
          ? double.parse(productTaxInfoBody["tax_percentage"])
          : 0.0,
      "discount": double.parse(_totalDiscountPrecentage.text),
      "discountAmount": double.parse(_totalDiscountAmt.text),
      "amount": double.parse(purchaseOrderproduct.grandTotal),
      "cgst": productTaxInfoBody["CGST14"] != null
          ? double.parse(productTaxInfoBody["CGST14"])
          : productTaxInfoBody["CGST9"] != null
              ? double.parse(productTaxInfoBody["CGST9"])
              : 0.0,
      "sgst": productTaxInfoBody["SGST14"] != null
          ? double.parse(productTaxInfoBody["SGST14"])
          : productTaxInfoBody["SGST9"] != null
              ? double.parse(productTaxInfoBody["SGST9"])
              : 0.0,
      "igst": productTaxInfoBody["IGST12.0"] != null
          ? double.parse(productTaxInfoBody["IGST12.0"])
          : 0.0,
      "salesTax": double.parse(productTaxInfoBody["tax_amount"]),
      "subTotal": double.parse(purchaseOrderproduct.grossTotal)
    };
  }

  _createBodyForAdditional(
      int id, AdditionalCharge additionalCharge, Map productTaxInfoBody) {
    return {
      "id": id,
      "uuid": Uuid().v1(),
      "additionalCharge": additionalCharge.additonalChargeName,
      "additionalChargeId": additionalCharge.id,
      "amount": double.parse(additionalCharge.addtionalChargeAmount),
      "taxType": double.parse(productTaxInfoBody['tax_type']),
      "tax": double.parse(productTaxInfoBody['tax_percentage']),
      "totalAmount": double.parse(additionalCharge.totalAmount),
    };
  }

  // Is Edit End

  // Get selected vendor from service using Get Method
  _getVendor() {
    Vendor vendor = PurchaseOrderService.getInstance().getVendor;
    setState(() {
      if (vendor != null) {
        _selectedVendor = vendor;
        vendorName.text = vendor.vendor_name;
      }
    });
  }

  // Get selected Date from service using Get Method
  _getDateTime() {
    DateTime dateTime = PurchaseOrderService.getInstance().getDateTime;
    setState(() {
      if (dateTime != null) {
        _date = dateTime;
        purchaseOrderDate.text = _dateFormat(_date);
      }
    });
  }

  // Get Purchase Order from Local db
  _getPurchaseProduct() async {
    setState(() {
      productList = [];
    });
    await PurchaseOrderService.getInstance()
        .getPurchaseProductFromLocal()
        .then((value) {
      value.map((e) {
        setState(() {
          productList.add(e);
        });
      }).toList();
    });

    //Condition To avoid unwanted interruption of GST calculation
    _calculateTotal();
  }

  // Calculate Total, SGST, CGST, IGST, SalesTax value
  _calculateTotal() {
    double totalBasicPrice = 0.0,
        salesTax = 0.0,
        subTotal = 0.0,
        cgst = 0.0,
        igst = 0.0,
        sgst = 0.0;
    setState(() {
      // print(productList.length);
      // for (int i = 0; i <= productList.length; i++) {
      //   print(productList[i]);
      //   totalBasicPrice += productList[i]['amount'];
      //   salesTax += productList[i]['salesTax'];
      //   subTotal += productList[i]['subTotal'];
      //   cgst += productList[i]['cgst'];
      //   sgst += productList[i]['sgst'];
      //   igst += productList[i]['igst'];
      // }
      print(productList);
      productList.map((e) {
        print("cgst-${e['cgst']},sgst-${e['sgst']},igst-${e['igst']}");
        totalBasicPrice += e['amount'];
        salesTax += e['salesTax'];
        subTotal += e['subTotal'];
        cgst += e['cgst'];
        sgst += e['sgst'];
        igst += e['igst'];
      }).toList();

      print("$cgst $sgst $igst");

      total.text = totalBasicPrice.toString();
      _salesTax.text = salesTax.toString();
      _subTotal.text = subTotal.toString();
      _cgst.text = cgst.toString();
      _sgst.text = sgst.toString();
      _igst.text = igst.toString();
      String discountInAmt =
          PurchaseOrderService.getInstance().getDiscountInAmt;
      String discountInPercentage =
          PurchaseOrderService.getInstance().getDiscountInPercentage;
      print(discountInPercentage);
      print(discountInAmt);
      _totalDiscountAmt.text = discountInAmt == null
          ? widget.purchaseOrder != null
              ? widget.purchaseOrder.purchaseOrders.discountInAmount
              : intialvalue.toString()
          : discountInAmt;
      _totalDiscountPrecentage.text = discountInPercentage == null
          ? widget.purchaseOrder != null
              ? widget.purchaseOrder.purchaseOrders.discountInPercentage
              : intialvalue.toString()
          : discountInPercentage;
      updatePrecentageToDiscountAmt();
    });
  }

  // Calculate Additional value
  _calculateAdditionalTotal() {
    double totalAmount = 0.0;

    setState(() {
      additionalChargesList.map((e) {
        totalAmount += e['totalAmount'];
      }).toList();
      totaladdtionalvalue = double.parse(totalAmount.toString());
      total.text =
          (double.parse(total.text.isEmpty ? "0.0" : total.text) + totalAmount)
              .toString();
      print(total.text);
    });
  }

  _getAdditionalChargesValueFromLocal() async {
    setState(() {
      additionalChargesList = [];
    });
    await PurchaseOrderService.getInstance()
        .getPurchaseAdditionalFromLocal()
        .then((value) {
      print(value);
      setState(() {
        value.map((e) {
          additionalChargesList.add(e);
        }).toList();
      });
      print(additionalChargesList);

      _calculateAdditionalTotal();
    });
  }

  _setDateTime() {
    purchaseOrderDate.text = _dateFormat(_date);
  }

  _getPurchaseOrderNumber() async {
    Map body = {
      "user_id": userId.toString(),
      "token": token,
    };
    await PurchaseOrderService.getInstance()
        .getPurchaseOrderNumber(body)
        .then((value) {
      purchaseOrderNumber = value;
      poNo.text = value.toString();
    });
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

    _getProduct();
    // Get purchase number
    if (!_isEdit) _getPurchaseOrderNumber();
    // Call Customer listing service
    _getVendorList();
  }

  _getProduct() async {
    Map body = {
      "user_id": userId.toString(),
      "company_id": companyId.toString(),
      "token": token
    };
    print(body);
    await PurchaseOrderService.getInstance()
        .getPurchaseProduct(body)
        .then((value) {
      setState(() {
        _productList = value;
      });
    });
  }

  // Get Customer Listing
  _getVendorList() async {
    Map body = {
      'user_id': userId.toString(),
      'token': token.toString(),
      'company_id': companyId.toString(),
    };
    print("Customer User $body");
    await VendorService().vendorList(body).then((value) {
      _vendorDetails = value;
    });
    _sortByName();
  }

  _sortByName() {
    setState(() {
      _vendorDetails.sort((a, b) {
        print("${a.vendor_name}:${b.vendor_name}");
        return a.vendor_name == null
            ? 0
            : b.vendor_name == null
                ? 0
                : a.vendor_name
                    .toLowerCase()
                    .compareTo(b.vendor_name.toLowerCase());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _clearPurchaseOrder();
        Navigator.pushReplacementNamed(context, "/purchase_order_screen");
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
              onPressed: () async {
                // Back to PO listing screen
                await PurchaseOrderService.getInstance()
                    .deleteAllPurchaseProduct()
                    .then((value) async {
                  await PurchaseOrderService.getInstance()
                      .deleteAllPurchaseAdditionalCharges()
                      .then((value) {
                    PurchaseOrderService.getInstance().setVendor(null);
                    PurchaseOrderService.getInstance().setDateTime(null);
                    Navigator.pushReplacementNamed(
                        context, '/purchase_order_screen');
                  });
                });
              }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isEdit ? "Edit Purchase Order" : "Add Purchase Order",
                style: TextStyle(color: Colors.black),
              ),
              _isEdit
                  ? GestureDetector(
                      onTap: () {
                        _showModelDialog(
                            "Delete", "Are you sure wnat to delete?",
                            buttonText1: "No",
                            buttonText2: "Yes", onPressedButton1: () {
                          Navigator.of(context).pop();
                        }, onPressedButton2: () {
                          _deletePurchaseOrderApi(purchaseOrderDeleteId);
                        });
                      },
                      child: Icon(
                        Icons.delete,
                        color: AppConstant().appThemeColor,
                      ),
                    )
                  : Container(),
              GestureDetector(
                onTap: () {
                  _createBodyForPurchaseOrder();
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
    );
  }

  Widget _getColumnWidget() {
    return Column(
      children: [
        textField(billPrefix, "Bill Prefix", isRead: true),
        textField(poNo, "Po Number", isRead: true),
        dropDown(),
        dateTextField(),
        Padding(
          padding: const EdgeInsets.only(top: 25.0, left: 10.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, '/add_purchase_order_product_screen');
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
                  ? Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isProductListVisible = !_isProductListVisible;
                          });
                        },
                        child: _productAndAdditionalChargeListVisibility(
                            _isProductListVisible, productList.length),
                      ),
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
                  itemCount: productList.length,
                  physics: NeverScrollableScrollPhysics(),
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
                                                        AddOrEditProductPurchaseOrder(
                                                          productValue:
                                                              productList[
                                                                  index],
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
                    isRow: true, isRead: true),
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
                    child: textField(_totalDiscountPrecentage, "% Percentage",
                        isRow: true, onChanged: (value) {
                  updatePrecentageToDiscountAmt();
                  PurchaseOrderService.getInstance()
                      .setDiscountInPercenatge(value);
                })),
                Flexible(
                    child: textField(_totalDiscountAmt, "\u{20B9} Amount ",
                        isRow: true, onChanged: (value) {
                  updateDiscountAmtTOprecentage();
                  PurchaseOrderService.getInstance().setDiscountInAmt(value);
                })),
              ],
            ),
          ),
        ),
        textField(total, "\u{20B9}  Total", isRead: true),
      ],
    );
  }

  Widget _getAdditionalChargeWidget() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(
                context, '/add_additional_charge_screen');
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
            ? Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAdditionalChargeVisible =
                            !_isAdditionalChargeVisible;
                      });
                    },
                    child: _productAndAdditionalChargeListVisibility(
                        _isAdditionalChargeVisible,
                        additionalChargesList.length)),
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
                                      "Delete", "Are you sure want to delete?",
                                      buttonText1: "No",
                                      buttonText2: "Yes", onPressedButton1: () {
                                    Navigator.of(context).pop();
                                  }, onPressedButton2: () {
                                    _deleteAdditionalChargeApi(
                                        additionalChargesList[index]['uuid'],
                                        additionalChargesList[index]
                                            ['additionalChargeId']);
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
                                          AddOrEditAdditionalCharges(
                                            productValue:
                                                additionalChargesList[index],
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

  Widget textField(TextEditingController controller, String hintText,
      {IconData prefixIcon,
      bool isRow = false,
      bool isRead = false,
      IconData suffixIcon,
      Function onChanged}) {
    // ignore: unnecessary_statements

    return Padding(
      padding: isRow ? const EdgeInsets.all(0.0) : const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextFormField(
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
            readOnly: isRead,
            controller: controller,
            validator: (value) {
              if (value.isEmpty) {
                return "";
              }
              return null;
            },
            onChanged: (value) => onChanged(value),
            decoration: InputDecoration(
              labelText: hintText,
              // hintText: hintText,
              labelStyle: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w600),
              prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
              suffixIcon: suffixIcon == null
                  ? null
                  : Icon(
                      suffixIcon,
                      color: AppConstant().appThemeColor,
                    ),
              fillColor: Color(0xFFEEEEFF),
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDown() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 0.4,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: DropdownSearch<Vendor>(
              dropdownSearchDecoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 15.0),
                labelText: "Vendor Name",
                labelStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w600),
                filled: true,
                fillColor: Color(0xFFFFFF),
                contentPadding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              showSelectedItem: false,
              selectedItem: _selectedVendor,
              onChanged: (Vendor value) async {
                _selectedVendor = value;
                await PurchaseOrderService.getInstance().setVendor(value);
              },
              mode: Mode.MENU,
              itemAsString: (Vendor vendor) => vendor.vendor_name,
              items: _vendorDetails,
              showSearchBox: true,
              validator: (text) {
                if (text == null) {
                  return 'Vendor name is empty';
                }
                return null;
              },
              searchBoxDecoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                // labelText: "Employee Name",
              ),
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

  _deleteProductusingPid(String uuid, int pid) async {
    if (_isEdit) {
      Map body = {
        "user_id": userId.toString(),
        "company_id": companyId.toString(),
        "token": token,
        "pid": pid.toString()
      };
      // Delete api for estimate product
      await PurchaseOrderService.getInstance()
          .deletePurchaseOrderProductUsingId(body)
          .then((value) {
        _deletePurchaseProductToLocal(uuid);
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
    } else
      _deletePurchaseProductToLocal(uuid);
  }

  _deletePurchaseProductToLocal(String uuid) {
    // Delete Local data
    PurchaseOrderService.getInstance().deletePurchaseProductUsingId(uuid);
    Navigator.of(context).pop();
    _getPurchaseProduct();
  }

  _deleteAdditionalChargeApi(String uuid, int id) async {
    if (_isEdit) {
      Map body = {
        "user_id": userId.toString(),
        // "company_id": companyId.toString(),
        "token": token,
        "deleteid": id.toString()
      };
      await PurchaseOrderService.getInstance()
          .deleteAdditionalChargeApi(body)
          .then((value) {
        _deleteAdditionalChargeLocal(uuid);
      });
    } else {
      _deleteAdditionalChargeLocal(uuid);
    }
  }

  _deleteAdditionalChargeLocal(String uuid) async {
    await PurchaseOrderService.getInstance()
        .deletePurchaseAdditionalCharges(uuid)
        .then((value) {
      _getPurchaseProduct();
      _getAdditionalChargesValueFromLocal();
      Navigator.of(context).pop();
    });
  }

  _deletePurchaseOrderApi(int id) async {
    Map body = {
      "user_id": userId.toString(),
      "company_id": companyId.toString(),
      "token": token,
      "id": id.toString()
    };

    await PurchaseOrderService.getInstance()
        .deletePurchaseOrderApi(body)
        .then((value) {
      Navigator.of(context).pop();
      _clearPurchaseOrder(isShowToast: true, isDelete: true);
    });
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
        _totalDiscountPrecentage.text =
            CustomStringHelper().formattDoubleToString(_discountPrecendage);
        total.text = CustomStringHelper()
            .formattDoubleToString((_finalPrice) - _discountAmount);
        PurchaseOrderService.getInstance()
            .setDiscountInPercenatge(_totalDiscountPrecentage.text);
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
        PurchaseOrderService.getInstance()
            .setDiscountInPercenatge(_totalDiscountAmt.text);
      } on Exception catch (exception) {} catch (error) {}
    }
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
      PurchaseOrderService.getInstance().setDateTime(pickedDate);
    });
  }

  // Date Format
  String _dateFormat(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  _createBodyForPurchaseOrder() {
    if (productList.isEmpty) {
    } else {
      List productids = [];
      List uomIds = [];
      List quantities = [];
      List baseRates = [];
      List purchaseRates = [];
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
        productids.add(e['productId']);
        uomIds.add(e['productUomsId']);
        quantities.add(e['quantity'].toInt());
        baseRates.add(e['basicPrice']);
        purchaseRates.add(e['price']);
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
        "po_no": poNo.text,
        "vendor_id": _selectedVendor.id.toString(),
        "po_no_settings": "1",
        "hidden_prefix": billPrefix.text,
        "po_date": _date.toString(),
        "product_id": productids.toString(),
        "uom_id": uomIds.toString(),
        "quantity": quantities.toString(),
        "base_rate": baseRates.toString(),
        "purchase_rate": purchaseRates.toString(),
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
        body["po_id"] = _purchaseOrderEditUsingId.purchaseOrders.id.toString();
        if (additionalChargeNames.length > additionalChargeIds.length) {
          int count = additionalChargeNames.length - additionalChargeIds.length;
          for (int i = 1; i <= count; i++) {
            additionalChargeIds.add(0);
          }
        }
        body["additional_charge_id"] = additionalChargeIds.toString();
      }

      _postPurchaseOrderStore(body);
    }
  }

  double stringAsFixed(double value) {
    return double.parse((value).toStringAsFixed(3));
  }

  _postPurchaseOrderStore(Map body) async {
    String _body = jsonEncode(body);
    print(_body);
    if (_isEdit) {
      await PurchaseOrderService.getInstance()
          .updatePurchaseOrderStore(body)
          .then((value) async {
        _clearPurchaseOrder(isShowToast: true);
      });
    } else {
      await PurchaseOrderService.getInstance()
          .postPurchaseOrderStore(body)
          .then((value) async {
        _clearPurchaseOrder(isShowToast: true);
      });
    }
  }

  _clearPurchaseOrder({bool isShowToast = false, bool isDelete = false}) {
    PurchaseOrderService.getInstance().deleteAllPurchaseProduct();
    PurchaseOrderService.getInstance().deleteAllPurchaseAdditionalCharges();

    PurchaseOrderService.getInstance().setVendor(null);
    PurchaseOrderService.getInstance().setDateTime(null);
    PurchaseOrderService.getInstance().setPurchaseOrderEditUsingId(null);
    PurchaseOrderService.getInstance().setAdditionalChargeIds(null);
    PurchaseOrderService.getInstance().setDiscountInAmt(null);
    PurchaseOrderService.getInstance().setDiscountInPercenatge(null);
    PurchaseOrderService.getInstance().setInvoiceNo(null);

    if (isShowToast)
      Fluttertoast.showToast(
          msg: isDelete
              ? "Deleted successfully"
              : _isEdit
                  ? "Updated Estimate Details Successfully"
                  : "Added Estimate Details Sccessfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          timeInSecForIosWeb: 3,
          fontSize: 16.0);

    Navigator.pushReplacementNamed(context, '/purchase_order_screen');
  }
}
