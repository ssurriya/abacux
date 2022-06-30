import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/custom_model_dialog.dart';
import 'package:abacux/common/drop_down.dart';
import 'package:abacux/common/text_field.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/tax_class_tax_model.dart';
import 'package:abacux/model/tax_classes_model.dart';
import 'package:abacux/model/tax_mode.dart';
import 'package:abacux/screens/master/tax_classes/taxclasses_screen.dart';

import 'package:abacux/services/tax_classes_service.dart';
import 'package:abacux/services/tax_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddOrEditTaxClassTax extends StatefulWidget {
  static const route = "/add_or_edit_tax_calsses";
  AddOrEditTaxClassTax({this.taxClasesTax});
  final TaxClassTax taxClasesTax;

  @override
  State<AddOrEditTaxClassTax> createState() => _AddOrEditTaxClassTaxState();
}

class _AddOrEditTaxClassTaxState extends State<AddOrEditTaxClassTax> {
  TextEditingController TaxClassName = TextEditingController();
  List<TaxtypesList> _taxList = [];

  List<TaxClassesName> _taxClassName = [];
  dynamic selectedTaxClassName;
  dynamic selectedtax;
  int userId, companyId;
  String token;

  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _getUserAndCompanyId();
    if (widget.taxClasesTax != null) {
      setState(() {
        _isEdit = true;
        TaxClassName.text = widget.taxClasesTax.taxClassName;
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
    await TaxClassesService.getInstance().TaxClassesList(body).then((value) {
      _taxClassName = value.taxClassesName;
    }).catchError((onError) {});
  }

  void amountType(Map body) async {
    await TaxService.getInstance().getTaxList(body).then((value) {
      print(value);
      _taxList = value.taxtypesList;
    }).catchError((onError) {});
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
                      "id": widget.taxClasesTax.id.toString(),
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
                  "tax_class_name": TaxClassName.text.toString(),
                  "account_id": selectedtax.id.toString(),
                  "tax_type_id": selectedTaxClassName.id.toString(),
                };
                if (_isEdit) body['id'] = widget.taxClasesTax.id.toString();

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
            textField(TaxClassName, "Tax Class Name", onchanged: (value) {}),
            dropDown("Tax Class", selectedTaxClassName, _taxClassName, (value) {
              return value.taxType;
            }, onchanged: (dynamic value) {
              selectedTaxClassName = value;
            }),
            dropDown("Select Sales Tax", selectedtax, _taxList, (value) {
              return value.accountName;
            }, onchanged: (dynamic value) {
              selectedtax = value;
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
