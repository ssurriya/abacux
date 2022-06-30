import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/check_box.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/customer_model.dart';
import 'package:abacux/screens/customer/add_and_edit_customer.dart';
import 'package:abacux/services/customer_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'sales_receipt_screen.dart';

class SalesReceiptScreen extends StatefulWidget {
  static const route = "/sales_receipt_details_screen";
  const SalesReceiptScreen({Key key}) : super(key: key);

  @override
  _SalesReceiptScreenState createState() => _SalesReceiptScreenState();
}

class _SalesReceiptScreenState extends State<SalesReceiptScreen> {
  TextEditingController customerName = TextEditingController();
  TextEditingController receiptNo = TextEditingController();
  TextEditingController paymentDate = TextEditingController();
  TextEditingController paymentMethod = TextEditingController();
  TextEditingController ref = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController unappliedAmount = TextEditingController();
  TextEditingController messageOnStatement = TextEditingController();
  DateTime date = DateTime.now();

  bool _isCheckBoxActive = true;

  Customer _selectedCustomer;
  List<Customer> _customerList = [];

  String _selectedMethod;

  int userId, companyId;
  String token;

  TextStyle _textStyle = TextStyle(
      fontSize: 16.0,
      color: Colors.black.withOpacity(0.8),
      fontWeight: FontWeight.w600);

  void initState() {
    super.initState();
    paymentDate.text = dateFormat(date);
    _getUserAndCompanyId();
  }

  String dateFormat(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
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

    _getCustomerList();
  }

  _getCustomerList() async {
    Map body = {
      'user_id': userId.toString(),
      'token': token.toString(),
      'company_id': companyId.toString(),
    };
    await CustomerService().customerList(body).then((value) {
      setState(() {
        _customerList = value;
      });
    });
  }

  bool _isVisibleTransactions = true;

  //Temp

  List<String> _methodList = ["Cheque", "Upi", "Bank", "Cash", "Test"];

  List _outStandingTransactions = [
    {
      "description": "#1",
      "dueDate": "27/03/2022",
      "netAmount": "2551.200",
      "balance": "2551.200",
      "payment": "2000",
      "isAdded": false
    },
    {
      "description": "#2",
      "dueDate": "27/03/2022",
      "netAmount": "2551.200",
      "balance": "2551.200",
      "payment": "3900",
      "isAdded": false
    },
    {
      "description": "#3",
      "dueDate": "27/03/2022",
      "netAmount": "2551.200",
      "balance": "2551.200",
      "payment": "1000",
      "isAdded": false
    },
  ];

  bool _selectAllTransactions = false;

  //Temp

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/dashboard");
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.95),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.cancel,
                color: AppConstant().appThemeColor,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, SalesReceiptListScreen.route);
              }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sales Receipt",
                style: TextStyle(color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  "Save",
                  style: TextStyle(color: AppConstant().appThemeColor),
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                dropDownForCustomer(),
                SizedBox(
                  height: 5,
                ),
                textField(receiptNo, 'Receipt No', readOnly: true),
                dateTextField(),
                dropDownForMethod(),
                textField(amount, 'Amount'),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: [
                      Checkbox(
                          value: _selectAllTransactions,
                          activeColor: AppConstant().appThemeColor,
                          onChanged: (value) {
                            int count = 0;
                            setState(() {
                              _selectAllTransactions = !_selectAllTransactions;
                              _outStandingTransactions.map((e) {
                                e['isAdded'] = value;
                                if (e['isAdded']) count += 1;
                              }).toList();
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Outstanding Transactions",
                          style: TextStyle(
                              fontSize: 17,
                              letterSpacing: 0.5,
                              color: AppConstant().appThemeColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isVisibleTransactions = !_isVisibleTransactions;
                          });
                        },
                        child: _productAndAdditionalChargeListVisibility(
                            _isVisibleTransactions,
                            _outStandingTransactions.length),
                      ),
                    ],
                  ),
                ),
                // Out Standing Transaction Listing Screen
                _outStandingTransactionsWidget(),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.white,
                  child: textField(messageOnStatement, 'Message On Statement'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _productAndAdditionalChargeListVisibility(bool isVisible, int count) {
    return new Row(children: <Widget>[
      new Icon(
        isVisible
            ? Icons.keyboard_arrow_down_outlined
            : Icons.keyboard_arrow_up_outlined,
        size: 38,
        color: AppConstant().appThemeColor,
      ),
      isVisible
          ? Container()
          : count != null && count != 0
              ? Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.7)),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(),
    ]);
  }

  Widget dropDownForCustomer() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 0.4,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: DropdownSearch<Customer>(
              dropdownSearchDecoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: 15.0),
                  labelText: "Customer Name",
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
                  suffixIcon: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                            settings:
                                const RouteSettings(name: '/add_customer'),
                            builder: (context) => AddAndEditCustomerScreen(
                              path: SalesReceiptScreen.route,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Icon(
                          Icons.add_circle_outline_outlined,
                          color: AppConstant().appThemeColor,
                        ),
                      ))),
              showSelectedItem: false,
              selectedItem: _selectedCustomer,
              onChanged: (Customer customer) async {
                _selectedCustomer = customer;
                // await ProformaInvoiceService.getInstance()
                // .setCustomer(customer);
              },
              mode: Mode.MENU,
              itemAsString: (Customer customer) => customer.customerName,
              items: _customerList,
              showSearchBox: true,
              validator: (text) {
                if (text == null) {
                  return 'Please select any customer';
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

  Widget dropDownForMethod() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 0.4,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: DropdownSearch<String>(
              dropdownSearchDecoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 15.0),
                labelText: "Method",
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
              selectedItem: _selectedMethod,
              onChanged: (String method) async {
                _selectedMethod = method;
                // await ProformaInvoiceService.getInstance()
                // .setCustomer(customer);
              },
              mode: Mode.MENU,
              itemAsString: (String method) => method,
              items: _methodList,
              showSearchBox: true,
              validator: (text) {
                if (text == null) {
                  return 'Please select any customer';
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

  dateTextField() {
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
                        controller: paymentDate,
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
                          labelText: 'Date',
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
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2100));

    setState(() async {
      date = pickedDate;
      paymentDate.text = dateFormat(date);
    });
  }

  Widget textField(TextEditingController controller, String hintText,
      {IconData icon, String onTap, bool readOnly = false}) {
    // ignore: unnecessary_statements

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextFormField(
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            controller: controller,
            readOnly: readOnly,
            validator: (value) {
              if (value.isEmpty) {
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: onTap == "Date" ? "Date" : hintText,
                labelStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w600),
                fillColor: Color(0xFFEEEEFF),
                suffixIcon: Icon(
                  icon,
                  color: AppConstant().appThemeColor,
                )),
            onTap: () {
              if (onTap == "Date") {
                _selectedDate(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _outStandingTransactionsWidget() {
    return Visibility(
      visible: _isVisibleTransactions,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _outStandingTransactions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(
                  //   color: Colors.grey.withOpacity(0.6),
                  // ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  value: _outStandingTransactions[index]
                                      ['isAdded'],
                                  activeColor: AppConstant().appThemeColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _outStandingTransactions[index]
                                              ['isAdded'] =
                                          !_outStandingTransactions[index]
                                              ['isAdded'];
                                      if (!_outStandingTransactions[index]
                                          ['isAdded']) {
                                        _selectAllTransactions = false;
                                      }
                                    });
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Invoice ${_outStandingTransactions[index]['description']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      '${_outStandingTransactions[index]['dueDate']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 1.0,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\u{20B9}${_outStandingTransactions[index]['payment']}',
                            style: TextStyle(
                                fontSize: 20,
                                letterSpacing: 0.5,
                                color: Colors.grey,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Row(
                          children: [
                            Text(
                              "Net Amount   ",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 1.5,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              '${_outStandingTransactions[index]['netAmount']}',
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1.5,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Row(
                          children: [
                            Text("Balance         ",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 1.5,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400)),
                            Text(
                              '${_outStandingTransactions[index]['balance']}',
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1.5,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }

  checkBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 14.0, right: 8.0, top: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCheckBoxActive = !_isCheckBoxActive;
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.black)),
                        child: _isCheckBoxActive
                            ? Icon(
                                Icons.check_sharp,
                                size: 24,
                                color: AppConstant().appThemeColor,
                              )
                            : Icon(
                                Icons.check,
                                size: 24,
                                color: Colors.white,
                              )),
                  ),
                ),
                Text(
                  "1",
                  style: _textStyle,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                "Rs 0.00",
                style: _textStyle,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45.0, top: 8.0),
          child: Text(
            "Due: ${DateFormat('dd/MM/yyyy').format(date)}",
            style: _textStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45.0, top: 8.0, bottom: 5.0),
          child: Text(
            "Balance: Rs 0.00",
            style: _textStyle,
          ),
        ),
      ],
    );
  }

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date)
      setState(() {
        date = DateTime(picked.year, picked.month, picked.day, 23, 59);
        paymentDate.text = dateFormat(date);
      });
  }
}
