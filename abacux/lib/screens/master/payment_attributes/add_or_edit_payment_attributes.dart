import 'dart:convert';

import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/custom_model_dialog.dart';
import 'package:abacux/common/drop_down.dart';
import 'package:abacux/common/text_field.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/payment_mode.dart';
import 'package:abacux/model/payment_mode_attributes_model.dart';
import 'package:abacux/services/payment_attributes_service.dart';
import 'package:abacux/services/payment_mode_service.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'payment_attributes_screen.dart';

class AddOrEditPaymentAttributes extends StatefulWidget {
  static const route = "/add_or_edit_payment_attributes";
  AddOrEditPaymentAttributes({this.paymentAttribute});
  final PaymentModeAttribute paymentAttribute;

  @override
  State<AddOrEditPaymentAttributes> createState() =>
      _AddOrEditPaymentAttributesState();
}

class _AddOrEditPaymentAttributesState
    extends State<AddOrEditPaymentAttributes> {
  TextEditingController decimalController = TextEditingController();

  List<PaymentmodeList> paymentModeList = [];
  PaymentmodeList _selectedPaymentMode;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  int userId, companyId;
  String token;

  bool _isEdit = false;

  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _getUserAndCompanyId();

    if (widget.paymentAttribute != null) {
      setState(() {
        _isEdit = true;
        attributeValues =
            json.decode(widget.paymentAttribute.paymentModeAttributeName);
        attributeValues.map((e) {
          _items.add(Item(title: e));
        }).toList();
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

    await PaymentModeService.getInstance().paymentModeList(body).then((value) {
      paymentModeList = value.paymentmodeList;
      if (_isEdit) {
        _selectedPaymentMode = paymentModeList.firstWhere(
            (element) => element.id == widget.paymentAttribute.paymentModeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
            _isEdit ? "Edit Payment Attribute" : "Add Payment Attribute",
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
                  context, PaymentAttributesScreen.route);
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
                      "id": widget.paymentAttribute.id.toString(),
                    };

                    _showModelDialog("Delete", "Are you sure want to delete?",
                        buttonText1: "Yes",
                        buttonText2: "No", onPressedButton1: () async {
                      await PaymentAttributesService.getInstance()
                          .deletePaymentAttributes(body)
                          .then((value) {
                        if (value['status'] == "200") {
                          Navigator.of(context).pop();
                          _navigate();
                        } else if (value['status'] == "403") {
                          _showFlushBar(
                              context,
                              "The payment mode id has already been taken",
                              Icons.error,
                              Colors.red);
                        }
                      }).catchError((onError) {
                        _showFlushBar(context, "Please try again later",
                            Icons.error, Colors.red);
                      });
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
                  "payment_mode_attribute_name": attributeValues
                      .toString()
                      .replaceAll('[', "")
                      .replaceAll(']', ""),
                  "payment_mode_id": _selectedPaymentMode.id.toString()
                };
                if (_isEdit) body['id'] = widget.paymentAttribute.id.toString();

                print(body);

                _isEdit
                    ? await PaymentAttributesService.getInstance()
                        .editPaymentAttributes(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {})
                    : await PaymentAttributesService.getInstance()
                        .addPaymentAttributes(body)
                        .then((value) {
                        if (value["status"] == "200")
                          _navigate();
                        else if (value["status"] == "403") {
                          _showFlushBar(
                              context,
                              "Data have table relationships restricted to delete cannot delete message",
                              Icons.error,
                              Colors.red);
                        }
                      }).catchError((onError) {
                        _showFlushBar(context, "Please try again later",
                            Icons.error, Colors.red);
                      });
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            dropDown("Payment Mode Type", _selectedPaymentMode, paymentModeList,
                (PaymentmodeList value) {
              return value.paymentMode;
            }, onchanged: (PaymentmodeList value) {
              _selectedPaymentMode = value;
            }),
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

  // Date Format
  String _dateFormat(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
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

  List<String> tags = []; //initial tags

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  List _items = [];
  double _fontSize = 14;

  List attributeValues = [];

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

  _navigate() {
    Navigator.pushReplacementNamed(context, PaymentAttributesScreen.route);
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

  final GlobalKey flushBarKey = GlobalKey();

  _showFlushBar(
      BuildContext context, String message, IconData icon, Color color) {
    Flushbar(
      key: flushBarKey,
      icon: Icon(
        icon,
        size: 28.0,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(8),
      duration: Duration(seconds: 10),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: color.withOpacity(0.9),
      messageText: Text(
        message,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
            letterSpacing: 0.5),
      ),
    )..show(context);
  }

  // _dismissFlushBar() {
  //   (flushBarKey.currentWidget as Flushbar).dismiss();
  // }
}
