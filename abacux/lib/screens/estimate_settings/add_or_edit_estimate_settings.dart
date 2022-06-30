import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/custom_model_dialog.dart';
import 'package:abacux/common/drop_down.dart';
import 'package:abacux/common/text_field.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/estimate_setting_list_model.dart';
import 'package:abacux/services/estimate_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'estimate_settings_screen.dart';

class AddOrEditEstimateSettings extends StatefulWidget {
  static const route = "/add_or_edit_estimate_settings";
  AddOrEditEstimateSettings({this.estimateSetting});
  final EstimateSetting estimateSetting;

  @override
  State<AddOrEditEstimateSettings> createState() =>
      _AddOrEditEstimateSettingsState();
}

class _AddOrEditEstimateSettingsState extends State<AddOrEditEstimateSettings> {
  TextEditingController prefix = TextEditingController();
  TextEditingController estimateStartNumber = TextEditingController();

  int userId, companyId;
  String token;

  bool _isEdit = false, isActive = false;

  @override
  void initState() {
    super.initState();
    _getUserAndCompanyId();
    if (widget.estimateSetting != null) {
      setState(() {
        _isEdit = true;
        prefix.text = widget.estimateSetting.prefix;
        estimateStartNumber.text =
            widget.estimateSetting.estimateStartNumber.toString();
        isActive = widget.estimateSetting.status == 1;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
            _isEdit ? "Edit Estimate Settings" : "Add Estimate Settings",
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
                  context, EstimatesSettingsScreen.route);
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
                      "id": widget.estimateSetting.id.toString(),
                    };

                    _showModelDialog("Delete", "Are you sure want to delete?",
                        buttonText1: "Yes",
                        buttonText2: "No", onPressedButton1: () async {
                      await EstimateSettingService.getInstance()
                          .deleteEstimateSettings(body)
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
                  "prefix": prefix.text,
                  "estimates_no": estimateStartNumber.text,
                  "status": isActive ? "1" : "0"
                };
                if (_isEdit) body['id'] = widget.estimateSetting.id.toString();

                print(body);

                _isEdit
                    ? await EstimateSettingService.getInstance()
                        .editEstimateSettings(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {})
                    : await EstimateSettingService.getInstance()
                        .addEstimateSettings(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {});
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField(prefix, "Prefix", onchanged: (value) {}),
            textField(estimateStartNumber, "Estimate Start Number",
                onchanged: (value) {}),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = !isActive;
                      });
                    }),
                Text(
                  "Active",
                  style: TextStyle(fontWeight: FontWeight.w600),
                )
              ],
            )
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
    Navigator.pushReplacementNamed(context, EstimatesSettingsScreen.route);
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
