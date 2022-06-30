import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/custom_model_dialog.dart';
import 'package:abacux/common/drop_down.dart';
import 'package:abacux/common/text_field.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/ware_houses_bin_model.dart';
import 'package:abacux/model/ware_houses_list_model.dart';
// import 'package:abacux/model/ware_houses_list_model.dart';
import 'package:abacux/services/ware_house_service.dart';
import 'package:abacux/services/ware_houses_bin_service.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ware_house_bin_screen.dart';

class AddOrEditWarehouseBin extends StatefulWidget {
  static const route = "/add_or_edit_ware_house_bin";
  AddOrEditWarehouseBin({this.warehousesBinListElement});
  final WarehousesBinListElement warehousesBinListElement;

  @override
  State<AddOrEditWarehouseBin> createState() => _AddOrEditWarehouseBinState();
}

class _AddOrEditWarehouseBinState extends State<AddOrEditWarehouseBin> {
  TextEditingController binCode = TextEditingController();
  TextEditingController binName = TextEditingController();
  List<WarehousesListElement> _wareHouses = [];
  WarehousesListElement selectedWareHouse;

  final GlobalKey flushBarKey = GlobalKey();

  int userId, companyId;
  String token;

  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _getUserAndCompanyId();
    if (widget.warehousesBinListElement != null) {
      setState(() {
        _isEdit = true;
        binCode.text = widget.warehousesBinListElement.binCode;
        binName.text = widget.warehousesBinListElement.binName;
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

    _getWarehouseList();
  }

  // Get Customer Listing
  _getWarehouseList() async {
    Map body = {
      'user_id': userId.toString(),
      'token': token.toString(),
      'company_id': companyId.toString(),
    };

    await WareHousesService.getInstance().wareHouseList(body).then((value) {
      print(widget.warehousesBinListElement.warehouseId);
      setState(() {
        _wareHouses = value.warehousesList;
        if (_isEdit) {
          selectedWareHouse = value.warehousesList.firstWhere((element) =>
              element.id == widget.warehousesBinListElement.warehouseId);
        }
      });
    }).catchError((onError) {
      print(onError);

      _showFlushBar(
          context, "Error Occur Try Again Later", Icons.error, Colors.red);
    });
    _sortByName();
  }

  _sortByName() {
    _wareHouses.sort((a, b) {
      return a.warehouseName == null
          ? 0
          : b.warehouseName == null
              ? 0
              : a.warehouseName
                  .toLowerCase()
                  .compareTo(b.warehouseName.toLowerCase());
    });
  }

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
      duration: Duration(seconds: 1000),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(_isEdit ? "Edit Ware House Bin" : "Add Ware House Bin",
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
                  context, WarehousesBinScreen.route);
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
                      "id": widget.warehousesBinListElement.id.toString(),
                    };

                    _showModelDialog("Delete", "Are you sure want to delete?",
                        buttonText1: "Yes",
                        buttonText2: "No", onPressedButton1: () async {
                      await WareHousesBinService.getInstance()
                          .deleteWareHouseBin(body)
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
                  "bin_code": binCode.text,
                  "bin_name": binName.text,
                  "warehouse_id": selectedWareHouse.id.toString()
                };
                if (_isEdit)
                  body['id'] = widget.warehousesBinListElement.id.toString();

                print(body);

                _isEdit
                    ? await WareHousesBinService.getInstance()
                        .editWareHouseBin(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {})
                    : await WareHousesBinService.getInstance()
                        .addWareHouseBin(body)
                        .then((value) {
                        _navigate();
                      }).catchError((onError) {});
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            dropDown("Ware House", selectedWareHouse, _wareHouses,
                (WarehousesListElement value) {
              return value.warehouseName;
            }, onchanged: (WarehousesListElement value) {
              selectedWareHouse = value;
            }),
            textField(binCode, "Bin Code", onchanged: (value) {}),
            textField(binName, "Bin Name", onchanged: (value) {}),
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
    Navigator.pushReplacementNamed(context, WarehousesBinScreen.route);
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
