import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/custom_model_dialog.dart';
import 'package:abacux/common/drop_down.dart';
import 'package:abacux/common/text_field.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/additional_charge_model.dart';
import 'package:abacux/model/inventory_accounts.dart';
import 'package:abacux/services/additional_charges_service.dart';
import 'package:abacux/services/generl_dropdown_list_service.dart';
import 'package:abacux/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'additionalCharges_screen.dart';

class AddOrEditAdditionalChargeScreen extends StatefulWidget {
  static const route = "/add_or_edit_additional_charge";
  AddOrEditAdditionalChargeScreen({this.additionalCharge});
  final Masteradditioncharge additionalCharge;

  @override
  State<AddOrEditAdditionalChargeScreen> createState() =>
      _AddOrEditAdditionalChargeScreenState();
}

class _AddOrEditAdditionalChargeScreenState
    extends State<AddOrEditAdditionalChargeScreen> {
  TextEditingController AdditionchargeController = TextEditingController();
  List<InventoryAccount> _inventoryAssetAccount = [];
  dynamic selectedAssetAccount;
  int userId, companyId;
  String token;

  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _getUserAndCompanyId();
    if (widget.additionalCharge != null) {
      setState(() {
        _isEdit = true;

        AdditionchargeController.text =
            widget.additionalCharge.additionalChargeName;
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
    _inventoryAccount(body);
  }

  void _inventoryAccount(Map body) async {
    await ProductService.getInstance().getInventoryAccount(body).then((value) {
      setState(() {
        this._inventoryAssetAccount = value.inventoryAccount;
        if (_isEdit == true) {
          if (widget.additionalCharge.accountId != null) {
            selectedAssetAccount = _inventoryAssetAccount.firstWhere((e) =>
                e.id.toString() ==
                widget.additionalCharge.accountId.toString());
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
        title: Text(
            _isEdit ? "Add Additional Charges" : "Add Additional Charge",
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
                  context, AdditionalChargeScreen.route);
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
                      "id": widget.additionalCharge.id.toString(),
                    };

                    _showModelDialog("Delete", "Are you sure want to delete?",
                        buttonText1: "Yes",
                        buttonText2: "No", onPressedButton1: () async {
                      await AdditionalChargesService.getInstance()
                          .deleteAdditionalCharges(body)
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
                  "additional_charge_name":
                      AdditionchargeController.text.toString(),
                  "addtional_charges_account_id":
                      selectedAssetAccount.id.toString(),
                };
                if (_isEdit) body['id'] = widget.additionalCharge.id.toString();

                _isEdit
                    ? await AdditionalChargesService.getInstance()
                        .editAdditionalCharges(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {})
                    : await AdditionalChargesService.getInstance()
                        .addAdditionalCharges(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {});
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField(AdditionchargeController, "Additional Charge Name",
                onchanged: (value) {}),
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
    Navigator.pushReplacementNamed(context, AdditionalChargeScreen.route);
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
