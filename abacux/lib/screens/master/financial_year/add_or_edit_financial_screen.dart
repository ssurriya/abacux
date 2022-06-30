import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/custom_model_dialog.dart';
import 'package:abacux/common/drop_down.dart';
import 'package:abacux/common/text_field.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/financial_year_model.dart';
import 'package:abacux/model/ware_houses_list_model.dart';
import 'package:abacux/services/financial_year_service.dart';
import 'package:abacux/services/ware_house_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'financial_year_screen.dart';

class AddOrEditFinancialYear extends StatefulWidget {
  static const route = "/add_or_edit_financial_year";
  AddOrEditFinancialYear({this.financialYear});
  final FinancialYearElement financialYear;

  @override
  State<AddOrEditFinancialYear> createState() => _AddOrEditFinancialYearState();
}

class _AddOrEditFinancialYearState extends State<AddOrEditFinancialYear> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController decimalController = TextEditingController();
  List<dynamic> items = [];
  dynamic selectedUomsName;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  int userId, companyId;
  String token;

  bool _isEdit = false;

  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    startDateController.text = _dateFormat(_startDate);
    endDateController.text = _dateFormat(_endDate);
    _getUserAndCompanyId();

    if (widget.financialYear != null) {
      setState(() {
        _isEdit = true;
        startDateController.text = _dateFormat(widget.financialYear.fromDate);
        endDateController.text = _dateFormat(widget.financialYear.toDate);
        decimalController.text = widget.financialYear.decimal.toString();
        _isActive = widget.financialYear.status == 1;
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
        title: Text(_isEdit ? "Edit Financial Year" : "Add Financial Year",
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
                  context, FinancialYearScreen.route);
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
                      "id": widget.financialYear.id.toString(),
                    };

                    _showModelDialog("Delete", "Are you sure want to delete?",
                        buttonText1: "Yes",
                        buttonText2: "No", onPressedButton1: () async {
                      await FinancialYearService.getInstance()
                          .deleteFinancialYear(body)
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
                  "from_date": startDateController.text,
                  "to_date": endDateController.text,
                  "status": _isActive ? "1" : "0",
                  "decimal": decimalController.text
                };
                if (_isEdit) body['id'] = widget.financialYear.id.toString();

                print(body);

                _isEdit
                    ? await FinancialYearService.getInstance()
                        .editFinancialYear(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {})
                    : await FinancialYearService.getInstance()
                        .addFinancialYear(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {});
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // textField(startDateController, "", onchanged: (value) {}),
            // textField(endDateController, "Ware House Name", onchanged: (value) {}),
            dateTextField(startDateController, "Start Date", () {
              _selectListDateFrom(context);
            }, () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _selectListDateFrom(context);
            }),
            dateTextField(endDateController, "End Date", () {
              _selectListDateTo(context);
            }, () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _selectListDateTo(context);
            }),
            textField(decimalController, "Decimal", onchanged: (value) {}),
            Row(
              children: [
                Checkbox(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = !_isActive;
                      });
                    }),
                Text("Active"),
              ],
            )
            // dropDown("Uoms Name", selectedUomsName, items, (value) {
            //   return value["uom_name"];
            // }, onchanged: (dynamic value) {
            //   selectedUomsName = value;
            // })
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

  Future<Null> _selectListDateFrom(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2100));

    setState(() {
      _startDate = pickedDate;
      startDateController.text = _dateFormat(_startDate);
    });
  }

  Future<Null> _selectListDateTo(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: _endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2100));

    setState(() {
      _endDate = pickedDate;
      endDateController.text = _dateFormat(_endDate);
    });
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

  _navigate() {
    Navigator.pushReplacementNamed(context, FinancialYearScreen.route);
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
