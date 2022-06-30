import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/custom_model_dialog.dart';
import 'package:abacux/common/drop_down.dart';
import 'package:abacux/common/text_field.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/amount_type.dart';
import 'package:abacux/model/inventory_accounts.dart';
import 'package:abacux/model/tax_classes_model.dart';

import 'package:abacux/services/generl_dropdown_list_service.dart';
import 'package:abacux/services/product_service.dart';
import 'package:abacux/services/tax_classes_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'taxclasses_screen.dart';

class AddOrEditTaxClasses extends StatefulWidget {
  static const route = "/add_or_edit_tax_calsses";
  AddOrEditTaxClasses({this.taxClasses});
  final TaxClassesName taxClasses;

  @override
  State<AddOrEditTaxClasses> createState() => _AddOrEditTaxClassesState();
}

class _AddOrEditTaxClassesState extends State<AddOrEditTaxClasses> {
  TextEditingController taxClassName = TextEditingController();
  List<InventoryAccount> _inventoryAssetAccount = [];
  TaxType selectedAssetAccount;
  List<TaxType> _amountType = [];
  InventoryAccount selectedAmountType;
  int userId, companyId;
  String token;

  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _getUserAndCompanyId();
    if (widget.taxClasses != null) {
      setState(() {
        _isEdit = true;
        taxClassName.text = widget.taxClasses.taxClassName;
      });
    }
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

    Map body = {
      "company_id": companyId.toString(),
      "user_id": userId.toString(),
      "token": token.toString(),
    };
    amountType(body);
    _inventoryAccount(body);
  }

  void _inventoryAccount(Map body) async {
    await ProductService.getInstance().getInventoryAccount(body).then((value) {
      setState(() {
        this._inventoryAssetAccount = value.inventoryAccount;
        if (_isEdit == true) {
          selectedAmountType = _inventoryAssetAccount.firstWhere(
              (e) => e.id.toString() == widget.taxClasses.accountId.toString());
        }
      });
    });
  }

  void amountType(Map body) async {
    await DropdownService().getAmountType(body).then((value) {
      setState(() {
        this._amountType = value.taxtype;
        if (_isEdit == true) {
          selectedAssetAccount = _amountType.firstWhere(
              (e) => e.id.toString() == widget.taxClasses.taxTypeId.toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(_isEdit ? "Add Tax Class" : "Add Tax Class ",
            style: GoogleFonts.publicSans(
                fontSize: 18,
                letterSpacing: 0.2,
                color: Colors.black,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppConstant().appThemeColor,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, TaxClassesScreen.route);
            }),
        actions: [
          _isEdit
              ? IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: AppConstant().appThemeColor,
                  ),
                  onPressed: () async {
                    Map body = {
                      "user_id": userId.toString(),
                      "company_id": companyId.toString(),
                      "token": token,
                      "id": widget.taxClasses.id.toString(),
                    };

                    _showModelDialog("Delete", "Are you sure want to delete?",
                        buttonText1: "Yes",
                        buttonText2: "No", onPressedButton1: () async {
                      await TaxClassesService.getInstance()
                          .deleteTaxClasses(body)
                          .then((value) {
                        if (value['status'] == '403') {
                          _showModelDialog1(
                            "Error",
                            value['message'],
                            buttonText1: "OK",
                            onPressedButton1: () async {
                              Navigator.of(context).pop();
                              _navigate();
                            },
                          );
                        } else {
                          Navigator.of(context).pop();
                          _navigate();
                        }
                      }).catchError((onError) {});
                    }, onPressedButton2: () {
                      Navigator.of(context).pop();
                    });
                  })
              : Container(),
          IconButton(
              icon: Icon(
                Icons.save,
                color: AppConstant().appThemeColor,
              ),
              onPressed: () async {
                Map body = {
                  "user_id": userId.toString(),
                  "company_id": companyId.toString(),
                  "token": token,
                  "tax_class_name": taxClassName.text.toString(),
                  "account_id": selectedAssetAccount.id.toString(),
                  "tax_type_id": selectedAmountType.id.toString(),
                };
                if (_isEdit) body['id'] = widget.taxClasses.id.toString();

                _isEdit
                    ? await TaxClassesService.getInstance()
                        .editTaxClasses(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {})
                    : await TaxClassesService.getInstance()
                        .addTaxClasses(body)
                        .then((value) {
                        print(value);
                        _navigate();
                      }).catchError((onError) {});
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField(taxClassName, "Tax Class Name", onchanged: (value) {}),
            dropDown("Tax Type", selectedAmountType, _amountType, (value) {
              return value.taxType;
            }, onchanged: (dynamic value) {
              selectedAmountType = value;
            }),
            dropDown(
                "Accounts Name", selectedAssetAccount, _inventoryAssetAccount,
                (value) {
              return value.accountName;
            }, onchanged: (dynamic value) {
              selectedAssetAccount = value;
            }),
          ],
        ),
      ),
    );
  }

  Widget textField(TextEditingController controller, String hintText,
      {IconData prefixIcon,
      Function onchanged,
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
          child: CustomTextFormField(
            controller,
            hintText,
            onchanged: onchanged,
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

  _navigate() {
    Navigator.pushReplacementNamed(context, TaxClassesScreen.route);
  }

  _showModelDialog(String title, String content,
      {String buttonText1,
      String buttonText2,
      Function onPressedButton1,
      Function onPressedButton2}) {
    return showDialog(
      context: context,
      builder: (context) => CustomModelDialog(
        title,
        content,
        buttonText1: "Yes",
        buttonText2: "No",
        onPressedButton1: () => onPressedButton1(),
        onPressedButton2: () => onPressedButton2(),
      ),
    );
  }

  _showModelDialog1(
    String title,
    String content, {
    String buttonText1,
    Function onPressedButton1,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CustomModelDialog(
        title,
        content,
        buttonText1: "OK",
        onPressedButton1: () => onPressedButton1(),
      ),
    );
  }
}
