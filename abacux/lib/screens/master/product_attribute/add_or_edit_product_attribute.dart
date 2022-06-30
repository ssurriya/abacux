import 'dart:convert';

import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/custom_model_dialog.dart';
import 'package:abacux/common/drop_down.dart';
import 'package:abacux/common/text_field.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/product_attributes_model.dart';
import 'package:abacux/services/product_attribute_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:google_fonts/google_fonts.dart';

import 'product_attribute_screen.dart';

class AddOrEditProductAttribute extends StatefulWidget {
  static const route = "/add_or_edit_product_attribute";
  AddOrEditProductAttribute({this.productAttribute});
  final ProductAttribute productAttribute;

  @override
  State<AddOrEditProductAttribute> createState() =>
      _AddOrEditProductAttributeState();
}

class _AddOrEditProductAttributeState extends State<AddOrEditProductAttribute> {
  List _items = [];
  double _fontSize = 14;
  TextEditingController attributeName = TextEditingController();
  // TextEditingController attributeType = TextEditingController();
  // TextEditingController attributeValue = TextEditingController();
  List<String> items = ["Text", "Options", "Check Box", "Radio"];
  String selectedAttributeType;

  List attributeValues = [];

  int userId, companyId;
  String token;

  bool _isEdit = false;

  bool _isActive = false;

  List<String> tags = []; //initial tags
  // TextFieldTagsController textFieldTagsController;

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  @override
  void initState() {
    super.initState();
    // textFieldTagsController = TextFieldTagsController();
    _getUserAndCompanyId();

    if (widget.productAttribute != null) {
      setState(() {
        _isEdit = true;
        attributeName.text = widget.productAttribute.attributeName;
        selectedAttributeType = widget.productAttribute.type;
        attributeValues = json.decode(widget.productAttribute.typeValue);
        attributeValues.map((e) {
          _items.add(Item(title: e));
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // textFieldTagsController.dispose();
    // textFieldTagsController.clearTextFieldTags();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
            _isEdit ? "Edit Product Attribute" : "Add Product Attribute",
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
                  context, ProductAttributeScreen.route);
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
                      "id": widget.productAttribute.id.toString(),
                    };

                    _showModelDialog("Delete", "Are you sure want to delete?",
                        buttonText1: "Yes",
                        buttonText2: "No", onPressedButton1: () async {
                      await ProductAttributeService.getInstance()
                          .deleteProductAttribute(body)
                          .then((value) {
                        Navigator.of(context).pop();
                        _navigate();
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
                  "attribute_name": attributeName.text,
                  "type": selectedAttributeType,
                  "type_value": attributeValues
                      .toString()
                      .replaceAll("[", "")
                      .replaceAll("]", ""),
                  // "decimal": attributeValue.text
                };
                if (_isEdit) body['id'] = widget.productAttribute.id.toString();

                print(body);

                _isEdit
                    ? await ProductAttributeService.getInstance()
                        .editProductAttribute(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {})
                    : await ProductAttributeService.getInstance()
                        .addProductAttribute(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {});
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField(attributeName, "Attribute Name", onchanged: (value) {}),
            dropDown("Attribute Type", selectedAttributeType, items,
                (String type) {
              return type;
            }, onchanged: (String value) {
              selectedAttributeType = value;
            }),
            // _getTags(),
            _getTagWidget(),
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

  Widget dateTextField(TextEditingController controller, String labelText,
      Function onTap1, Function onTap2) {
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
                      onTap1();
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        readOnly: true,
                        controller: controller,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w400),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        onTap: () {
                          onTap2();
                        },
                        decoration: InputDecoration(
                          labelText: labelText,
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
    Navigator.pushReplacementNamed(context, ProductAttributeScreen.route);
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

  Widget _getTagWidget() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Tags(
            key: _tagStateKey,
            columns: 6,
            textField: TagsTextField(
              inputDecoration: InputDecoration(
                  labelText: "Attribute Value",
                  labelStyle: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w600),
                  focusColor: Colors.black),
              width: MediaQuery.of(context).size.width * 0.9,
              textStyle: TextStyle(fontSize: _fontSize),
              onSubmitted: (String str) {
                setState(() {
                  _items.add(Item(title: str));
                  attributeValues.add(str);
                });
              },
            ),
            itemCount: _items.length, // required
            itemBuilder: (int index) {
              return ItemTags(
                index: index, // required
                title: _items[index].title,
                customData: _items[index].customData,
                textStyle: TextStyle(
                  fontSize: _fontSize,
                ),
                highlightColor: AppConstant().appThemeColor,
                activeColor: AppConstant().appThemeColor.withOpacity(0.7),
                combine: ItemTagsCombine.withTextBefore,
                icon: ItemTagsIcon(
                  icon: Icons.add,
                ),
                removeButton: ItemTagsRemoveButton(
                  onRemoved: () {
                    setState(() {
                      _items.removeAt(index);
                    });
                    return true;
                  },
                ),
                onPressed: (item) => print(item),
                onLongPressed: (item) => print(item),
              );
            },
          ),
        ),
      ),
    );
  }
}
