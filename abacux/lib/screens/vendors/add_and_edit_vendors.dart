import 'package:abacux/common/app_constant.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/gst_treatments_model.dart';
import 'package:abacux/model/vendor_model.dart';
import 'package:abacux/services/generl_dropdown_list_service.dart';
import 'package:abacux/services/vendor_service.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class AddAndEditVendorScreen extends StatefulWidget {
  final Vendor VendorDetails;

  AddAndEditVendorScreen({this.VendorDetails});

  @override
  _AddAndEditVendorScreenState createState() => _AddAndEditVendorScreenState();
}

class _AddAndEditVendorScreenState extends State<AddAndEditVendorScreen> {
  final _formkey = GlobalKey<FormState>();
  Map<String, List<dynamic>> _statelst = {
    "StateList": [
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
    ]
  };
  TextEditingController vendorName = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController accountType = TextEditingController();
  TextEditingController customerContactNo1 = TextEditingController();
  TextEditingController customerContactNo2 = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController shippingaddress = TextEditingController();
  TextEditingController gstNo = TextEditingController();
  TextEditingController panNo = TextEditingController();

  bool isEdit = false;

  List<dynamic> _accountTypeslst = [];
  List<dynamic> _lstfillmobilemodel = [];
  dynamic _selectedType;
  dynamic _selectedStateValue;
  int userId;
  int companyId = 40;
  String token;

  List<AccountHolderType> _gstTreatments = [];
  AccountHolderType _selectedGstTreatment;

  void initState() {
    super.initState();
    _getUserAndCompanyId();
    if (widget.VendorDetails != null &&
        widget.VendorDetails.vendor_name != null) {
      _loadExistingValue();
    }
  }

  // Get
  _getUserAndCompanyId() async {
    await Storage().readInt("userId").then((value) {
      userId = value;
      print(userId);
    });
    await Storage().readString("token").then((value) {
      token = value;
      print(token);
    });
    await Storage().readInt("selectedCompanyId").then((value) {
      companyId = value;
      print(companyId);
    });

    _accountTypes();
    _getGstTreatments();
  }

  void _accountTypes() async {
    Map body = {"user_id": userId.toString(), "token": token};
    await DropdownService().accountTypes(body).then((value) {
      setState(() {
        this._accountTypeslst = value;

        if (isEdit == true) {
          if (widget.VendorDetails.id > 0) {
            _selectedType = value.firstWhere((e) =>
                e['id'].toString() ==
                widget.VendorDetails.accountHolderTypeId.toString());
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
    _selectedStateValue = _statelst['StateList'].firstWhere((e) =>
        e["state_id"].toString() == widget.VendorDetails.stateCode.toString());
  }

  _loadExistingValue() {
    setState(() {
      isEdit = true;

      vendorName.text = widget.VendorDetails.vendor_name;
      companyName.text = widget.VendorDetails.companyName;
      customerContactNo1.text = widget.VendorDetails.contactNoOne.toString();
      customerContactNo2.text = widget.VendorDetails.contactNoTwo.toString();
      address.text = widget.VendorDetails.vendor_address;
      shippingaddress.text = widget.VendorDetails.shippingAddress;
      gstNo.text = widget.VendorDetails.gstinNo;
      panNo.text = widget.VendorDetails.panNo;

      _onSelectState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/new_vendors");
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
                  Navigator.pushReplacementNamed(context, '/new_vendors');
                }),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                !isEdit ? "Add Vendor" : "Edit Vendor",
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
                    textField(
                      vendorName,
                      "Name",
                    ),
                    textField(
                      companyName,
                      "Company Name",
                    ),
                    acountDropdown(),
                    textField(
                      customerContactNo1,
                      "Contact No1",
                    ),
                    textField(
                      customerContactNo2,
                      "Contact No2",
                    ),
                    textField(
                      address,
                      "Customer Address",
                    ),
                    textField(
                      shippingaddress,
                      "Shipping Address",
                    ),
                    textField(
                      gstNo,
                      "Gst No",
                    ),
                    textField(
                      panNo,
                      "Pan No",
                    ),
                    dropdown3(),
                    gstTreatmentDropdown(),
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

  Widget textField(TextEditingController controller, String hintText,
      {IconData prefixIcon, bool isRow = false, IconData suffixIcon}) {
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
              if (value.isEmpty) {
                return hintText + " is empty";
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

  dropdown3() {
    return Column(
      children: _statelst.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                width: MediaQuery.of(context).size.width - 0.4,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: DropdownSearch<dynamic>(
                  dropdownSearchDecoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: 15.0),
                    labelText: "State",
                    labelStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.w600),
                    // enabledBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(
                    //     color: Color(0xFFd3d2d2),
                    //   ),
                    //   borderRadius: BorderRadius.circular(15),
                    // ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(15),
                    //   borderSide: BorderSide(
                    //     color: Color(0XFF5050C7),
                    //   ),
                    // ),
                    filled: true,
                    fillColor: Color(0xFFFFFF),
                    contentPadding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  onChanged: (dynamic value) {
                    _selectedStateValue = value;
                    print(_selectedStateValue);
                  },
                  mode: Mode.MENU,
                  itemAsString: (dynamic state) => state["state_name"],
                  items: e.value,
                  showSelectedItem: false,
                  selectedItem: _selectedStateValue,
                  // label: "Select Driver Name",
                  showSearchBox: true,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'State name is empty';
                    }
                    return null;
                  },
                  searchBoxDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                    // labelText: "Employee Name",
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  acountDropdown() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 0.4,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: DropdownSearch<dynamic>(
              dropdownSearchDecoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 15.0),
                labelText: "Account Type",
                labelStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w600),
                // enabledBorder: OutlineInputBorder(
                //   borderSide: BorderSide(
                //     color: Color(0xFFd3d2d2),
                //   ),
                //   borderRadius: BorderRadius.circular(15),
                // ),
                // focusedBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                //   borderSide: BorderSide(
                //     color: Color(0XFF5050C7),
                //   ),
                // ),
                filled: true,
                fillColor: Color(0xFFFFFF),
                contentPadding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              showSelectedItem: false,
              selectedItem: _selectedType,
              onChanged: (dynamic value) {
                _selectedType = value;
              },
              mode: Mode.MENU,
              itemAsString: (dynamic accountType) =>
                  accountType['account_holder_type'],
              items: _accountTypeslst,
              showSearchBox: true,
              validator: (text) {
                if (text == null) {
                  return 'Account Type is empty';
                }
                return null;
              },
              searchBoxDecoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                // labelText: "Employee Name",
              ),
            ),
          ),
        ),
      ),
    );
  }

  gstTreatmentDropdown() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 0.4,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: DropdownSearch<AccountHolderType>(
              dropdownSearchDecoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 15.0),
                labelText: "Gst Treatment",
                labelStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w600),
                filled: true,
                fillColor: Color(0xFFFFFF),
                contentPadding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              showSelectedItem: false,
              selectedItem: _selectedGstTreatment,
              onChanged: (AccountHolderType value) {
                _selectedGstTreatment = value;
              },
              mode: Mode.MENU,
              itemAsString: (AccountHolderType _gstTreatment) =>
                  _gstTreatment.gstTreatmentName,
              items: _gstTreatments,
              showSearchBox: true,
              validator: (text) {
                if (text == null) {
                  return 'Please Select Any Gst Treatment';
                }
                return null;
              },
              searchBoxDecoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                // labelText: "Employee Name",
              ),
            ),
          ),
        ),
      ),
    );
  }

  _saveDetails() async {
    print("save");

    if (_formkey.currentState.validate()) {
      Map body = {
        "company_id": companyId.toString(),
        "user_id": userId.toString(),
        "account_holder_type_id": _selectedType['id'].toString(),
        "company_name": companyName.text.toString(),
        "vendor_name": vendorName.text.toString(),
        "contact_no_one": customerContactNo1.text.toString(),
        "contact_no_two": customerContactNo2.text.toString(),
        "gstin_no": gstNo.text.toString(),
        "pan_no": panNo.text.toString(),
        "vendor_address": address.text.toString(),
        "shipping_address": shippingaddress.text.toString(),
        "state_name": _selectedStateValue['state_name'].toString(),
        "state_code": _selectedStateValue['state_id'].toString(),
        "token": token.toString(),
      };

      await VendorService().insertNewVendor(body).then((result) {
        setState(() {
          Navigator.pushNamedAndRemoveUntil(
              context, '/new_vendors', (Route<dynamic> route) => false);
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                _buildPopupDialog(context, "New Vendor Added successfully."),
          );
        });
      });
    }
  }

  _editDetail() async {
    if (_formkey.currentState.validate()) {
      Map body = {
        "id": widget.VendorDetails.id.toString(),
        "company_id": companyId.toString(),
        "user_id": userId.toString(),
        "accout_holder_old_id": widget.VendorDetails.accountHolderId.toString(),
        // "account_holder_type_id": _selectedType.id.toString(),
        "account_holder_type_id": _selectedType['id'].toString(),
        "company_name": companyName.text.toString(),
        "vendor_name": vendorName.text.toString(),
        "contact_no_one": customerContactNo1.text.toString(),
        "contact_no_two": customerContactNo2.text.toString(),
        "gstin_no": gstNo.text.toString(),
        "pan_no": panNo.text.toString(),
        "vendor_address": address.text.toString(),
        "shipping_address": shippingaddress.text.toString(),
        "state_name": _selectedStateValue['state_name'].toString(),
        "state_code": _selectedStateValue['state_id'].toString(),
        "token": token.toString(),
      };

      await VendorService().editVendor(body).then((result) {
        setState(() {
          Navigator.pushNamedAndRemoveUntil(
              context, '/new_vendors', (Route<dynamic> route) => false);
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                _buildPopupDialog(context, "Vendor Updated successfully."),
          );
        });
      });
    }
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
              context, '/new_vendors', (Route<dynamic> route) => false);
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('OK'),
      ),
    ],
  );
}
