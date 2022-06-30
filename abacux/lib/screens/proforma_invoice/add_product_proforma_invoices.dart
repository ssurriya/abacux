import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/helper/custom_string_helper.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/Product_model.dart';
import 'package:abacux/model/local_product_model.dart';
import 'package:abacux/services/generl_dropdown_list_service.dart';
import 'package:abacux/services/proforma_invoice_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddProductproformaInvoices extends StatefulWidget {
  const AddProductproformaInvoices({this.productValue});

  final LocalProduct productValue;

  @override
  _AddProductproformaInvoicesState createState() =>
      _AddProductproformaInvoicesState();
}

class _AddProductproformaInvoicesState
    extends State<AddProductproformaInvoices> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _basicPriceController = TextEditingController();
  TextEditingController _priceBeforeTaxController = TextEditingController();
  TextEditingController _taxTypeController = TextEditingController();
  TextEditingController _taxNumController = TextEditingController();
  TextEditingController _discountPercentageController = TextEditingController();
  TextEditingController _discountAmountController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  int quantity = 1;
  int discountAmt = 0;
  int discountPrecentage = 0;
  double _sgst = 0;
  double _cgst = 0;
  double _igst = 0;
  double _subTotal = 0;
  double _salesTax = 0;
  List<Product> _productList = [];
  Product _selectedProduct;
  List<dynamic> _taxType = [];
  dynamic _selectedTaxType;
  int pid = 0;
  int proformaInclusiveTaxStatus;
  int userId, companyId;
  String token;

  int proformaProductIndex = 0;
  int num = 100;
  Map<String, dynamic> proformaProduct = {};

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    _getUserAndCompanyId();
    _getProformaProductIndex();
    if (widget.productValue != null) {
      _loadProductValues();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check Internet Connection
    CheckConnectivity.getInstance().checkConnectivity(context);
  }

  _loadProductValues() {
    setState(() {
      isEdit = true;
      _productNameController.text = widget.productValue.product;
      pid = widget.productValue.pid;
      _quantityController.text = widget.productValue.quantity.toString();
      _basicPriceController.text = widget.productValue.basicPrice.toString();
      _priceBeforeTaxController.text = widget.productValue.price.toString();
      _taxTypeController.text = widget.productValue.taxType.toString();
      _taxNumController.text = widget.productValue.tax.toString();
      _discountPercentageController.text =
          widget.productValue.discount.toString();
      _discountAmountController.text =
          widget.productValue.discountAmount.toString();
      _amountController.text = widget.productValue.amount.toString();
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
    // Call Tax Type
    _getTaxType();
    // Call Customer listing service
    _getPurchaseProduct();
  }

  void _getTaxType() async {
    Map body = {
      "company_id": companyId.toString(),
      "user_id": userId.toString(),
      "token": token.toString(),
    };
    await DropdownService().taxclasstaxtype(body).then((value) {
      setState(() {
        this._taxType = value;

        if (isEdit == true) {
          _selectedTaxType = value.firstWhere((e) =>
              e['id'].toString() == widget.productValue.taxType.toString());
        }
      });
    });
  }

  onchangedTax() {
    if (_selectedProduct.taxPercentage != null &&
        _selectedProduct.taxPercentage != "null") {
      _taxNumController.text = _selectedProduct.taxPercentage.toString();
    } else {
      _taxNumController.text = "0";
    }
    if (_selectedProduct.taxClassTaxId.toString() != null &&
        _selectedProduct.taxClassTaxId.toString() != "null") {
      _selectedTaxType = _taxType.firstWhere((e) =>
          e['id'].toString() == _selectedProduct.taxClassTaxId.toString());
    }
  }

  _getPurchaseProduct() async {
    Map body = {
      "user_id": userId.toString(),
      "company_id": companyId.toString(),
      "token": token
    };
    print(body);
    await DropdownService().getProductList(body).then((value) {
      setState(() {
        _productList = value;

        if (isEdit == true) {
          _selectedProduct = value.firstWhere(
              (e) => e.productName == widget.productValue.product.toString());
        }
      });
    });
  }

  _getProformaProductIndex() async {
    await ProformaInvoiceService.getInstance()
        .getProformaInvoiceFromLocal()
        .then((value) {
      setState(() {
        proformaProductIndex = value.length;
      });
    });
  }

  _insertPurchaseProductToLocal() async {
    _loadPurchaseProductValue();
    print(proformaProduct);
    await ProformaInvoiceService.getInstance()
        .insertProformaInvoiceProductToLocal(proformaProduct)
        .then((value) {
      Navigator.pushReplacementNamed(context, '/add_proforma_invoices');
    });
  }

  _updatePurchaseProductToLocal() async {
    _loadPurchaseProductValue();
    print(proformaProduct);
    await ProformaInvoiceService.getInstance()
        .updateProformaInvoiceProductToLocal(proformaProduct)
        .then((value) {
      Navigator.pushReplacementNamed(context, '/add_proforma_invoices');
    });
  }

  _loadPurchaseProductValue() {
    proformaProduct = {
      "id": isEdit ? widget.productValue.id : proformaProductIndex,
      "uuid": isEdit ? widget.productValue.uuid : Uuid().v1(),
      "product": _selectedProduct.productName,
      "pid": pid == 0 ? 0 : pid,
      "productId": _selectedProduct.id,
      "productUomsId": _selectedProduct.umosId,
      "quantity": double.parse(_quantityController.text),
      "basicPrice": double.parse(_basicPriceController.text),
      "price": double.parse(_priceBeforeTaxController.text),
      "taxTypeId": _selectedTaxType['tax_id'].toString(),
      "taxType": _selectedTaxType['id'].toString(),
      "tax": double.parse(_taxNumController.text),
      "discount": double.parse(_discountPercentageController.text),
      "discountAmount": double.parse(_discountAmountController.text),
      "amount": double.parse(_amountController.text),
      "cgst": _cgst,
      "sgst": _sgst,
      "igst": _igst,
      "salesTax": _salesTax,
      "subTotal": _subTotal
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/add_proforma_invoices");
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
                Navigator.pushReplacementNamed(
                    context, '/add_proforma_invoices');
              }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEdit ? "Edit Items" : "Add Items",
                style: TextStyle(color: Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    isEdit
                        ? _updatePurchaseProductToLocal()
                        : _insertPurchaseProductToLocal();
                  }
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: AppConstant().appThemeColor),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  // textField(productName, "Product Name", "Select Product Name"),
                  dropDownForProduct(),
                  textField(_quantityController, "Quantity", "Enter Quantity",
                      onChanged: () {
                    updateAllValuesChanges();
                  }),
                  textField(
                      _basicPriceController, "₹ Basic Price", "Enter the price",
                      onChanged: () {
                    updateAllValuesChanges();
                  }),
                  textField(_priceBeforeTaxController, "₹ Price (Before Tax)",
                      "Enter the price(Before Tax)", onChanged: () {
                    setState(() {
                      updateBeforeTaxToBasicPriceChanges();
                    });
                  }),
                  // textField(taxType, "Tax type", "Select Tax Type"),
                  dropDownForTaxType(),
                  textField(_taxNumController, "% Tax", "Enter tax",
                      onChanged: () {
                    updateAllValuesChanges();
                  }),
                  // textField(bin, "Bin", "Enter bin"),

                  textField(_discountPercentageController, "% Discount",
                      "Enter the discount", onChanged: () {
                    updateAllValuesChanges();
                  }),
                  textField(_discountAmountController, "₹ Discount Amount",
                      "Enter the discount amount", onChanged: () {
                    updateDiscountprecentage();
                  }),
                  textField(_amountController, "₹ Amount", "Enter the amount"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(
      TextEditingController controller, String hintText, String errorText,
      {IconData prefixIcon, Function onChanged}) {
    // ignore: unnecessary_statements

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextFormField(
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
            controller: controller,
            validator: (value) {
              if (value.isEmpty) {
                return errorText;
              }
              return null;
            },
            onChanged: (value) {
              updateAllValuesChanges();
            },
            onSaved: (val) => setState(
                () => controller = double.parse(val) as TextEditingController),
            decoration: InputDecoration(
              labelText: hintText,
              labelStyle: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w600),
              prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
              fillColor: Color(0xFFEEEEFF),
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDownForProduct() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 0.4,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: DropdownSearch<Product>(
              dropdownSearchDecoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 15.0),
                labelText: "Product",
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
              selectedItem: _selectedProduct,
              onChanged: (value) {
                setState(() {
                  _selectedProduct = value;
                  _basicPriceController.text =
                      _selectedProduct.purchasePrice.toString();
                  _quantityController.text = quantity.toString();
                  _discountAmountController.text = discountAmt.toString();
                  _discountPercentageController.text =
                      discountPrecentage.toString();
                  proformaInclusiveTaxStatus =
                      _selectedProduct.purchasePriceInclusiveTax;

                  if (proformaInclusiveTaxStatus == null ||
                      proformaInclusiveTaxStatus == "null" ||
                      proformaInclusiveTaxStatus == "") {
                    proformaInclusiveTaxStatus = 1;
                  }
                  onchangedTax();
                  updateAllValuesChanges();
                });
              },
              mode: Mode.MENU,
              itemAsString: (Product product) => product.productName,
              items: _productList,
              showSearchBox: true,
              validator: (text) {
                if (text == null) {
                  return 'Select Product Name';
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

  //1
  void updateBeforeTaxToBasicPriceChanges() {
    if (_basicPriceController.text.trim() != '' &&
        _taxNumController.text.trim() != '') {
      try {
        double _gstPercentageNo = double.parse(_taxNumController.text);
        double _discountPercentageNo =
            double.parse(_discountPercentageController.text);
        double _numberOfQty = double.parse(_quantityController.text);
        double _priceBeforeTax = double.parse(_priceBeforeTaxController.text);
        double _getTaxAmount = (_priceBeforeTax * _gstPercentageNo) / num;
        double _totalAmount = (_priceBeforeTax + _getTaxAmount) * _numberOfQty;

        double _getAllTaxAmount =
            _totalAmount - (_totalAmount * (num / (num + _gstPercentageNo)));
        double _priceBeforeAmt = _totalAmount - _getAllTaxAmount;

        if (proformaInclusiveTaxStatus == 0) {
          //if inclusive tax

          _basicPriceController.text = CustomStringHelper()
              .formattDoubleToString(_priceBeforeTax + _getTaxAmount);

          double _getDiscountvalue =
              _priceBeforeAmt - (_priceBeforeAmt * _discountPercentageNo / num);
          _discountAmountController.text = CustomStringHelper()
              .formattDoubleToString((_priceBeforeAmt - _getDiscountvalue));

          double _discountAmount = (_totalAmount * _discountPercentageNo / num);

          //Total
          _amountController.text = CustomStringHelper()
              .formattDoubleToString((_totalAmount) - _discountAmount);
          double _finalamount = double.parse(_amountController.text);

          _salesTax =
              (_getTaxAmount - (_getTaxAmount * _discountPercentageNo / num)) *
                  _numberOfQty;
          _subTotal = _finalamount - _salesTax;

          if (_selectedTaxType["tax_percentage"] == _gstPercentageNo &&
              _selectedTaxType["tax_id"] == 1) {
            _cgst = _salesTax / 2;
            _sgst = _salesTax / 2;
          }
          if (_selectedTaxType["tax_percentage"] == _gstPercentageNo &&
              _selectedTaxType["tax_id"] == 2) {
            _igst = _salesTax;
          }
        }
        if (proformaInclusiveTaxStatus == 1) {
          double _getTaxPrecentage = (_priceBeforeTax * _gstPercentageNo) / num;
          _basicPriceController.text =
              CustomStringHelper().formattDoubleToString(_priceBeforeTax);

          double _getTotalAmount =
              (_priceBeforeTax + _getTaxPrecentage) * _numberOfQty;

          double _discountPrice =
              ((_priceBeforeTax * _discountPercentageNo) / num) * _numberOfQty;
          double _totaldiscountPrice =
              ((_getTotalAmount * _discountPercentageNo) / num);

          _discountAmountController.text =
              CustomStringHelper().formattDoubleToString(_discountPrice);

          //Total
          _amountController.text = CustomStringHelper()
              .formattDoubleToString((_getTotalAmount) - _totaldiscountPrice);
          //Total tax calculation
          double _finalamount = double.parse(_amountController.text);
          _salesTax =
              (_getTaxAmount - (_getTaxAmount * _discountPercentageNo / num)) *
                  _numberOfQty;

          _subTotal = _finalamount - _salesTax;
          if (_selectedTaxType["tax_percentage"] == _gstPercentageNo &&
              _selectedTaxType["tax_id"] == 1) {
            _cgst = _salesTax / 2;
            ;
            _sgst = _salesTax / 2;
          }
          if (_selectedTaxType["tax_percentage"] == _gstPercentageNo &&
              _selectedTaxType["tax_id"] == 2) {
            _igst = _salesTax;
          }
        }
      } on Exception catch (exception) {} catch (error) {}
    }
  }

  void updateAllValuesChanges() {
    if (_basicPriceController.text.trim() != '' &&
        _taxNumController.text.trim() != '') {
      try {
        double _originalPrice = double.parse(_basicPriceController.text);
        double _gstPercentageNo = double.parse(_taxNumController.text);
        double _discountPercentageNo =
            double.parse(_discountPercentageController.text);
        double _numberOfQty = double.parse(_quantityController.text);

        double _getTaxAmount = _originalPrice -
            (_originalPrice * (num / (num + _gstPercentageNo)));

        double _getTaxPrecentage = (_originalPrice * _gstPercentageNo) / num;

        double _productOfQtyTax = _getTaxPrecentage * _numberOfQty;

        double _priceBeforeAmt = _originalPrice - _getTaxAmount;
        if (proformaInclusiveTaxStatus == 0) {
          //if inclusive tax
          double _productOfOtyPrice = _numberOfQty * _originalPrice;

          //price before tax
          _priceBeforeTaxController.text = CustomStringHelper()
              .formattDoubleToString(_originalPrice - _getTaxAmount);

          double _totalAmount =
              _productOfOtyPrice + _productOfQtyTax - _productOfQtyTax;

          double _getDiscountvalue =
              _priceBeforeAmt - (_priceBeforeAmt * _discountPercentageNo / num);
          _discountAmountController.text = CustomStringHelper()
              .formattDoubleToString(
                  (_priceBeforeAmt - _getDiscountvalue) * _numberOfQty);
          double _discountAmount = (_totalAmount * _discountPercentageNo / num);

          _amountController.text = CustomStringHelper()
              .formattDoubleToString((_totalAmount) - _discountAmount);

          //Total tax calculation
          double _finalamount = double.parse(_amountController.text);
          _salesTax =
              (_getTaxAmount - (_getTaxAmount * _discountPercentageNo / num)) *
                  _numberOfQty;
          _subTotal = _finalamount - _salesTax;

          if (_selectedTaxType["tax_percentage"] == _gstPercentageNo &&
              _selectedTaxType["tax_id"] == 1) {
            _cgst = _salesTax / 2;
            _sgst = _salesTax / 2;
          }
          if (_selectedTaxType["tax_percentage"] == _gstPercentageNo &&
              _selectedTaxType["tax_id"] == 2) {
            _igst = _salesTax;
          }
        }
        if (proformaInclusiveTaxStatus == 1) {
          //if Exclusive tax

          _priceBeforeTaxController.text =
              CustomStringHelper().formattDoubleToString(_originalPrice);

          double _getTotalAmount =
              (_originalPrice + _getTaxPrecentage) * _numberOfQty;

          double _discountPrice =
              ((_originalPrice * _discountPercentageNo) / num) * _numberOfQty;
          double _totaldiscountPrice =
              ((_getTotalAmount * _discountPercentageNo) / num);

          _discountAmountController.text =
              CustomStringHelper().formattDoubleToString(_discountPrice);

          //Total
          _amountController.text = CustomStringHelper()
              .formattDoubleToString((_getTotalAmount) - _totaldiscountPrice);

          double _finalamount = double.parse(_amountController.text);

          _salesTax = (_getTaxPrecentage -
                  (_getTaxPrecentage * _discountPercentageNo / num)) *
              _numberOfQty;

          _subTotal = _finalamount - _salesTax;

//Total tax calculation
          if (_selectedTaxType["tax_percentage"] == _gstPercentageNo &&
              _selectedTaxType["tax_id"] == 1) {
            _cgst = _salesTax / 2;

            _sgst = _salesTax / 2;
          }
          if (_selectedTaxType["tax_percentage"] == _gstPercentageNo &&
              _selectedTaxType["tax_id"] == 2) {
            _igst = _salesTax;
          }
        }
      } on Exception catch (exception) {} catch (error) {}
    }
  }

  updateDiscountprecentage() {
    if (_basicPriceController.text.trim() != '' &&
        _taxNumController.text.trim() != '') {
      try {
        double _originalPrice = double.parse(_basicPriceController.text);
        double _gstPercentageNo = double.parse(_taxNumController.text);
        double _discountValue = double.parse(_discountAmountController.text);
        double _numberOfQty = double.parse(_quantityController.text);
        if (proformaInclusiveTaxStatus == 0) {
          double _productOfOtyPrice = _numberOfQty * _originalPrice;
          double _getTaxAmount = _originalPrice -
              (_originalPrice * (num / (num + _gstPercentageNo)));
          double _priceBeforeAmt = _originalPrice - _getTaxAmount;
          double _getTaxPrecentage = (_originalPrice * _gstPercentageNo) / num;
          double _productOfQtyTax = _getTaxPrecentage * _numberOfQty;
          double _discountPrecendage = (_discountValue / _priceBeforeAmt) * num;
          _discountPercentageController.text = CustomStringHelper()
              .formattDoubleToString(_discountPrecendage / _numberOfQty);

          double _totalAmount =
              _productOfOtyPrice + _productOfQtyTax - _productOfQtyTax;

          double _discountAmount = (_totalAmount * _discountPrecendage / num);
          _amountController.text = CustomStringHelper().formattDoubleToString(
              (_totalAmount) - (_discountAmount / _numberOfQty));
          double _finalamount = double.parse(_amountController.text);
          _salesTax =
              (_getTaxAmount - (_getTaxAmount * _discountPrecendage / num)) *
                  _numberOfQty;
          _subTotal = _finalamount - _salesTax;
//Total tax calculation

          if (_selectedTaxType["tax_percentage"] == _gstPercentageNo &&
              _selectedTaxType["tax_id"] == 1) {
            _cgst = _salesTax / 2;

            _sgst = _salesTax / 2;
          }
          if (_selectedTaxType["tax_percentage"] == _gstPercentageNo &&
              _selectedTaxType["tax_id"] == 2) {
            _igst = _salesTax;
          }
        }
        if (proformaInclusiveTaxStatus == 1) {
          //if Exclusive tax
          double _getTaxValue = (_discountValue / _originalPrice) * 100;
          double _getTaxPrecentage = (_originalPrice * _gstPercentageNo) / num;
          double _getTotalAmount =
              (_originalPrice + _getTaxPrecentage) * _numberOfQty;
          double _totaldiscountPrice = ((_getTotalAmount * _getTaxValue) / num);
          double _discountPresentage = _getTaxValue / _numberOfQty;

          _discountPercentageController.text =
              CustomStringHelper().formattDoubleToString(_discountPresentage);
          _amountController.text = CustomStringHelper()
              .formattDoubleToString((_getTotalAmount) - _totaldiscountPrice);
          double _finalamount = double.parse(_amountController.text);
          _salesTax = (_getTaxPrecentage -
                  (_getTaxPrecentage * _discountPresentage / num)) *
              _numberOfQty;
          _subTotal = _finalamount - _salesTax;
//Total tax calculation
          if (_selectedTaxType["tax_percentage"] == _gstPercentageNo &&
              _selectedTaxType["tax_id"] == 1) {
            _cgst = _salesTax / 2;

            _sgst = _salesTax / 2;
          }
          if (_selectedTaxType["tax_percentage"] == _gstPercentageNo &&
              _selectedTaxType["tax_id"] == 2) {
            _igst = _salesTax;
          }
        }
      } on Exception catch (exception) {} catch (error) {}
    }
  }

  Widget dropDownForTaxType() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 0.4,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: DropdownSearch<dynamic>(
              dropdownSearchDecoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 15.0),
                labelText: "Tax Type",
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
              selectedItem: _selectedTaxType,
              onChanged: (value) {
                setState(() {
                  _selectedTaxType = value;
                  _taxNumController.text =
                      _selectedTaxType["tax_percentage"].toString();
                  updateAllValuesChanges();
                });
              },
              mode: Mode.MENU,
              itemAsString: (dynamic taxType) =>
                  taxType["tax"].toString() +
                  "-" +
                  taxType["tax_percentage"].toString() +
                  "%",
              items: _taxType,
              showSearchBox: true,
              validator: (text) {
                if (text == null) {
                  return 'Select Tax class';
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
}
