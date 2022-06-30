import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/helper/custom_string_helper.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/Product_model.dart';
import 'package:abacux/services/generl_dropdown_list_service.dart';
import 'package:abacux/services/purchase_bill_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'add_or_edit_purchase_bill_screen.dart';

class AddProductPurchaseBill extends StatefulWidget {
  static const route = "/add_product_purchase_bill";
  const AddProductPurchaseBill({this.productValue, this.isUpdate = false});

  final dynamic productValue;
  final bool isUpdate;

  @override
  _AddProductPurchaseBillState createState() => _AddProductPurchaseBillState();
}

class _AddProductPurchaseBillState extends State<AddProductPurchaseBill> {
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
  int _pid = 0;
  List<Product> _productList = [];
  Product _selectedProduct;
  List<dynamic> _taxType = [];
  dynamic _selectedTaxType;
  int purchaseInclusiveTaxStatus;
  int userId, companyId;
  String token;

  int purchaseBillProductIndex = 0;
  int num = 100;
  Map<String, dynamic> purchaseBillProduct = {};

  bool isEdit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check Internet Connection
    CheckConnectivity.getInstance().checkConnectivity(context);
  }

  @override
  void initState() {
    super.initState();
    print(widget.isUpdate);
    _getUserAndCompanyId();
    _getPurchaseBillProductIndex();
    if (widget.productValue != null) {
      _loadProductValues();
    }
  }

  _loadProductValues() {
    setState(() {
      isEdit = true;
      _productNameController.text = widget.productValue['product'];
      _pid = widget.productValue['pid'] == 0 ? 0 : widget.productValue['pid'];
      _quantityController.text = widget.productValue['quantity'].toString();
      _basicPriceController.text = widget.productValue['basicPrice'].toString();
      _priceBeforeTaxController.text = widget.productValue['price'].toString();
      _taxTypeController.text = widget.productValue['taxType'].toString();
      _taxNumController.text = widget.productValue['tax'].toString();
      _discountPercentageController.text =
          widget.productValue['discount'].toString();
      _discountAmountController.text =
          widget.productValue['discountAmount'].toString();
      _amountController.text = widget.productValue['amount'].toString();
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
    // Call Get BIn

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
              e['id'].toString() == widget.productValue['taxType'].toString());
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
          _selectedProduct = value.firstWhere((e) =>
              e.productName == widget.productValue['product'].toString());
        }
      });
    });
  }

  _getPurchaseBillProductIndex() async {
    await PurchaseBillService.getInstance()
        .getPurchaseBillProductFromLocal()
        .then((value) {
      setState(() {
        purchaseBillProductIndex = value.length;
      });
    });
  }

  _insertPurchaseBillProductToLocal() async {
    _loadPurchaseBillProductValue();
    print(purchaseBillProduct);
    await PurchaseBillService.getInstance()
        .insertPurchaseBillProductFromLocal(purchaseBillProduct)
        .then((value) {
      Navigator.pushReplacementNamed(
          context, AddOrEditPurchaseBillScreen.route);
    });
  }

  _updatePurchaseBillProductToLocal() async {
    _loadPurchaseBillProductValue();
    await PurchaseBillService.getInstance()
        .updatePurchaseBillProductToLocal(
            purchaseBillProduct, widget.productValue['uuid'])
        .then((value) {
      Navigator.pushReplacementNamed(
          context, AddOrEditPurchaseBillScreen.route);
    });
  }

  _loadPurchaseBillProductValue() {
    purchaseBillProduct = {
      "id": isEdit
          ? widget.productValue['id']
          : widget.isUpdate
              ? purchaseBillProductIndex + 1
              : purchaseBillProductIndex,
      "uuid": isEdit ? widget.productValue['uuid'] : Uuid().v1(),
      "product": _selectedProduct.productName,
      "pid": _pid,
      "productId": _selectedProduct.id,
      "productUomsId": _selectedProduct.umosId,
      "quantity": double.parse(_quantityController.text),
      "basicPrice": double.parse(_basicPriceController.text),
      "price": double.parse(_priceBeforeTaxController.text),
      "taxType": _selectedTaxType['id'],
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
    return Scaffold(
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
                  context, AddOrEditPurchaseBillScreen.route);
            }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isEdit ? "Edit Purchase Bill Items" : "Add Purchase Bill Items",
              style: TextStyle(color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState.validate()) {
                  isEdit
                      ? _updatePurchaseBillProductToLocal()
                      : _insertPurchaseBillProductToLocal();
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // textField(productName, "Product Name", "Select Product Name"),
                dropDownForProduct(),
                textField_1(_quantityController, "Quantity", "Enter Quantity"),
                textField_2(
                  _basicPriceController,
                  "₹ Basic Price",
                  "Enter the price",
                ),
                textField_3(_priceBeforeTaxController, "₹ Price (Before Tax)",
                    "Enter the price(Before Tax)"),
                // textField(taxType, "Tax type", "Select Tax Type"),
                dropDownForTaxType(),
                textField_5(_taxNumController, "% Tax", "Enter tax"),
                // textField(bin, "Bin", "Enter bin"),

                textField_6(
                  _discountPercentageController,
                  "% Discount",
                  "Enter the discount",
                ),
                textField_7(_discountAmountController, "₹ Discount Amount",
                    "Enter the discount amount"),
                textField_8(_amountController, "₹ Amount", "Enter the amount"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField_1(
    TextEditingController controller,
    String hintText,
    String errorText, {
    IconData prefixIcon,
  }) {
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

  Widget textField_2(
    TextEditingController controller,
    String hintText,
    String errorText, {
    IconData prefixIcon,
  }) {
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

  Widget textField_3(
    TextEditingController controller,
    String hintText,
    String errorText, {
    IconData prefixIcon,
  }) {
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
            onSaved: (val) => setState(
                () => controller = double.parse(val) as TextEditingController),
            onChanged: (value) {
              setState(() {
                updateBeforeTaxToBasicPriceChanges();
              });
              //
            },
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

  Widget textField_4(
    TextEditingController controller,
    String hintText,
    String errorText, {
    IconData prefixIcon,
  }) {
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

  Widget textField_5(
    TextEditingController controller,
    String hintText,
    String errorText, {
    IconData prefixIcon,
  }) {
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

  Widget textField_6(
    TextEditingController controller,
    String hintText,
    String errorText, {
    IconData prefixIcon,
  }) {
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

  Widget textField_7(
    TextEditingController controller,
    String hintText,
    String errorText, {
    IconData prefixIcon,
  }) {
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
              updateDiscountprecentage();
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

  Widget textField_8(
    TextEditingController controller,
    String hintText,
    String errorText, {
    IconData prefixIcon,
  }) {
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
            readOnly: true,
            validator: (value) {
              if (value.isEmpty) {
                return errorText;
              }
              return null;
            },
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
                // suffixIcon: GestureDetector(
                //   onTap: () {},
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 14.0),
                //     child: Icon(Icons.add_circle_outline),
                //   ),
                // ),
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
                  purchaseInclusiveTaxStatus =
                      _selectedProduct.purchasePriceInclusiveTax;

                  if (purchaseInclusiveTaxStatus == null ||
                      purchaseInclusiveTaxStatus == "null" ||
                      purchaseInclusiveTaxStatus == "") {
                    purchaseInclusiveTaxStatus = 1;
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
        double _OriginalPrice = double.parse(_basicPriceController.text);
        double _gstPercentageNo = double.parse(_taxNumController.text);
        double _discountPercentageNo =
            double.parse(_discountPercentageController.text);
        double _NumberOfQty = double.parse(_quantityController.text);
        double _priceBeforeTax = double.parse(_priceBeforeTaxController.text);
        double _getTaxAmount = (_priceBeforeTax * _gstPercentageNo) / num;
        double _TotalAmount = (_priceBeforeTax + _getTaxAmount) * _NumberOfQty;

        double _getAllTaxAmount =
            _TotalAmount - (_TotalAmount * (num / (num + _gstPercentageNo)));
        double _PriceBeforeAmt = _TotalAmount - _getAllTaxAmount;

        if (purchaseInclusiveTaxStatus == 0) {
          //if inclusive tax

          _basicPriceController.text = CustomStringHelper()
              .formattDoubleToString(_priceBeforeTax + _getTaxAmount);

          double _getDiscountvalue =
              _PriceBeforeAmt - (_PriceBeforeAmt * _discountPercentageNo / num);
          _discountAmountController.text = CustomStringHelper()
              .formattDoubleToString((_PriceBeforeAmt - _getDiscountvalue));

          double _discountAmount = (_TotalAmount * _discountPercentageNo / num);

          //Total
          _amountController.text = CustomStringHelper()
              .formattDoubleToString((_TotalAmount) - _discountAmount);
          double _finalamount = double.parse(_amountController.text);

          _salesTax =
              (_getTaxAmount - (_getTaxAmount * _discountPercentageNo / num)) *
                  _NumberOfQty;
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
        if (purchaseInclusiveTaxStatus == 1) {
          double _getTaxPrecentage = (_priceBeforeTax * _gstPercentageNo) / num;
          _basicPriceController.text =
              CustomStringHelper().formattDoubleToString(_priceBeforeTax);

          double _getTotalAmount =
              (_priceBeforeTax + _getTaxPrecentage) * _NumberOfQty;

          double _discountPrice =
              ((_priceBeforeTax * _discountPercentageNo) / num) * _NumberOfQty;
          double _TotaldiscountPrice =
              ((_getTotalAmount * _discountPercentageNo) / num);

          _discountAmountController.text =
              CustomStringHelper().formattDoubleToString(_discountPrice);

          //Total
          _amountController.text = CustomStringHelper()
              .formattDoubleToString((_getTotalAmount) - _TotaldiscountPrice);
          //Total tax calculation
          double _finalamount = double.parse(_amountController.text);
          _salesTax =
              (_getTaxAmount - (_getTaxAmount * _discountPercentageNo / num)) *
                  _NumberOfQty;

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
        double _OriginalPrice = double.parse(_basicPriceController.text);
        double _gstPercentageNo = double.parse(_taxNumController.text);
        double _discountPercentageNo =
            double.parse(_discountPercentageController.text);
        double _NumberOfQty = double.parse(_quantityController.text);

        double _getTaxAmount = _OriginalPrice -
            (_OriginalPrice * (num / (num + _gstPercentageNo)));

        double _getTaxPrecentage = (_OriginalPrice * _gstPercentageNo) / num;

        double _ProductOfQtyTax = _getTaxPrecentage * _NumberOfQty;

        double _PriceBeforeAmt = _OriginalPrice - _getTaxAmount;
        if (purchaseInclusiveTaxStatus == 0) {
          //if inclusive tax
          double _ProductOfOtyPrice = _NumberOfQty * _OriginalPrice;

          //price before tax
          _priceBeforeTaxController.text = CustomStringHelper()
              .formattDoubleToString(_OriginalPrice - _getTaxAmount);

          double _TotalAmount =
              _ProductOfOtyPrice + _ProductOfQtyTax - _ProductOfQtyTax;

          double _getDiscountvalue =
              _PriceBeforeAmt - (_PriceBeforeAmt * _discountPercentageNo / num);
          _discountAmountController.text = CustomStringHelper()
              .formattDoubleToString(
                  (_PriceBeforeAmt - _getDiscountvalue) * _NumberOfQty);
          double _discountAmount = (_TotalAmount * _discountPercentageNo / num);

          _amountController.text = CustomStringHelper()
              .formattDoubleToString((_TotalAmount) - _discountAmount);

          //Total tax calculation
          double _finalamount = double.parse(_amountController.text);
          _salesTax =
              (_getTaxAmount - (_getTaxAmount * _discountPercentageNo / num)) *
                  _NumberOfQty;
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
        if (purchaseInclusiveTaxStatus == 1) {
          //if Exclusive tax

          _priceBeforeTaxController.text =
              CustomStringHelper().formattDoubleToString(_OriginalPrice);

          double _getTotalAmount =
              (_OriginalPrice + _getTaxPrecentage) * _NumberOfQty;

          double _discountPrice =
              ((_OriginalPrice * _discountPercentageNo) / num) * _NumberOfQty;
          double _TotaldiscountPrice =
              ((_getTotalAmount * _discountPercentageNo) / num);

          _discountAmountController.text =
              CustomStringHelper().formattDoubleToString(_discountPrice);

          //Total
          _amountController.text = CustomStringHelper()
              .formattDoubleToString((_getTotalAmount) - _TotaldiscountPrice);

          double _finalamount = double.parse(_amountController.text);

          _salesTax = (_getTaxPrecentage -
                  (_getTaxPrecentage * _discountPercentageNo / num)) *
              _NumberOfQty;

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
        double _OriginalPrice = double.parse(_basicPriceController.text);
        double _gstPercentageNo = double.parse(_taxNumController.text);
        double _discountValue = double.parse(_discountAmountController.text);
        double _NumberOfQty = double.parse(_quantityController.text);
        if (purchaseInclusiveTaxStatus == 0) {
          double _ProductOfOtyPrice = _NumberOfQty * _OriginalPrice;
          double _getTaxAmount = _OriginalPrice -
              (_OriginalPrice * (num / (num + _gstPercentageNo)));
          double _PriceBeforeAmt = _OriginalPrice - _getTaxAmount;
          double _getTaxPrecentage = (_OriginalPrice * _gstPercentageNo) / num;
          double _ProductOfQtyTax = _getTaxPrecentage * _NumberOfQty;
          double _discountPrecendage = (_discountValue / _PriceBeforeAmt) * num;
          _discountPercentageController.text = CustomStringHelper()
              .formattDoubleToString(_discountPrecendage / _NumberOfQty);

          double _TotalAmount =
              _ProductOfOtyPrice + _ProductOfQtyTax - _ProductOfQtyTax;

          double _discountAmount = (_TotalAmount * _discountPrecendage / num);
          _amountController.text = CustomStringHelper().formattDoubleToString(
              (_TotalAmount) - (_discountAmount / _NumberOfQty));
          double _finalamount = double.parse(_amountController.text);
          _salesTax =
              (_getTaxAmount - (_getTaxAmount * _discountPrecendage / num)) *
                  _NumberOfQty;
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
        if (purchaseInclusiveTaxStatus == 1) {
          //if Exclusive tax
          double _getTaxValue = (_discountValue / _OriginalPrice) * 100;
          double _getTaxPrecentage = (_OriginalPrice * _gstPercentageNo) / num;
          double _getTotalAmount =
              (_OriginalPrice + _getTaxPrecentage) * _NumberOfQty;
          double _TotaldiscountPrice = ((_getTotalAmount * _getTaxValue) / num);
          double _discount_presentage = _getTaxValue / _NumberOfQty;

          _discountPercentageController.text =
              CustomStringHelper().formattDoubleToString(_discount_presentage);
          _amountController.text = CustomStringHelper()
              .formattDoubleToString((_getTotalAmount) - _TotaldiscountPrice);
          double _finalamount = double.parse(_amountController.text);
          _salesTax = (_getTaxPrecentage -
                  (_getTaxPrecentage * _discount_presentage / num)) *
              _NumberOfQty;
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
