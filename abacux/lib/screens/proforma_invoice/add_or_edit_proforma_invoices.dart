import 'dart:convert';

import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/helper/custom_string_helper.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/Product_model.dart';
import 'package:abacux/model/customer_model.dart';
import 'package:abacux/model/proforma_invoice_edit_using_id.dart';
import 'package:abacux/model/local_product_model.dart';
import 'package:abacux/services/customer_service.dart';
import 'package:abacux/services/proforma_invoice_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'add_product_proforma_invoices.dart';
import 'additional_charge_proforma_invoice.dart';

class AddOrEditproformaInvoicesScreen extends StatefulWidget {
  final ProformaInvoiceEditUsingId proformaInvoice;
  AddOrEditproformaInvoicesScreen({this.proformaInvoice});

  @override
  _AddOrEditproformaInvoicesScreenState createState() =>
      _AddOrEditproformaInvoicesScreenState();
}

class _AddOrEditproformaInvoicesScreenState
    extends State<AddOrEditproformaInvoicesScreen> {
  TextEditingController _customerName = TextEditingController();
  TextEditingController _billPrefix = TextEditingController();
  TextEditingController _poNumber = TextEditingController();
  TextEditingController _invoiceNo = TextEditingController();
  TextEditingController _invoiceDate = TextEditingController();
  TextEditingController _subTotal = TextEditingController();
  // TextEditingController _gstPercentage = TextEditingController();
  TextEditingController _cgst = TextEditingController();
  TextEditingController _sgst = TextEditingController();
  TextEditingController _igst = TextEditingController();
  TextEditingController _salesTax = TextEditingController();
  TextEditingController _total = TextEditingController();
  TextEditingController _totalDiscountAmt = TextEditingController();
  TextEditingController _totalDiscountPrecentage = TextEditingController();
  TextEditingController _roundOffAmount = TextEditingController();

  TextEditingController _dateController = TextEditingController();

  DateTime _date = DateTime.now();

  bool _isEdit = false;
  bool _isLoading = false;
  int proformaId; // For Edit Purpose only

  List<LocalProduct> productProformaInvoiceList = [];
  ProformaInvoiceEditUsingId proformaInvoiceEditUsingId;
  List<String> uuids = [];

  List<LocalAdditionalCharge> additionalChargeList = [];

  List<Customer> _customerList = [];
  Customer _selectedCustomer;

  int userId, companyId;
  String token;
  double totaladdtionalvalue = 0;
  int num = 100;
  double intialvalue = 0;

  bool _isVisible = true;

  List<Product> _productList = [];
  Product _selectedProduct;

  List additionalChargeIds = [];

  int deleteProformaInvoiceId;

  bool _isProductListVisible = true;
  bool _isAdditionalChargeVisible = true;

  List<String> _types = ["+ Add", "- Reduce"];
  String _selectedType;

  bool _isAutoRoundOff = false;
  // List<dynamic> additionalChargesList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check Internet Connection
    CheckConnectivity.getInstance().checkConnectivity(context);
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = dateFormat(_date);

    // _getProformaProduct();
    // _getAdditionalChargesList();
    _getUserAndCompanyId();
    _getProformaInvoiceProductFromLocal();
    _getAdditionalChargeFromLocal();

    _getVendor();
    _getDateTime();

    proformaInvoiceEditUsingId = ProformaInvoiceService.getInstance()
        .getProformaInvoiceEditUsingIdFromLocal;
    if (proformaInvoiceEditUsingId == null) {
      if (widget.proformaInvoice != null) {
        setState(() {
          _isEdit = true;
          _isVisible = true;
          _isLoading = true;
          proformaInvoiceEditUsingId = widget.proformaInvoice;
          deleteProformaInvoiceId = widget.proformaInvoice.proformainvoices.id;
          ProformaInvoiceService.getInstance()
              .setProformaInvoiceEditUsingId(widget.proformaInvoice);
          _loadProformaInvoiceValue(widget.proformaInvoice);
        });
      }
    } else {
      _isEdit = true;
      _isVisible = true;
      additionalChargeIds =
          ProformaInvoiceService.getInstance().getAdditionalChargeIds;
      deleteProformaInvoiceId = proformaInvoiceEditUsingId.proformainvoices.id;
      _selectedCustomer = ProformaInvoiceService.getInstance().getCustomer;
      _loadUnchangedDetails(proformaInvoiceEditUsingId);
    }
  }

  _getVendor() {
    Customer customer = ProformaInvoiceService.getInstance().getCustomer;
    setState(() {
      if (customer != null) {
        _selectedCustomer = customer;
      }
    });
  }

  _getDateTime() {
    DateTime dateTime = ProformaInvoiceService.getInstance().getDateTime;
    setState(() {
      if (dateTime != null) {
        _date = dateTime;
        _invoiceDate.text = _dateFormat(_date);
      }
    });
  }

  // Date Format
  String _dateFormat(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void viewDiscount() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  _getProformaInvoiceProductFromLocal() async {
    setState(() {
      productProformaInvoiceList = [];
    });
    await ProformaInvoiceService.getInstance()
        .getProformaInvoiceFromLocal()
        .then((value) {
      value.map((e) {
        String json = jsonEncode(e);
        print(json);
        setState(() {
          productProformaInvoiceList.add(LocalProduct.fromJson(e));
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
      productProformaInvoiceList.map((e) {
        totalBasicPrice += e.amount;
        salesTax += e.salesTax;
        subTotal += e.subTotal;
        cgst += e.cgst;
        sgst += e.sgst;
        igst += e.igst;
      }).toList();

      _total.text = totalBasicPrice.toString();
      _salesTax.text = salesTax.toString();
      _subTotal.text = subTotal.toString();
      _cgst.text = cgst.toString();
      _sgst.text = sgst.toString();
      _igst.text = igst.toString();
      String discountInAmt =
          ProformaInvoiceService.getInstance().getDiscountInAmt;
      String discountInPercentage =
          ProformaInvoiceService.getInstance().getDiscountInPercentage;
      print(discountInPercentage);
      print(discountInAmt);
      _totalDiscountAmt.text = discountInAmt == null
          ? widget.proformaInvoice != null
              ? widget.proformaInvoice.proformainvoices.discountInAmount
              : intialvalue.toString()
          : discountInAmt;
      _totalDiscountPrecentage.text = discountInPercentage == null
          ? widget.proformaInvoice != null
              ? widget.proformaInvoice.proformainvoices.discountInPercentage
              : intialvalue.toString()
          : discountInPercentage;
      updatePrecentageToDiscountAmt();
    });
  }

  _getAdditionalChargeFromLocal() async {
    setState(() {
      additionalChargeList = [];
    });
    await ProformaInvoiceService.getInstance()
        .getProformaAdditionalChargesFromLocal()
        .then((value) {
      value.map((e) {
        String json = jsonEncode(e);
        print(json);
        setState(() {
          additionalChargeList.add(LocalAdditionalCharge.fromJson(e));
        });
      }).toList();
    });

    _calculateAdditionalTotal();
  }

  _calculateAdditionalTotal() {
    double totalAmount = 0.0;

    // double salesTax = 0.0, subTotal = 0.0, cgst = 0.0, igst = 0.0, sgst = 0.0;

    setState(() {
      additionalChargeList.map((e) {
        totalAmount += e.additionalTotalAmount;
      }).toList();
      totaladdtionalvalue = double.parse(totalAmount.toString());
      _total.text =
          (double.parse(_total.text) + totalAmount - totaladdtionalvalue)
              .toString();
      print(_total.text);
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

    _getCustomerList();

    _getProformaSettings();

    _getPurchaseProduct();

    // Avoid to interrupt invoice no
    if (!_isEdit) _getProformaInvoiceNo();
  }

  _getCustomerList() async {
    Map body = {
      'user_id': userId.toString(),
      'token': token.toString(),
      'company_id': companyId.toString(),
    };
    await CustomerService().customerList(body).then((value) {
      setState(() {
        _customerList = value;
      });
    });
  }

  _getProformaSettings() async {
    Map body = {
      'user_id': userId.toString(),
      'token': token.toString(),
      'company_id': companyId.toString(),
    };
    await ProformaInvoiceService.getInstance()
        .getProformaSettings(body)
        .then((value) {
      value.map((e) {
        _billPrefix.text = e['prefix'];
      }).toList();
    });
  }

  _getProformaInvoiceNo() async {
    Map body = {
      'user_id': userId.toString(),
      'token': token.toString(),
    };
    await ProformaInvoiceService.getInstance()
        .getProformaInvoiceNo(body)
        .then((value) {
      _invoiceNo.text = value.toString();
    });
  }

  _getPurchaseProduct() async {
    Map body = {
      "user_id": userId.toString(),
      "company_id": companyId.toString(),
      "token": token
    };
    print(body);
    await ProformaInvoiceService.getInstance()
        .getProfromaProduct(body)
        .then((value) {
      setState(() {
        _productList = value;
      });
    });
  }

  String dateFormat(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  _loadUnchangedDetails(
      ProformaInvoiceEditUsingId proformaInvoiceEditUsingId) async {
    // await Future.delayed(Duration(milliseconds: 500), () {});
    setState(() {
      _invoiceNo.text = proformaInvoiceEditUsingId.proformainvoices.invoiceNo;
      _date = DateTime.parse(
          proformaInvoiceEditUsingId.proformainvoices.invoiceDate);
      _invoiceDate.text = _dateFormat(_date);
      _dateController.text = _dateFormat(_date);
    });
  }

  _loadProformaInvoiceValue(
      ProformaInvoiceEditUsingId proformaInvoiceEditUsingId) async {
    await Future.delayed(Duration(milliseconds: 3000), () {
      // Do something
    });
    setState(() {
      _loadUnchangedDetails(proformaInvoiceEditUsingId);

      _customerList.isNotEmpty
          ? _selectedCustomer = _customerList.firstWhere((element) =>
              element.id ==
              proformaInvoiceEditUsingId.proformainvoices.customerId)
          : null;
      print(_selectedCustomer);
      _customerName.text = _selectedCustomer.customerName;

      // Set Customer
      ProformaInvoiceService.getInstance().setCustomer(_selectedCustomer);

      _totalDiscountAmt.text =
          proformaInvoiceEditUsingId.proformainvoices.discountInAmount;
      _totalDiscountPrecentage.text =
          proformaInvoiceEditUsingId.proformainvoices.discountInPercentage;
      // Set Discount in amount and percentage
      ProformaInvoiceService.getInstance()
          .setDiscountInAmt(_totalDiscountAmt.text);
      ProformaInvoiceService.getInstance()
          .setDiscountInPercentage(_totalDiscountPrecentage.text);
      _subTotal.text = proformaInvoiceEditUsingId.proformainvoices.grossTotal;
      _total.text = proformaInvoiceEditUsingId.proformainvoices.grandTotal;

      String taxInfo = proformaInvoiceEditUsingId.proformainvoices.taxInfo
          .replaceAll('/', "");
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

      //insert Proforma Invoice Product To Local
      for (int i = 0;
          i < proformaInvoiceEditUsingId.proformaInvoiceProducts.length;
          i++) {
        _productList.isNotEmpty
            ? _selectedProduct = _productList.firstWhere((element) =>
                element.id ==
                proformaInvoiceEditUsingId.proformaInvoiceProducts[i].productId)
            : null;
        String productTaxInfo = proformaInvoiceEditUsingId
            .proformaInvoiceProducts[i].taxInfo
            .replaceAll("/", "");
        Map productTaxInfoBody = jsonDecode(productTaxInfo);
        Map body = _createBodyForProduct(
            i,
            proformaInvoiceEditUsingId.proformaInvoiceProducts[i],
            _selectedProduct,
            productTaxInfoBody);

        ProformaInvoiceService.getInstance()
            .insertProformaInvoiceProductToLocal(body);
      }

      //insert Proforma Additional Charges To Local
      for (int i = 0;
          i < proformaInvoiceEditUsingId.additionalCharges.length;
          i++) {
        additionalChargeIds
            .add(proformaInvoiceEditUsingId.additionalCharges[i].id);
        String additionalTaxInfo = proformaInvoiceEditUsingId
            .additionalCharges[i].taxPercentage
            .replaceAll("/", "");
        Map productTaxInfoBody = jsonDecode(additionalTaxInfo);
        Map body = _createBodyForAdditional(
            i,
            proformaInvoiceEditUsingId.additionalCharges[i],
            productTaxInfoBody);

        ProformaInvoiceService.getInstance()
            .insertProformaAdditionalChargesToLocal(body);
      }

      ProformaInvoiceService.getInstance()
          .setAdditionalChargeIds(additionalChargeIds);

      _getProformaInvoiceProductFromLocal();
      _getAdditionalChargeFromLocal();

      _isLoading = false;
    });
  }

  _createBodyForProduct(int id, ProformaProduct proformaProduct,
      Product product, Map productTaxInfoBody) {
    return {
      "id": id,
      "uuid": Uuid().v1(),
      "product": product.productName,
      "pid": proformaProduct.pid,
      "productId": product.id,
      "productUomsId": proformaProduct.uomId,
      "quantity": proformaProduct.quantity.toDouble(),
      "basicPrice": double.parse(product.purchasePrice),
      "price": double.parse(product.salesPrice),
      "taxTypeId": 0,
      "taxType": double.parse(productTaxInfoBody["tax_type"]),
      "tax": productTaxInfoBody["tax_percentage"] != "["
          ? double.parse(productTaxInfoBody["tax_percentage"])
          : 0.0,
      "discount": double.parse(_totalDiscountPrecentage.text),
      "discountAmount": double.parse(_totalDiscountAmt.text),
      "amount": double.parse(proformaProduct.grandTotal),
      "cgst": productTaxInfoBody["CGST9"] != null
          ? double.parse(productTaxInfoBody["CGST9"])
          : productTaxInfoBody["CGST14"] != null
              ? double.parse(productTaxInfoBody["CGST14"])
              : 0.0,
      "sgst": productTaxInfoBody["SGST9"] != null
          ? double.parse(productTaxInfoBody["SGST9"])
          : productTaxInfoBody["SGST14"] != null
              ? double.parse(productTaxInfoBody["SGST14"])
              : 0.0,
      "igst": productTaxInfoBody["IGST12.0"] != null
          ? double.parse(productTaxInfoBody["IGST12.0"])
          : 0.0,
      "salesTax": double.parse(productTaxInfoBody["tax_amount"]),
      "subTotal": double.parse(proformaProduct.grossTotal)
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _clearProformaLocalData();
        Navigator.pushReplacementNamed(context, "/proforma_invoices_screen");
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
                await ProformaInvoiceService.getInstance()
                    .deleteAllProductToLocal();
                ProformaInvoiceService.getInstance()
                    .deleteAllProformaAdditionalChargesToLocal();
                ProformaInvoiceService.getInstance().setCustomer(null);
                ProformaInvoiceService.getInstance().setDateTime(null);
                Navigator.pushReplacementNamed(
                    context, '/proforma_invoices_screen');
              }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                !_isEdit ? " Add proforma Invoices" : "Edit proforma Invoices",
                style: TextStyle(color: Colors.black),
              ),
              _isEdit
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
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
                              _deleteProformaInvoiceApi(
                                  deleteProformaInvoiceId);
                            });
                          }),
                    )
                  : Container(),
              GestureDetector(
                onTap: () {
                  createBodyForProformaInvoice();
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
        textField(_billPrefix, "Bill Prefix", isReadOnly: true),
        textField(_invoiceNo, "Invoice No", isReadOnly: true),
        // textField(_customerName, "Customer Name"),
        dropDownForCustomer(),
        dateTextField(),
        Padding(
          padding: const EdgeInsets.only(top: 25.0, left: 10.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, '/add_product_proforma_invoices');
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
                    )
                  ],
                ),
              ),
              productProformaInvoiceList.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _isProductListVisible = !_isProductListVisible;
                        });
                      },
                      child: _productAndAdditionalChargeListVisibility(
                          _isProductListVisible,
                          productProformaInvoiceList.length),
                    )
                  : Container(),
              productProformaInvoiceList.isEmpty && additionalChargeList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: _getAdditionalChargeWidget(),
                    )
                  : Container()
            ],
          ),
        ),
        productProformaInvoiceList.isEmpty
            ? Container()
            : Visibility(
                visible: _isProductListVisible,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: productProformaInvoiceList.length,
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
                                              '${productProformaInvoiceList[index].product}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '\u{20B9} ${productProformaInvoiceList[index].amount}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // Text(
                                    //   'Gst: ${productProformaInvoiceList[index].gstPercentage}% ',
                                    //   style: TextStyle(
                                    //       fontSize: 15, letterSpacing: 0.5),
                                    // ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Qty: ${productProformaInvoiceList[index].quantity}  | ',
                                          style: TextStyle(
                                              fontSize: 15, letterSpacing: 0.5),
                                        ),
                                        Text(
                                          'Price :${productProformaInvoiceList[index].price}',
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
                                                  productProformaInvoiceList[
                                                          index]
                                                      .pid,
                                                  productProformaInvoiceList[
                                                          index]
                                                      .uuid);
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
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddProductproformaInvoices(
                                                          productValue:
                                                              productProformaInvoiceList[
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

        productProformaInvoiceList.isEmpty && additionalChargeList.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 10.0),
                child: _getAdditionalChargeWidget(),
              ),

        additionalChargeList.isEmpty
            ? Container()
            : _getAdditionalChargesItem(),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Flexible(
                child: textField(_subTotal, "\u{20B9}  Sub Total",
                    isRow: true, isReadOnly: true),
              ),
              // Flexible(
              //   child: textField(_gstPercentage, "%  Gst", isRow: true),
              // ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Flexible(
                  child: textField(_cgst, "\u{20B9}  CGST",
                      isRow: true, isReadOnly: true)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Flexible(
                  child: textField(_sgst, "\u{20B9}  SGST",
                      isRow: true, isReadOnly: true)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Flexible(
                  child: textField(_igst, "\u{20B9}  IGST",
                      isRow: true, isReadOnly: true)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Flexible(
                  child: textField(_salesTax, "\u{20B9}  Sales Tax",
                      isReadOnly: true, isRow: true)),
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
                    child: textFieldDiscountPercentage(
                        _totalDiscountPrecentage, "% Percentage",
                        isRow: true)),
                Flexible(
                    child: textFieldDiscountAmt(
                        _totalDiscountAmt, "\u{20B9} Amount ",
                        isRow: true)),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Flexible(child: dropDownForType()),
            Flexible(
              child: textField(_roundOffAmount, "\u{20B9} Round Off Amount",
                  isReadOnly: _isAutoRoundOff ? true : false, isRow: true),
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
        textField(_total, "\u{20B9}  Total", isReadOnly: true),
      ],
    );
  }

  Widget _getAdditionalChargeWidget() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(
                context, '/additional_charge_proforma_invoice');
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
        additionalChargeList.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isAdditionalChargeVisible = !_isAdditionalChargeVisible;
                  });
                },
                child: _productAndAdditionalChargeListVisibility(
                    _isAdditionalChargeVisible, additionalChargeList.length),
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
        itemCount: additionalChargeList.length,
        physics: NeverScrollableScrollPhysics(),
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
                                  '${additionalChargeList[index].additonalChargeName}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\u{20B9} ${additionalChargeList[index].additionalTotalAmount}',
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
                                'Tax: ${additionalChargeList[index].additionalTaxPercentage}% ',
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
                                        additionalChargeList[index]
                                            .additionalChargeId,
                                        additionalChargeList[index].uuid);
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
                                          AdditionalChargeProformaInvoice(
                                            productValue:
                                                additionalChargeList[index],
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
      {String errorText,
      IconData prefixIcon,
      bool isRow = false,
      IconData suffixIcon,
      bool isReadOnly = false}) {
    // ignore: unnecessary_statements

    return Padding(
      padding: isRow ? const EdgeInsets.all(0.0) : const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextFormField(
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
            controller: controller,
            readOnly: isReadOnly,
            validator: (value) {
              if (value.isEmpty) {
                return errorText;
              }
              return null;
            },
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

  Widget dropDownForCustomer() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 0.4,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: DropdownSearch<Customer>(
              dropdownSearchDecoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 15.0),
                labelText: "Customer Name",
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
              selectedItem: _selectedCustomer,
              onChanged: (Customer customer) async {
                _selectedCustomer = customer;
                await ProformaInvoiceService.getInstance()
                    .setCustomer(customer);
              },
              mode: Mode.MENU,
              itemAsString: (Customer customer) => customer.customerName,
              items: _customerList,
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

  Widget dropDownForType() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 4.0),
      child: Container(
        // height: 93,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 0.4,
            // margin: EdgeInsets.only(top: 1, bottom: 1),
            child: DropdownSearch<String>(
              dropdownSearchDecoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 15.0),
                labelText: "Type",
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
              selectedItem: _selectedType,
              onChanged: (String type) async {
                _selectedType = type;
                setState(() {
                  _isAutoRoundOff = false;
                });
              },
              mode: Mode.MENU,
              itemAsString: (String type) => type,
              items: _types,
              showSearchBox: true,
              validator: (text) {
                if (text == null) {
                  return 'Type is empty';
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

  dateTextField() {
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
                        controller: _dateController,
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

    setState(() async {
      _date = pickedDate;
      _dateController.text = dateFormat(_date);
      await ProformaInvoiceService.getInstance().setDateTime(_date);
    });
  }

  Widget textFieldDiscountPercentage(
      TextEditingController controller, String hintText,
      {IconData prefixIcon, bool isRow = false, IconData suffixIcon}) {
    // ignore: unnecessary_statements

    return Padding(
      padding: isRow ? const EdgeInsets.all(0.0) : const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextFormField(
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
            controller: controller,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return "";
              }
              return null;
            },
            onChanged: (value) {
              updatePrecentageToDiscountAmt();
              ProformaInvoiceService.getInstance()
                  .setDiscountInPercentage(value);
            },
            onSaved: (val) => setState(
                () => controller = double.parse(val) as TextEditingController),
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

  Widget textFieldDiscountAmt(TextEditingController controller, String hintText,
      {IconData prefixIcon, bool isRow = false, IconData suffixIcon}) {
    return Padding(
      padding: isRow ? const EdgeInsets.all(0.0) : const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextFormField(
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
            controller: controller,
            validator: (value) {
              if (value.isEmpty) {
                return "";
              }
              return null;
            },
            onChanged: (value) {
              updateDiscountAmtTOprecentage();
              ProformaInvoiceService.getInstance().setDiscountInAmt(value);
            },
            onSaved: (val) => setState(
                () => controller = double.parse(val) as TextEditingController),
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

  _deleteProductusingPid(int pid, String uuid) async {
    if (_isEdit) {
      Map body = {
        "user_id": userId.toString(),
        "company_id": companyId.toString(),
        "token": token,
        "pid": pid.toString()
      };
      await ProformaInvoiceService.getInstance()
          .deleteProformaProductUsingPid(body)
          .then((value) {
        _deleteProductToLocal(uuid);
      });
    } else
      _deleteProductToLocal(uuid);
  }

  _deleteProductToLocal(String uuid) {
    ProformaInvoiceService.getInstance()
        .deleteProductUsingUuidToLocal(uuid)
        .then((value) {
      _getProformaInvoiceProductFromLocal();
      Navigator.of(context).pop();
    });
  }

  _deleteAdditionalChargeApi(int id, String uuid) async {
    if (_isEdit) {
      Map body = {
        "user_id": userId.toString(),
        // "company_id": companyId.toString(),
        "token": token,
        "deleteid": id.toString()
      };
      await ProformaInvoiceService.getInstance()
          .deleteAdditionalChargeApi(body)
          .then((value) {
        _deleteAdditonalChargeToLocal(uuid);
      }).catchError((onError) {});
    } else {
      _deleteAdditonalChargeToLocal(uuid);
    }
  }

  _deleteAdditonalChargeToLocal(String uuid) async {
    await ProformaInvoiceService.getInstance()
        .deleteProformaAdditionalChargesToLocal(uuid)
        .then((value) {
      _getAdditionalChargeFromLocal();
      _getProformaInvoiceProductFromLocal();
      Navigator.of(context).pop();
    });
  }

  _deleteProformaInvoiceApi(int id) async {
    Map body = {
      "user_id": userId.toString(),
      "company_id": companyId.toString(),
      "token": token,
      "id": id.toString()
    };

    await ProformaInvoiceService.getInstance()
        .deleteProformaInvoiceApi(body)
        .then((value) {
      _clearProformaLocalData(isShowToast: true, isDelete: true);
      Navigator.of(context).pop();
      Navigator.pushNamed(context, "/proforma_invoices_screen");
    });
  }

  updateDiscountAmtTOprecentage() {
    if (_total.text.trim() != '') {
      try {
        double _discountAmount = double.parse(_totalDiscountAmt.text);
        double _salestaxprice = double.parse(_salesTax.text);
        double _subtotalprice = double.parse(_subTotal.text);
        double _finalPrice =
            _salestaxprice + _subtotalprice + totaladdtionalvalue;
        double _discountPrecendage = (_discountAmount / _finalPrice) * num;
        _totalDiscountPrecentage.text =
            CustomStringHelper().formattDoubleToString(_discountPrecendage);
        _total.text = CustomStringHelper()
            .formattDoubleToString((_finalPrice) - _discountAmount);
        ProformaInvoiceService.getInstance()
            .setDiscountInPercentage(_totalDiscountPrecentage.text);
      } on Exception catch (exception) {} catch (error) {}
    }
  }

  updatePrecentageToDiscountAmt() {
    if (_total.text.trim() != '') {
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
        _total.text = CustomStringHelper()
            .formattDoubleToString((_finalPrice) - _discountPrice);
        ProformaInvoiceService.getInstance()
            .setDiscountInAmt(_totalDiscountAmt.text);
      } on Exception catch (exception) {} catch (error) {}
    }
  }

  createBodyForProformaInvoice() {
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

    productProformaInvoiceList.map((e) {
      productids.add(e.productId);
      uomIds.add(e.productUomsId);
      quantities.add(e.quantity.toInt());
      baseRates.add(e.basicPrice);
      purchaseRates.add(e.price);
      pTaxTypes.add(e.taxType);
      ptaxInfos.add(e.tax);
      pDiscounts.add(e.discount);
      pDiscountAmounts.add(e.discountAmount);
      pGrandTotals.add(e.amount);
      pGrossTotals.add(e.subTotal);
      pTaxAmounts.add(e.salesTax);
    }).toList();

    print(additionalChargeList);

    additionalChargeList.map((e) {
      additionalChargeNames.add(e.additonalChargeName);
      additionalChargeAmounts.add(e.addtionalChargeAmount);
      additionalTaxTypes.add(e.additionalTaxType);
      additionalTaxPercentages.add(e.additionalTaxPercentage);
      additionalTotalAmounts.add(e.additionalTotalAmount);
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
      "prefix": "",
      "invoice_no": _invoiceNo.text,
      "customer_id": _selectedCustomer.id.toString(),
      "payment_due_date": "",
      "quotation_settings": "1",
      "hidden_prefix": "PO",
      "invoice_date": _date.toString(),
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
      "grand_total": stringAsFixed(double.parse(_total.text)).toString()
    };

    if (_isEdit) {
      body["proforma_id"] =
          proformaInvoiceEditUsingId.proformainvoices.id.toString();

      if (additionalChargeNames.length > additionalChargeIds.length) {
        int count = additionalChargeNames.length - additionalChargeIds.length;
        for (int i = 1; i <= count; i++) {
          additionalChargeIds.add(0);
        }
      }
      body["additional_charge_id"] = additionalChargeIds.toString();
    }

    _postProformaInvoiceStore(body);
  }

  double stringAsFixed(double value) {
    return double.parse((value).toStringAsFixed(3));
  }

  _postProformaInvoiceStore(Map body) async {
    String _body = jsonEncode(body);
    print(_body);
    print(body);
    if (_isEdit) {
      await ProformaInvoiceService.getInstance()
          .updateProformaInvoiceStore(body)
          .then((value) {
        _clearProformaLocalData(isShowToast: true);
      });
    } else {
      await ProformaInvoiceService.getInstance()
          .postProformaInvoiceStore(body)
          .then((value) async {
        _clearProformaLocalData(isShowToast: true);
      });
    }
  }

  _clearProformaLocalData({bool isShowToast = false, bool isDelete = false}) {
    ProformaInvoiceService.getInstance().deleteAllProductToLocal();
    ProformaInvoiceService.getInstance()
        .deleteAllProformaAdditionalChargesToLocal();
    ProformaInvoiceService.getInstance().setCustomer(null);
    ProformaInvoiceService.getInstance().setDateTime(null);
    ProformaInvoiceService.getInstance().setProformaInvoiceEditUsingId(null);
    ProformaInvoiceService.getInstance().setAdditionalChargeIds(null);
    ProformaInvoiceService.getInstance().setDiscountInPercentage(null);
    ProformaInvoiceService.getInstance().setDiscountInAmt(null);
    if (isShowToast)
      Fluttertoast.showToast(
          msg: isDelete
              ? "Deleted Successfully"
              : _isEdit
                  ? "Updated Estimate Details Successfully"
                  : "Added Estimate Details Sccessfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green.withOpacity(0.7),
          fontSize: 16.0);

    Navigator.pushReplacementNamed(context, '/proforma_invoices_screen');
  }
}
