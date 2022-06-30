import 'package:abacux/common/app_constant.dart';
import 'package:abacux/widgets/credit_note_item.dart';
import 'package:abacux/widgets/debit_note_item.dart';
import 'package:abacux/widgets/purchase_bill_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add_or_edit_debit_note_screen.dart';

class DebitNoteScreen extends StatefulWidget {
  static const route = '/debit_note_screen';
  const DebitNoteScreen({Key key}) : super(key: key);

  @override
  _DebitNoteScreenState createState() => _DebitNoteScreenState();
}

class _DebitNoteScreenState extends State<DebitNoteScreen> {
  TextEditingController vendorName = TextEditingController();
  TextEditingController invoiceNo = TextEditingController();
  TextEditingController invoiceDate = TextEditingController();
  TextEditingController subTotal = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController cgst = TextEditingController();
  TextEditingController sgst = TextEditingController();
  TextEditingController igst = TextEditingController();
  TextEditingController salesTax = TextEditingController();
  TextEditingController total = TextEditingController();

  List<dynamic> debitNoteLst = [
    {
      "name": "Abishek",
      "estimateNo": "#1",
      "amount": "100",
      "date": "09/02/2022",
    },
    {
      "name": "Cathrine",
      "estimateNo": "#2",
      "amount": "100",
      "date": "09/02/2022",
    },
    {
      "name": "John",
      "estimateNo": "#3",
      "amount": "100",
      "date": "09/02/2022",
    },
    {
      "name": "David",
      "estimateNo": "#4",
      "amount": "100",
      "date": "09/02/2022",
    },
    {
      "name": "Joseph",
      "estimateNo": "#5",
      "amount": "100",
      "date": "09/02/2022",
    },
  ];

  DateTime startDate = DateTime.now();

  DateTime endDate = DateTime.now();

  bool _isSearching = false;

  TextEditingController _searchQuery = TextEditingController();

  Icon actionIcon = new Icon(
    Icons.search,
    color: AppConstant().appThemeColor,
  );

  Widget appBarTitle = Row(
    children: [
      Icon(
        Icons.arrow_back,
        color: AppConstant().appThemeColor,
      ),
      Text("proforma Invoices",
          style: TextStyle(
              fontSize: 18,
              letterSpacing: 0.2,
              color: Colors.black,
              fontWeight: FontWeight.w600))
    ],
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/dashboard");
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.96),
        appBar: buildBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, AddOrEditDebitNoteScreen.route);
          },
          backgroundColor: AppConstant().appThemeColor,
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectedFromDate(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "From",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: _dateTextButton(startDate),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        _selectedToDate(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Row(
                          children: [
                            Text(
                              "To",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: _dateTextButton(endDate),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0.5,
                  );
                },
                itemCount: debitNoteLst.length,
                itemBuilder: (context, index) {
                  return DebitNoteItem(debitNoteLst[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
          child: Icon(
            Icons.arrow_back,
            color: AppConstant().appThemeColor,
          ),
        ),
        title: !_isSearching
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Debit Note",
                    style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 0.2,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)),
              )
            : appBarTitle,
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(
                    Icons.close,
                    color: AppConstant().appThemeColor,
                  );
                  this.appBarTitle = new TextField(
                    controller: _searchQuery,
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search,
                            color: AppConstant().appThemeColor),
                        hintText: "Search Debit Note",
                        hintStyle: new TextStyle(color: Colors.black)),
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: AppConstant().appThemeColor,
      );
      this.appBarTitle = Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: new Text(
          "Debit Note",
          style: new TextStyle(color: Colors.black),
        ),
      );
      _isSearching = false;
      _searchQuery.clear();
    });
  }

  Widget _dateTextButton(DateTime date) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(DateFormat('dd-MMM').format(date)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.date_range,
              color: AppConstant().appThemeColor,
            ),
          )
        ],
      ),
    );
  }

  Future<Null> _selectedFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate)
      setState(() {
        startDate = DateTime(picked.year, picked.month, picked.day, 23, 59);
      });
  }

  Future<Null> _selectedToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate)
      setState(() {
        endDate = DateTime(picked.year, picked.month, picked.day, 23, 59);
      });
  }
}
