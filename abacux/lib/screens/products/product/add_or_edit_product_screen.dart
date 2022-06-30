import 'dart:convert';

import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/drop_down.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/Product_model.dart';
import 'package:abacux/model/expense_accounts.dart';
import 'package:abacux/model/income_accounts_model.dart';
import 'package:abacux/model/inventory_accounts.dart';
import 'package:abacux/model/product_groups_model.dart';
import 'package:abacux/model/warehouse_bin_model.dart';
import 'package:abacux/services/generl_dropdown_list_service.dart';
import 'package:abacux/services/product_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class AddAndEditProductScreen extends StatefulWidget {
  final Product productDetails;

  AddAndEditProductScreen({this.productDetails});

  @override
  _AddAndEditProductScreenState createState() =>
      _AddAndEditProductScreenState();
}

class _AddAndEditProductScreenState extends State<AddAndEditProductScreen> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController productName = TextEditingController();
  TextEditingController productOtherName = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController hsnCodeNo = TextEditingController();
  TextEditingController partNumber = TextEditingController();
  TextEditingController availableStocks = TextEditingController();
  TextEditingController lessStockNotifications = TextEditingController();
  TextEditingController purchasePrice = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController productGroupId = TextEditingController();

  bool isEdit = false;
  bool purchaseInclusiveTax = false;
  bool salesInclusiveTax = false;
  int purchaseTaxCheckbox = 0;
  int salesTaxCheckbox = 0;
  List<dynamic> _productUomsLst = [];
  List<dynamic> _productAttributeLst = [];
  List<dynamic> _taxTypeslst = [];
  List<Productgroup> _productGroups = [];
  List<Expanseaccount> _expenseProducts = [];
  List<Incomeaccount> _incomeProducts = [];
  List<WarehouseBin> _wareHouseBins = [];
  List<InventoryAccount> _inventoryAssetAccount = [];
  List<dynamic> _productAttributeValue = [];
  dynamic _selectedPurchaseTypetax;
  dynamic _selectedUmos;
  dynamic _selectedAttribute;
  dynamic _selectedSalesTypetax;
  WarehouseBin _selectedWarehousebin;
  InventoryAccount _selectedInventoryAsset;
  dynamic _selectedAttributeValue;
  Productgroup _selectedProductGroup;
  dynamic _selectedExpenseProduct;
  Incomeaccount _selectedIncomeProduct;

  bool _isAttributeValueVisible = false, _isAttributeNameVisible = false;

  int userId, companyId;
  String token;

  void initState() {
    super.initState();
    _getUserAndCompanyId();
    if (widget.productDetails != null &&
        widget.productDetails.companyId != null) {
      _loadExistingValue();
    }
  }

  // Get
  _getUserAndCompanyId() async {
    await Storage().readInt("userId").then((value) {
      userId = value;
    });
    await Storage().readString("token").then((value) {
      token = value;
    });
    await Storage().readInt("selectedCompanyId").then((value) {
      companyId = value;
      print(companyId);
    });

    Map body = {
      "company_id": companyId.toString(),
      "user_id": userId.toString(),
      "token": token.toString(),
    };

    Map body1 = {
      "id": companyId.toString(),
      "user_id": userId.toString(),
      "token": token.toString(),
    };

    //Call Account Type
    _uomsTypes(body);
    _productAttributelst(body);
    _taxTypes(body);
    _getExpenseAccounts(body1);
    _getProductGroups(body1);
    _getIncomeAccounts(body1);

    _getInventoryAccount(body1);
    _getWarehouseBins(body1);
  }

  void _uomsTypes(Map body) async {
    await DropdownService().productuoms(body).then((value) {
      setState(() {
        this._productUomsLst = value;
        if (isEdit == true) {
          if (widget.productDetails.id > 0) {
            _selectedUmos = value.firstWhere((e) =>
                e['id'].toString() == widget.productDetails.umosId.toString());
          }
        }
      });
    });
  }

  _getProductGroups(Map body) async {
    await ProductService.getInstance().getProductGroups(body).then((value) {
      _productGroups = value.productgroups;
    });
  }

  _getIncomeAccounts(Map body) async {
    await ProductService.getInstance().getIncomeAccounts(body).then((value) {
      _incomeProducts = value.incomeaccounts;
    });
  }

  _getExpenseAccounts(Map body) async {
    await ProductService.getInstance().getExpenseAccounts(body).then((value) {
      print(value);
      setState(() {
        _expenseProducts = value.expanseaccounts;
      });
    });
  }

  _getInventoryAccount(Map body) async {
    await ProductService.getInstance().getInventoryAccount(body).then((value) {
      _inventoryAssetAccount = value.inventoryAccount;
    }).catchError((onError) {});
  }

  _getWarehouseBins(Map body) async {
    await ProductService.getInstance().getWarehouseBin(body).then((value) {
      _wareHouseBins = value.warehouseBin;
    }).catchError((onError) {});
  }

  void _productAttributelst(Map body) async {
    await DropdownService().productattribute(body).then((value) {
      setState(() {
        this._productAttributeLst = value;
        if (isEdit == true) {
          if (widget.productDetails.id > 0) {
            _selectedAttribute = value.firstWhere((e) =>
                e['id'].toString() ==
                widget.productDetails.attributeId.toString());
          }
        }
      });
    });
  }

  void _taxTypes(Map body) async {
    await DropdownService().taxclass(body).then((value) {
      setState(() {
        this._taxTypeslst = value;
        if (isEdit == true) {
          if (widget.productDetails.id > 0) {
            _selectedSalesTypetax = value.firstWhere((e) =>
                e['id'].toString() ==
                widget.productDetails.salesTaxClassId.toString());
            _selectedPurchaseTypetax = value.firstWhere((e) =>
                e['id'].toString() ==
                widget.productDetails.purchaseTaxClassId.toString());
          }
        }
      });
    });
  }

  _loadExistingValue() {
    setState(() {
      isEdit = true;
      widget.productDetails.purchasePriceInclusiveTax == 1
          ? purchaseInclusiveTax = true
          : null;
      widget.productDetails.salesPriceInclusiveTax == 1
          ? salesInclusiveTax = true
          : null;
      productName.text = widget.productDetails.productName;
      productOtherName.text = widget.productDetails.productOtherName;
      productDescription.text = widget.productDetails.productDescription;
      hsnCodeNo.text = widget.productDetails.hsnCode.toString();
      partNumber.text = widget.productDetails.partNo;
      availableStocks.text = widget.productDetails.avilableStock.toString();
      lessStockNotifications.text =
          widget.productDetails.lessStockNotification.toString();
      purchasePrice.text = widget.productDetails.purchasePrice.toString();
      salePrice.text = widget.productDetails.salesPrice.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/product_list");
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.96),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
                icon: Icon(
                  Icons.cancel_outlined,
                  size: 28,
                  color: AppConstant().appThemeColor,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/product_list');
                }),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                !isEdit ? "Add Product" : "Edit Product",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  isEdit ? _editDetail() : _saveDetails();
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                      fontSize: 18, color: AppConstant().appThemeColor),
                ),
              )
            ],
          ),
          // backgroundColor: AppConstant().appThemeColor,
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formkey,
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 14.0, left: 14.0, top: 40.0),
                child: Column(
                  children: [
                    textField(
                      productName,
                      "Product Name",
                    ),
                    textField(productOtherName, "Product Other Name",
                        isValidate: false),
                    textField(productDescription, "Product Description",
                        isValidate: false),
                    // productGroupsDropdown(),
                    dropDown(
                      "Product Groups",
                      _selectedProductGroup,
                      _productGroups,
                      (Productgroup value) {
                        return value.productGroupName;
                      },
                      onchanged: (value) {
                        _selectedProductGroup = value;
                        setState(() {
                          if (_selectedProductGroup.productGroupUomId == 1) {
                            _isAttributeNameVisible = true;
                            _isAttributeValueVisible = true;
                          } else {
                            _isAttributeNameVisible = false;
                            _isAttributeValueVisible = false;
                          }
                        });
                      },
                    ),
                    textField(hsnCodeNo, "HSN Code", isHsnCode: true),
                    textField(
                      partNumber,
                      "Part No",
                    ),
                    textField(
                      availableStocks,
                      "Available Stock",
                    ),
                    textField(
                      lessStockNotifications,
                      "Less Stock Notification",
                    ),
                    dropDown(
                      "Inventory Asset Account",
                      _selectedInventoryAsset,
                      _inventoryAssetAccount,
                      (InventoryAccount value) {
                        return value.accountName;
                      },
                      onchanged: (value) {
                        _selectedInventoryAsset = value;
                      },
                    ),
                    // dropDownForWareHouseBin(),
                    dropDown(
                      "Ware House Bin",
                      _selectedWarehousebin,
                      _wareHouseBins,
                      (WarehouseBin value) {
                        return value.binName;
                      },
                      onchanged: (value) {
                        _selectedWarehousebin = value;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 10.0),
                      child: Row(
                        children: [
                          Text(
                            'Attribute Info',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: AppConstant().appThemeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // umosDropdown(),
                    dropDown(
                      "Umos Name",
                      _selectedUmos,
                      _productUomsLst,
                      (value) {
                        return value["uom_name"];
                      },
                      onchanged: (value) {
                        _selectedUmos = value;
                      },
                    ),
                    // attributeName(),
                    Visibility(
                      visible: _isAttributeNameVisible,
                      child: dropDown(
                        "Attribute Name",
                        _selectedAttribute,
                        _productAttributeLst,
                        (value) {
                          return value["attribute_name"];
                        },
                        onchanged: (value) {
                          _selectedAttribute = value;
                        },
                      ),
                    ),
                    Visibility(
                      visible: _isAttributeValueVisible,
                      child: dropDown(
                        "Attribute Value",
                        _selectedAttributeValue,
                        _productAttributeValue,
                        (value) {
                          return value;
                        },
                        onchanged: (value) {
                          _selectedAttributeValue = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 10.0),
                      child: Row(
                        children: [
                          Text(
                            'Purchase Info',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: AppConstant().appThemeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    textField(
                      purchasePrice,
                      "Purchase Price",
                    ),
                    SizedBox(width: 10),
                    // purchaseTaxClass(),
                    dropDown(
                      "Tax Class",
                      _selectedPurchaseTypetax,
                      _taxTypeslst,
                      (value) {
                        return value["tax_class_name"];
                      },
                      onchanged: (value) {
                        _selectedPurchaseTypetax = value;
                      },
                    ),
                    dropDown(
                      "Expense Accounts",
                      _selectedExpenseProduct,
                      _expenseProducts,
                      (Expanseaccount value) {
                        return value.accountName;
                      },
                      onchanged: (value) {
                        _selectedExpenseProduct = value;
                      },
                    ),
                    // dropDownExpense(),
                    SizedBox(width: 10),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: this.purchaseInclusiveTax,
                          onChanged: (bool value) {
                            setState(() {
                              this.purchaseInclusiveTax = value;
                            });
                          },
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Inclusive of tax',
                          style: TextStyle(fontSize: 17.0),
                        ), //Checkbox
                      ], //<Widget>[]
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 10.0),
                      child: Row(
                        children: [
                          Text(
                            'Sales Info',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: AppConstant().appThemeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    textField(
                      salePrice,
                      "Sales Price",
                    ),
                    // salesTaxClass(),
                    dropDown(
                      "Tax Class",
                      _selectedSalesTypetax,
                      _taxTypeslst,
                      (value) {
                        return value["tax_class_name"];
                      },
                      onchanged: (value) {
                        _selectedSalesTypetax = value;
                      },
                    ),
                    // dropDownIncome(),
                    dropDown(
                      "Income Accounts",
                      _selectedIncomeProduct,
                      _incomeProducts,
                      (Incomeaccount value) {
                        return value.accountName;
                      },
                      onchanged: (value) {
                        _selectedIncomeProduct = value;
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: this.salesInclusiveTax,
                          onChanged: (bool value) {
                            setState(() {
                              this.salesInclusiveTax = value;
                            });
                          },
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Inclusive of tax',
                          style: TextStyle(fontSize: 17.0),
                        ), //Checkbox
                      ], //<Widget>[]
                    ),
                    SizedBox(
                      height: 30.0,
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget textField(TextEditingController controller, String hintText,
      {IconData prefixIcon,
      bool isRow = false,
      IconData suffixIcon,
      bool isHsnCode = false,
      bool isValidate = true}) {
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
              if (isHsnCode) {
                if (value.length > 10) {
                  return "Invalid HSN Code";
                }
              }
              if (isValidate) {
                if (value.isEmpty) {
                  return hintText + " is empty";
                }
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

  Widget dropDown(String labelText, dynamic selectedValue, List<dynamic> items,
      Function itemAsString,
      {String errorText = "",
      Function onchanged,
      Function validator,
      bool isValidate = true}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 0.4,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: DropDown(
              labelText,
              selectedValue,
              items,
              itemAsString,
              errorText: errorText,
              onchanged: onchanged,
              isValidate: isValidate,
              validator: validator,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context, String message) {
    return new AlertDialog(
      title: Text(message),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
                context, '/product_list', (Route<dynamic> route) => false);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('OK'),
        ),
      ],
    );
  }

  _saveDetails() async {
    if (_formkey.currentState.validate()) {
      if (purchaseInclusiveTax == true) {
        setState(() {
          purchaseTaxCheckbox = 1;
        });
      }
      if (salesInclusiveTax == true) {
        setState(() {
          salesTaxCheckbox = 1;
        });
      }
      Map body = {
        "company_id": companyId.toString(),
        "user_id": userId.toString(),
        "product_name": productName.text.toString(),
        "product_other_name": productOtherName.text.toString(),
        "product_description": productDescription.text.toString(),
        "hsn_code": hsnCodeNo.text.toString(),
        "part_no": partNumber.text.toString(),
        "avilable_stock": availableStocks.text.toString(),
        "less_stock_notification": lessStockNotifications.text.toString(),
        "purchase_price": purchasePrice.text.toString(),
        "purchase_price_inclusive_tax": purchaseTaxCheckbox.toString(),
        "purchase_tax_class_id": _selectedPurchaseTypetax['id'].toString(),
        "amount": salePrice.text.toString(),
        "attribute_value": _selectedAttribute['id'].toString(),
        "attribute_id": _selectedAttribute['id'].toString(),
        "uom_id": _selectedUmos['id'].toString(),
        "sale_price_inclusive_tax": salesTaxCheckbox.toString(),
        "sales_tax_class_id": _selectedSalesTypetax['id'].toString(),
        "token": token.toString(),
      };

      await ProductService.getInstance().insertNewProduct(body).then((result) {
        setState(() {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                _buildPopupDialog(context, "New Product Added successfully."),
          );
        });
      });
    }
  }

  _editDetail() async {
    if (_formkey.currentState.validate()) {
      if (purchaseInclusiveTax == true) {
        setState(() {
          purchaseTaxCheckbox = 1;
        });
      }
      if (salesInclusiveTax == true) {
        setState(() {
          salesTaxCheckbox = 1;
        });
      }
      Map body = {
        "id": widget.productDetails.id.toString(),
        "company_id": companyId.toString(),
        "user_id": userId.toString(),
        "product_name": productName.text.toString(),
        "product_other_name": productOtherName.text.toString(),
        "product_description": productDescription.text.toString(),
        "hsn_code": hsnCodeNo.text.toString(),
        "part_no": partNumber.text.toString(),
        "avilable_stock": availableStocks.text.toString(),
        "less_stock_notification": lessStockNotifications.text.toString(),
        "purchase_price": purchasePrice.text.toString(),
        "purchase_price_inclusive_tax": purchaseTaxCheckbox.toString(),
        "purchase_tax_class_id": _selectedPurchaseTypetax['id'].toString(),
        "amount": salePrice.text.toString(),
        "attribute_value": _selectedAttribute['id'].toString(),
        "attribute_id": _selectedAttribute['id'].toString(),
        "uom_id": _selectedUmos['id'].toString(),
        "sale_price_inclusive_tax": salesTaxCheckbox.toString(),
        "sales_tax_class_id": _selectedSalesTypetax['id'].toString(),
        "token": token.toString(),
      };

      await ProductService.getInstance().editProduct(body).then((result) {
        setState(() {
          Navigator.pushNamedAndRemoveUntil(
              context, '/product_list', (Route<dynamic> route) => false);
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                _buildPopupDialog(context, "Customer Updated successfully."),
          );
        });
      });
    }
  }
}
