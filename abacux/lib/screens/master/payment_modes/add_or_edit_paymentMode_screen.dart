import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/custom_model_dialog.dart';
import 'package:abacux/common/text_field.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/payment_mode.dart';
import 'package:abacux/services/payment_mode_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'paymentMode_screen.dart';

class AddOrEditPaymentMode extends StatefulWidget {
  static const route = "/add_or_edit_payment_mode";
  AddOrEditPaymentMode({this.payment_mode});
  final PaymentmodeList payment_mode;

  @override
  State<AddOrEditPaymentMode> createState() => _AddOrEditPaymentModeState();
}

class _AddOrEditPaymentModeState extends State<AddOrEditPaymentMode> {
  TextEditingController paymentModeController = TextEditingController();

  int userId, companyId;
  String token;

  bool _isEdit = false;
  int _status = 1;
  @override
  void initState() {
    super.initState();
    _getUserAndCompanyId();
    if (widget.payment_mode != null) {
      setState(() {
        _isEdit = true;
        paymentModeController.text = widget.payment_mode.paymentMode;
        _status = widget.payment_mode.attributeStatus;
      });
    }
  }

  box(value) {
    setState(() {
      _status = value;
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
        title: Text(_isEdit ? "Edit Payment Mode " : "Add Payment Mode",
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
              Navigator.pushReplacementNamed(context, PaymentModeScreen.route);
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
                      "id": widget.payment_mode.id.toString(),
                    };

                    _showModelDialog("Delete", "Are you sure want to delete?",
                        buttonText1: "Yes",
                        buttonText2: "No", onPressedButton1: () async {
                      await PaymentModeService.getInstance()
                          .deletePaymentMode(body)
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
                  "payment_mode": paymentModeController.text.toString(),
                  "attribute_status": _status.toString(),
                };
                if (_isEdit) body['id'] = widget.payment_mode.id.toString();

                _isEdit
                    ? await PaymentModeService.getInstance()
                        .editPaymentMode(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {})
                    : await PaymentModeService.getInstance()
                        .addPaymentMode(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {});
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField(paymentModeController, "Payment Mode",
                onchanged: (value) {}),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Attribute Status",
                  ),
                  Radio(
                    activeColor: Color(0xFF1a4e7d),
                    value: 1,
                    groupValue: _status,
                    onChanged: box,
                  ),
                  Text('Yes'),
                  Radio(
                    activeColor: Color(0xFF1a4e7d),
                    value: 2,
                    groupValue: _status,
                    onChanged: box,
                  ),
                  Text('No')
                ],
              ),
            ),
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

  _navigate() {
    Navigator.pushReplacementNamed(context, PaymentModeScreen.route);
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
