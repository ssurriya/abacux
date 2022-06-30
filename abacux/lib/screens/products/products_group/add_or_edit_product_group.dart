import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/custom_model_dialog.dart';
import 'package:abacux/common/drop_down.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/product_groups_model.dart';
import 'package:abacux/services/generl_dropdown_list_service.dart';
import 'package:abacux/services/product_group_service.dart';
import 'package:abacux/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'products_group_screen.dart';

class AddOrEditProductGroup extends StatefulWidget {
  static const route = "/add_or_edit_product_group";
  const AddOrEditProductGroup({this.productGroup});
  final Productgroup productGroup;

  @override
  State<AddOrEditProductGroup> createState() => _AddOrEditProductGroupState();
}

class _AddOrEditProductGroupState extends State<AddOrEditProductGroup> {
  TextEditingController productGroupName = TextEditingController();
  TextEditingController productHsnCode = TextEditingController();
  List<dynamic> items = [];
  dynamic selectedUomsName;

  int userId, companyId;
  String token;

  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _getUserAndCompanyId();
    if (widget.productGroup != null) {
      _isEdit = true;
      productGroupName.text = widget.productGroup.productGroupName;
      productHsnCode.text = widget.productGroup.productHsnCode;
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

    // Call Customer listing service
    _uomsTypes(body);
  }

  void _uomsTypes(Map body) async {
    await DropdownService().productuoms(body).then((value) {
      setState(() {
        this.items = value;
        if (_isEdit == true) {
          if (widget.productGroup.id > 0) {
            selectedUomsName = value.firstWhere((e) =>
                e['id'].toString() ==
                widget.productGroup.productGroupUomId.toString());
          }
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
        title: Text(_isEdit ? "Edit Product Group" : "Add Product Group",
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
              Navigator.pushReplacementNamed(
                  context, ProductsGroupScreen.route);
            }),
        actions: [
          IconButton(
              icon: Icon(
                Icons.delete,
                color: AppConstant().appThemeColor,
              ),
              onPressed: () async {
                Map body = {
                  "user_id": userId.toString(),
                  "token": token,
                  "company_id": companyId.toString(),
                  "id": widget.productGroup.id.toString()
                };

                _showModelDialog("Delete", "Are you sure want to delete?",
                    buttonText1: "Yes",
                    buttonText2: "No", onPressedButton1: () async {
                  await ProductGroupService.getInstance()
                      .deleteProductGroup(body)
                      .then((value) {
                    _navigate();
                  });
                }, onPressedButton2: () {
                  Navigator.of(context).pop();
                });
              }),
          IconButton(
              icon: Icon(
                Icons.save,
                color: AppConstant().appThemeColor,
              ),
              onPressed: () {
                __loadValues();
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField(productGroupName, "Product Group Name"),
            textField(productHsnCode, "Product Hsn Code"),
            dropDown("Uoms Name", selectedUomsName, items, (value) {
              return value["uom_name"];
            }, onchanged: (dynamic value) {
              selectedUomsName = value;
            })
          ],
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

  __loadValues() async {
    Map body = {
      "user_id": userId.toString(),
      "token": token,
      "company_id": companyId.toString(),
      "product_group_name": productGroupName.text,
      "product_hsn_code": productHsnCode.text,
      "product_group_uom_id": selectedUomsName['id'].toString()
    };
    if (_isEdit) body['id'] = widget.productGroup.id.toString();

    if (_isEdit) {
      await ProductGroupService.getInstance()
          .editProductGroup(body)
          .then((value) {
        _navigate();
      });
    } else {
      await ProductGroupService.getInstance()
          .addProductGroup(body)
          .then((value) {
        _navigate();
      });
    }
  }

  _navigate() {
    Navigator.pushReplacementNamed(context, ProductsGroupScreen.route);
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
}
