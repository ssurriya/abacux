import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/custom_model_dialog.dart';
import 'package:abacux/common/drop_down.dart';
import 'package:abacux/common/text_field.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/customer_model.dart';
import 'package:abacux/model/invoice_groups_model.dart';
import 'package:abacux/services/customer_service.dart';
import 'package:abacux/services/invoice_groups_service.dart';
// import 'package:abacux/model/refferel_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'invoice_groups_screen.dart';

class AddOrEditInvoiceGroupScreen extends StatefulWidget {
  static const route = "/add_or_edit_invoice_group";
  AddOrEditInvoiceGroupScreen({this.invoiceGroup});
  final Employee invoiceGroup;

  @override
  State<AddOrEditInvoiceGroupScreen> createState() =>
      _AddOrEditInvoiceGroupScreenState();
}

class _AddOrEditInvoiceGroupScreenState
    extends State<AddOrEditInvoiceGroupScreen> {
  TextEditingController InvoiceGroupController = TextEditingController();
  List<Customer> _customerDetails = [];
  dynamic _selectedcustomer;
  int userId, companyId;
  String token;

  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _getUserAndCompanyId();
    if (widget.invoiceGroup != null) {
      setState(() {
        _isEdit = true;

        InvoiceGroupController.text = widget.invoiceGroup.invoiceGroupTitle;
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
    await CustomerService().customerList(body).then((value) {
      setState(() {
        this._customerDetails = value;
        if (_isEdit == true) {
          if (widget.invoiceGroup.customerId != null) {
            print(widget.invoiceGroup.customerId);
            _selectedcustomer = _customerDetails.firstWhere((e) =>
                e.id.toString() == widget.invoiceGroup.customerId.toString());
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
        title: Text(_isEdit ? "Add Invoice Groups" : "Add Invoice Groups",
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
              Navigator.pushReplacementNamed(context, InvoiceGroupScreen.route);
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
                      "id": widget.invoiceGroup.id.toString(),
                    };

                    _showModelDialog("Delete", "Are you sure want to delete?",
                        buttonText1: "Yes",
                        buttonText2: "No", onPressedButton1: () async {
                      await InvoicegroupsService.getInstance()
                          .deleteInvoicegroups(body)
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
                  "invoice_group_title": InvoiceGroupController.text.toString(),
                  "customer_id": _selectedcustomer.id.toString(),
                };
                if (_isEdit) body['id'] = widget.invoiceGroup.id.toString();

                _isEdit
                    ? await InvoicegroupsService.getInstance()
                        .editInvoicegroups(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {})
                    : await InvoicegroupsService.getInstance()
                        .addInvoicegroups(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {});
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField(InvoiceGroupController, "Invoice Group Name",
                onchanged: (value) {}),
            dropDown("Customer Name", _selectedcustomer, _customerDetails,
                (value) {
              return value.customerName;
            }, onchanged: (dynamic value) {
              _selectedcustomer = value;
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
    Navigator.pushReplacementNamed(context, InvoiceGroupScreen.route);
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
