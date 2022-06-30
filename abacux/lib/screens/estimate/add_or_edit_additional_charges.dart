import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/helper/custom_string_helper.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/services/estimate_service.dart';
import 'package:abacux/services/generl_dropdown_list_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EstimateAdditionalCharges extends StatefulWidget {
  const EstimateAdditionalCharges({this.productValue, this.isUpdate});

  final dynamic productValue;
  final bool isUpdate;

  @override
  _EstimateAdditionalChargesState createState() =>
      _EstimateAdditionalChargesState();
}

class _EstimateAdditionalChargesState extends State<EstimateAdditionalCharges> {
  TextEditingController taxTypeController = TextEditingController();
  TextEditingController taxPrecentageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController discountAmountController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // List<Product> _productList = [];
  // Product _selectedProduct;
  List<dynamic> _taxType = [];
  dynamic _selectedTaxType;

  int additionalChargeId = 0;

  int userId, companyId;
  String token;

  int estimateProductIndex = 0;
  int num = 100;
  Map<String, dynamic> estimateProduct = {};

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
    _getUserAndCompanyId();
    _getestimateProductIndex();
    taxPrecentageController.text = "0";
    discountAmountController.text = "0";
    amountController.text = "0";
    if (widget.productValue != null) {
      _loadProductValues();
    }
  }

  _loadProductValues() {
    setState(() {
      isEdit = true;
      additionalChargeId = widget.productValue['additionalChargeId'];
      taxTypeController.text = widget.productValue['taxType'].toString();
      taxPrecentageController.text = widget.productValue['tax'].toString();
      descriptionController.text =
          widget.productValue['additionalCharge'].toString();
      discountAmountController.text = widget.productValue['amount'].toString();
      amountController.text = widget.productValue['totalAmount'].toString();
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
    // _getestimateProduct();
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
              e['tax_id'].toString() ==
              widget.productValue['taxType'].toString());
        }
      });
    });
  }

  // _getestimateProduct() async {
  //   Map body = {
  //     "user_id": userId.toString(),
  //     "company_id": companyId.toString(),
  //     "token": token
  //   };
  //   print(body);
  //   await PurchaseOrderService.getInstance()
  //       .getPurchaseProduct(body)
  //       .then((value) {
  //     setState(() {
  //       _productList = value;

  //       if (isEdit == true) {
  //         _selectedProduct = value.firstWhere((e) =>
  //         e.productName == widget.productValue['product'].toString());
  //       }
  //     });
  //   });
  // }

  _getestimateProductIndex() async {
    await EstimateService.getInstance()
        .getEstimateAdditionalFromLocal()
        .then((value) {
      setState(() {
        print("Indeex ---${value.length}");
        estimateProductIndex = value.length;
      });
    });
  }

  _insertestimateProductToLocal() async {
    _loadEstimateductValue();
    await EstimateService.getInstance()
        .insertEstimateAdditionalCharges(estimateProduct)
        .then((value) {
      Navigator.pushReplacementNamed(context, '/add_estimate_screen');
    });
  }

  _updateEstimateProductToLocal() async {
    _loadEstimateductValue();
    await EstimateService.getInstance()
        .updateEstimateAdditionalCharges(estimateProduct)
        .then((value) {
      Navigator.pushReplacementNamed(context, '/add_estimate_screen');
    });
  }

  _loadEstimateductValue() {
    estimateProduct = {
      "id": isEdit
          ? widget.productValue['id']
          : widget.isUpdate != null
              ? widget.isUpdate
                  ? estimateProductIndex + 1
                  : estimateProductIndex
              : estimateProductIndex,
      "uuid": isEdit ? widget.productValue['uuid'] : Uuid().v1(),
      "additionalChargeId": additionalChargeId,
      "additionalCharge": descriptionController.text,
      "amount": double.parse(discountAmountController.text),
      "taxType": _selectedTaxType['tax_id'].toString(),
      "tax": double.parse(taxPrecentageController.text),
      "totalAmount": double.parse(amountController.text),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/add_estimate_screen");
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
                Navigator.pushReplacementNamed(context, '/add_estimate_screen');
              }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEdit ? "Edit Additional Charges" : "Add Additional Charges",
                style: TextStyle(color: Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  isEdit
                      ? _updateEstimateProductToLocal()
                      : _insertestimateProductToLocal();
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
            child: Column(
              children: [
                description_text(
                  descriptionController,
                  "Additional Charge",
                  "Enter the amount",
                ),
                discount_amount(discountAmountController, "₹ Amount",
                    "Enter the discount amount"),
                dropDownForTaxType(),
                _taxPrecentage(taxPrecentageController, "% Tax", "Enter tax"),
                // textField(bin, "Bin", "Enter bin"),

                _totalAmount(
                    amountController, "₹ Total Amount", "Enter Total amount"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _taxPrecentage(
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
              updateValues();
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

  Widget description_text(
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
            onChanged: (value) {},
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

  Widget discount_amount(
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
              updateValues();
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

  Widget _totalAmount(
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
            readOnly: false,
            onChanged: (value) {
              updateValues();
            },
            onSaved: (val) => setState(
                () => controller = double.parse(val) as TextEditingController),
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

  void updateValues() {
    if (discountAmountController.text.trim() != '') {
      try {
        double _OriginalPrice = double.parse(discountAmountController.text);
        double _gstPercentageNo = double.parse(taxPrecentageController.text);

        double _getTaxAmount = (_OriginalPrice * _gstPercentageNo) / num;
        amountController.text = CustomStringHelper()
            .formattDoubleToString(_OriginalPrice + _getTaxAmount);
      } on Exception catch (exception) {
        print(exception.toString());
      } catch (error) {
        print(error.toString());
      }
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
                  taxPrecentageController.text =
                      _selectedTaxType["tax_percentage"].toString();
                  updateValues();
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
