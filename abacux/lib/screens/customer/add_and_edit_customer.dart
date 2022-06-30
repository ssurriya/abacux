import 'package:abacux/common/CustomTextField.dart';
import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/common/drop_down.dart';
import 'package:abacux/common/text_field.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/customer_model.dart';
import 'package:abacux/model/gst_treatments_model.dart';
import 'package:abacux/services/customer_service.dart';
import 'package:abacux/services/generl_dropdown_list_service.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddAndEditCustomerScreen extends StatefulWidget {
  final Customer customerDetails;
  final String path;

  AddAndEditCustomerScreen({this.customerDetails, this.path});

  @override
  _AddAndEditCustomerScreenState createState() =>
      _AddAndEditCustomerScreenState();
}

class _AddAndEditCustomerScreenState extends State<AddAndEditCustomerScreen> {
  final _formkey = GlobalKey<FormState>();
  List<dynamic> _statelst = [
    {
      'state_id': '37',
      'state_name': 'Andhra Pradesh',
    },
    {
      'state_id': '12',
      'state_name': 'Arunachal Pradesh',
    },
    {
      'state_id': '18',
      'state_name': 'Assam',
    },
    {
      'state_id': '10',
      'state_name': 'Bihar',
    },
    {
      'state_id': '22',
      'state_name': 'Chattisgarh',
    },
    {
      'state_id': '07',
      'state_name': 'Delhi',
    },
    {
      'state_id': '30',
      'state_name': 'Goa',
    },
    {
      'state_id': '24',
      'state_name': 'Gujarat',
    },
    {
      'state_id': '06',
      'state_name': 'Haryana',
    },
    {
      'state_id': '02',
      'state_name': 'Himachal Pradesh',
    },
    {
      'state_id': '01',
      'state_name': 'Jammu and Kashmir',
    },
    {
      'state_id': '20',
      'state_name': 'Jharkhand',
    },
    {
      'state_id': '29',
      'state_name': 'Karnataka',
    },
    {
      'state_id': '32',
      'state_name': 'Kerala',
    },
    {
      'state_id': '31',
      'state_name': 'Lakshadweep Islands',
    },
    {
      'state_id': '23',
      'state_name': 'Madhya Pradesh',
    },
    {
      'state_id': '27',
      'state_name': 'Maharashtra',
    },
    {
      'state_id': '14',
      'state_name': 'Manipur',
    },
    {
      'state_id': '17',
      'state_name': 'Meghalaya',
    },
    {
      'state_id': '15',
      'state_name': 'Mizoram',
    },
    {
      'state_id': '13',
      'state_name': 'Nagaland',
    },
    {
      'state_id': '21',
      'state_name': 'Odisha',
    },
    {
      'state_id': '34',
      'state_name': 'Pondicherry',
    },
    {
      'state_id': '08',
      'state_name': 'Rajasthan',
    },
    {
      'state_id': '11',
      'state_name': 'Sikkim',
    },
    {
      'state_id': '33',
      'state_name': 'Tamil Nadu',
    },
    {
      'state_id': '36',
      'state_name': 'Telangana',
    },
    {
      'state_id': '16',
      'state_name': 'Tripura',
    },
    {
      'state_id': '09',
      'state_name': 'Uttar Pradesh',
    },
    {
      'state_id': '05',
      'state_name': 'Uttarakhand',
    },
    {
      'state_id': '19',
      'state_name': 'West Bengal',
    },
  ];
  TextEditingController customerName = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController accountType = TextEditingController();
  TextEditingController customerContactNo1 = TextEditingController();
  TextEditingController customerContactNo2 = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController shippingaddress = TextEditingController();
  TextEditingController gstNo = TextEditingController();
  TextEditingController panNo = TextEditingController();
  TextEditingController openingBalance = TextEditingController();
  TextEditingController asOfDateController = TextEditingController();

  bool isEdit = false;

  List<dynamic> _accountTypeslst = [];
  dynamic _selectedType;
  dynamic _selectedStateValue;
  int userId, companyId;
  String token;

  DateTime _asOfDate = DateTime.now();

  List<AccountHolderType> _gstTreatments = [];
  AccountHolderType _selectedGstTreatment;

  @override
  void initState() {
    super.initState();
    asOfDateController.text = _dateFormat(_asOfDate);
    _getUserAndCompanyId();
    if (widget.customerDetails != null &&
        widget.customerDetails.customerName != null) {
      _loadExistingValue();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check Internet Connection
    CheckConnectivity.getInstance().checkConnectivity(context);
  }

  // Get
  _getUserAndCompanyId() async {
    await Storage().readInt("userId").then((value) {
      userId = value;
    });
    await Storage().readString("token").then((value) {
      token = value;
    });
    await Storage().readInt("selectedCompanyId").then((value) {
      companyId = value;
      print(companyId);
    });

    //Call Account Type
    _accountTypes();
    _getGstTreatments();
  }

  void _accountTypes() async {
    Map body = {"user_id": userId.toString(), "token": token};
    await DropdownService().accountTypes(body).then((value) {
      setState(() {
        this._accountTypeslst = value;
        if (isEdit == true) {
          if (widget.customerDetails.id > 0) {
            _selectedType = value.firstWhere((e) =>
                e['id'].toString() ==
                widget.customerDetails.accountHolderTypeId.toString());
          }
        }
      });
    });
  }

  _getGstTreatments() async {
    Map body = {
      "user_id": userId.toString(),
      "token": token,
      "company_id": companyId.toString()
    };
    await DropdownService().getGstTreatments(body).then((value) {
      setState(() {
        _gstTreatments = value.accountHolderTypes;
      });
    });
  }

  void _onSelectState() {
    _selectedStateValue = _statelst.firstWhere((e) =>
        e["state_id"].toString() ==
        widget.customerDetails.stateCode.toString());
  }

  _loadExistingValue() {
    setState(() {
      isEdit = true;

      customerName.text = widget.customerDetails.customerName;
      companyName.text = widget.customerDetails.companyName;
      email.text = widget.customerDetails.customerEmail;
      accountType.text = widget.customerDetails.accountHolderType;
      customerContactNo1.text = widget.customerDetails.contactNoOne.toString();
      customerContactNo2.text = widget.customerDetails.contactNoTwo.toString();
      address.text = widget.customerDetails.customerAddress;
      shippingaddress.text = widget.customerDetails.shippingAddress;
      gstNo.text = widget.customerDetails.gstinNo;
      panNo.text = widget.customerDetails.panNo;
      _onSelectState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, widget.path);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.96),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
                icon: Icon(
                  Icons.cancel_outlined,
                  size: 28,
                  color: AppConstant().appThemeColor,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, widget.path);
                }),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                !isEdit ? "Add Customer" : "Edit Customer",
                style: TextStyle(
                    fontSize: 18, color: Colors.black, fontFamily: 'Poppins'),
              ),
              GestureDetector(
                onTap: () {
                  isEdit ? _editDetail() : _saveDetails();
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                      fontSize: 18, color: AppConstant().appThemeColor),
                ),
              )
            ],
          ),
          // backgroundColor: AppConstant().appThemeColor,
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formkey,
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 14.0, left: 14.0, top: 40.0),
                child: Column(
                  children: [
                    textField1(
                      customerName,
                      "Name",
                    ),
                    textField1(
                      companyName,
                      "Company Name",
                    ),
                    textField1(
                      email,
                      "Email",
                    ),
                    // acountDropdown(),
                    dropDown("Account Type", _selectedType, _accountTypeslst,
                        (accountType) {
                      return accountType['account_holder_type'];
                    }, onchanged: (value) {
                      _selectedType = value;
                    }),
                    textField1(
                      customerContactNo1,
                      "Contact No1",
                    ),
                    textField1(
                      customerContactNo2,
                      "Contact No2",
                    ),
                    textField1(
                      address,
                      "Customer Address",
                    ),
                    textField1(
                      shippingaddress,
                      "Shipping Address",
                    ),
                    textField1(
                      gstNo,
                      "Gst No",
                    ),
                    textField1(
                      panNo,
                      "Pan No",
                    ),
                    // dropdown3(),
                    dropDown("State", _selectedStateValue, _statelst, (state) {
                      return state['state_name'];
                    }, onchanged: (value) {
                      _selectedStateValue = value;
                    }),
                    textField1(
                      panNo,
                      "Opening Balace",
                    ),
                    dateTextField(),
                    // gstTreatmentDropdown(),
                    dropDown(
                        "Gst Treatment", _selectedGstTreatment, _gstTreatments,
                        (AccountHolderType gstTreatment) {
                      return gstTreatment.gstTreatmentName;
                    }, onchanged: (value) {
                      _selectedGstTreatment = value;
                    }, isValidate: false),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget textField1(TextEditingController controller, String hintText,
      {IconData prefixIcon,
      bool isRow = false,
      IconData suffixIcon,
      Function validator}) {
    return Padding(
      padding: isRow ? const EdgeInsets.all(0.0) : const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: CustomTextFormField(
            controller,
            hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            validator: validator,
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
            ),
          ),
        ),
      ),
    );
  }

  Widget dateTextField() {
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
                      _selectListDateFrom(context);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        readOnly: true,
                        controller: asOfDateController,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w400),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _selectListDateFrom(context);
                        },
                        decoration: InputDecoration(
                          labelText: 'As Of',
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
        initialDate: _asOfDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2100));

    setState(() {
      _asOfDate = pickedDate;
      asOfDateController.text = _dateFormat(_asOfDate);
    });
  }

  // Date Format
  String _dateFormat(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  _saveDetails() async {
    if (_formkey.currentState.validate()) {
      Map body = {
        "company_id": companyId.toString(),
        "user_id": userId.toString(),
        "account_holder_type_id": _selectedType['id'].toString(),
        "account_name": customerName.text.toString(),
        "company_name": companyName.text.toString(),
        "customer_name": customerName.text.toString(),
        "customer_email": email.text.toString(),
        "contact_no_one": customerContactNo1.text.toString(),
        "contact_no_two": customerContactNo2.text.toString(),
        "gstin_no": gstNo.text.toString(),
        "pan_no": panNo.text.toString(),
        "customer_address": address.text.toString(),
        "shipping_address": shippingaddress.text.toString(),
        "state_name": _selectedStateValue['state_name'].toString(),
        "state_code": _selectedStateValue['state_id'].toString(),
        "token": token.toString(),
      };

      await CustomerService().insertNewCustomer(body).then((result) {
        setState(() {
          Navigator.pushNamedAndRemoveUntil(
            context,
            widget.path,
            (Route<dynamic> route) => false,
            arguments: {
              'name': customerName.text.toString(),
              "email": email.text.toString()
            },
          );
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                _buildPopupDialog(context, "New Customer Added successfully."),
          );
        });
      });
    }
  }

  _editDetail() async {
    if (_formkey.currentState.validate()) {
      Map body = {
        "company_id": companyId.toString(),
        "user_id": userId.toString(),
        "id": widget.customerDetails.id.toString(),
        "accout_holder_old_id":
            widget.customerDetails.accountHolderId.toString(),
        "account_holder_type_id": _selectedType['id'].toString(),
        "account_name": customerName.text.toString(),
        "company_name": companyName.text.toString(),
        "customer_name": customerName.text.toString(),
        "customer_email": email.text.toString(),
        "contact_no_one": customerContactNo1.text.toString(),
        "contact_no_two": customerContactNo2.text.toString(),
        "gstin_no": gstNo.text.toString(),
        "pan_no": panNo.text.toString(),
        "customer_address": address.text.toString(),
        "shipping_address": shippingaddress.text.toString(),
        "state_name": _selectedStateValue['state_name'].toString(),
        "state_code": _selectedStateValue['state_id'].toString(),
        "token": token.toString(),
      };

      await CustomerService().editCustomer(body).then((result) {
        setState(() {
          Navigator.pushNamedAndRemoveUntil(
              context, widget.path, (Route<dynamic> route) => false);
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                _buildPopupDialog(context, "Customer Updated successfully."),
          );
        });
      });
    }
  }

  Widget _buildPopupDialog(BuildContext context, String message) {
    return new AlertDialog(
      title: Text(message),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
              context,
              widget.path,
              (Route<dynamic> route) => false,
              arguments: {
                'name': customerName.text.toString(),
                "email": email.text.toString()
              },
            );
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
