import 'package:abacux/common/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";

import 'sales_receipt.dart';

class SalesReceiptListScreen extends StatefulWidget {
  static const route = "/sales_receipt_list_screen";
  const SalesReceiptListScreen({Key key}) : super(key: key);

  @override
  State<SalesReceiptListScreen> createState() => _SalesReceiptListScreenState();
}

class _SalesReceiptListScreenState extends State<SalesReceiptListScreen> {
  TextEditingController _searchQuery = TextEditingController();

  bool _isSearching = false;

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
      Text("Sales Receipt",
          style: TextStyle(
              fontSize: 18,
              letterSpacing: 0.2,
              color: Colors.black,
              fontWeight: FontWeight.w600))
    ],
  );

  List<dynamic> _salesReceiptList = [
    {
      "receipt_no": 1,
      "customer_name": "S MEER FACRUDEEN MUNSHI",
      "receipt_date": "05-05-2022",
      "amount": 2000.0,
    },
    {
      "receipt_no": 2,
      "customer_name": "S MEER FACRUDEEN MUNSHI",
      "receipt_date": "16-03-2022",
      "amount": 1000.0,
    },
    {
      "receipt_no": 3,
      "customer_name": "A2test1",
      "receipt_date": "16-03-2022",
      "amount": 200.0,
    },
    {
      "receipt_no": 4,
      "customer_name": "A2test1",
      "receipt_date": "16-03-2022",
      "amount": 18.0,
    },
    {
      "receipt_no": 5,
      "customer_name": "A2test1",
      "receipt_date": "16-03-2022",
      "amount": 340.0,
    },
    {
      "receipt_no": 6,
      "customer_name": "A2test1",
      "receipt_date": "16-03-2022",
      "amount": 10000.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _groupByAlphabet(_salesReceiptList);
  }

  Map groupByAlphabet = {};

  _groupByAlphabet(List<dynamic> salesReceiptList) {
    groupByAlphabet = groupBy(salesReceiptList, (dynamic obj) {
      return obj['customer_name'][0];
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, SalesReceiptScreen.route);
          },
          backgroundColor: AppConstant().appThemeColor,
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: groupByAlphabet.isNotEmpty
              ? Column(
                  children: groupByAlphabet.entries.map((e) {
                    print(e);
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 20),
                            child: Text(e.key,
                                style: GoogleFonts.publicSans(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Divider(
                                height: 1.5,
                              ),
                            );
                          },
                          shrinkWrap: true,
                          itemCount: e.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            return salesReceiptItem(e.value[index]);
                          },
                        )
                      ],
                    );
                  }).toList(),
                )
              : Center(
                  child: Padding(
                  padding: const EdgeInsets.only(
                      top: 150, left: 110.0, right: 120, bottom: 300),
                  child: Text("No data Found !"),
                )),
        ));
  }

  Widget salesReceiptItem(dynamic salesReceipt) {
    return GestureDetector(
      onTap: () async {},
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        salesReceipt['customer_name'],
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        salesReceipt['receipt_no'].toString(),
                        style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.5,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       top: 8.0, right: 8.0, bottom: 8.0),
                    //   child: Text(
                    //     'Rs${widget.salesInvoicesList.}.00',
                    //     style: TextStyle(
                    //         fontSize: 16,
                    //         letterSpacing: 0.5,
                    //         fontWeight: FontWeight.w600),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        salesReceipt['amount'].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Date Format
  String _dateFormat(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
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
                child: Text("Sales Receipt",
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
                    onChanged: (value) {
                      _searchOperation(value);
                    },
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search,
                            color: AppConstant().appThemeColor),
                        hintText: "Search Sales Receipt",
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
          "Sales Invoices",
          style: new TextStyle(color: Colors.black),
        ),
      );
      _isSearching = false;
      _searchQuery.clear();
      _searchOperation("");
    });
  }

  _searchOperation(String searchText) {
    print(searchText);
  }
}
