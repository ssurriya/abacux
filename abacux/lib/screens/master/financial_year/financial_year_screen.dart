import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/financial_year_model.dart';
import 'package:abacux/model/ware_houses_list_model.dart';
import 'package:abacux/services/financial_year_service.dart';
// import 'package:abacux/services/estimate_service.dart';
import 'package:another_flushbar/flushbar.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'add_or_edit_financial_screen.dart';

class FinancialYearScreen extends StatefulWidget {
  static const route = "/financial_year_Screen";
  const FinancialYearScreen({Key key}) : super(key: key);

  @override
  _FinancialYearScreenState createState() => _FinancialYearScreenState();
}

class _FinancialYearScreenState extends State<FinancialYearScreen> {
  final GlobalKey flushBarKey = GlobalKey();
  TextEditingController _searchQuery = TextEditingController();

  List<FinancialYearElement> _financialYearList = [];

  List<FinancialYearElement> _filteredFinancialYear = [];

  int count = 0;

  List<dynamic> randomColors = [
    Color(0xFFa7d4a8),
    Color(0xFFa7d4a8),
    Color(0xFFf5dd8c),
    Color(0xFFf8c593),
    Color(0xFF8cabe8),
    Color(0xFFf8c593),
  ];

  int userId;
  int companyId;
  String token;
  bool _isLoading;
  Map groupByAlphabet = {};

  Widget appBarTitle = Row(
    children: [
      Icon(
        Icons.arrow_back,
        color: AppConstant().appThemeColor,
      ),
      Text("Financial Year",
          style: GoogleFonts.publicSans(
              fontSize: 18,
              letterSpacing: 0.2,
              color: Colors.black,
              fontWeight: FontWeight.w600))
    ],
  );

  bool _isSearching = false;
  String _searchText = "";

  Icon actionIcon = new Icon(
    Icons.search,
    color: AppConstant().appThemeColor,
  );

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _getUserAndCompanyId();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check Internet Connection
    CheckConnectivity.getInstance().checkConnectivity(context);
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

    // Call Customer listing service
    _getFinancialYearList();
  }

  // Get Customer Listing
  _getFinancialYearList() async {
    Map body = {
      'user_id': userId.toString(),
      'token': token.toString(),
      'company_id': companyId.toString(),
    };

    List<FinancialYearElement> financialYearList = [];

    await FinancialYearService.getInstance()
        .financialYearList(body)
        .then((value) {
      print(value);
      financialYearList = value.financialYear;
      _filteredFinancialYear = financialYearList;
      setState(() {
        _isLoading = true;
      });
      _setFinancialYearList(financialYearList);
    }).catchError((onError) {
      print(onError);
      setState(() {
        _isLoading = true;
      });
      _showFlushBar(
          context, "Error Occur Try Again Later", Icons.error, Colors.red);
    });
  }

  _setFinancialYearList(List<FinancialYearElement> financialYearList) {
    setState(() {
      _financialYearList = financialYearList;
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/dashboard");
        return Future.value(true);
      },
      child: Scaffold(
        appBar: buildBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.pushReplacementNamed(
                context, AddOrEditFinancialYear.route);
          },
          backgroundColor: AppConstant().appThemeColor,
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SingleChildScrollView(
          child: _isLoading == true
              ? Container(
                  color: Colors.grey.withOpacity(0.1),
                  child: Column(
                    children: [
                      //Search Text Field

                      SizedBox(
                        height: 8,
                      ),

                      //New Customer Listing

                      _financialYearList.length > 0
                          ? Column(
                              children: [
                                ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Divider(
                                        height: 1.5,
                                      ),
                                    );
                                  },
                                  shrinkWrap: true,
                                  itemCount: _financialYearList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _getWarehouseItem(
                                        _financialYearList[index]);
                                  },
                                )
                              ],
                            )
                          : Center(
                              child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 150,
                                  left: 110.0,
                                  right: 120,
                                  bottom: 550),
                              child: Text("Search Not Found !"),
                            ))
                    ],
                  ),
                )
              : (Center(
                  child: Padding(
                  padding: const EdgeInsets.only(
                      top: 150, left: 110.0, right: 120, bottom: 300),
                  child: CircularProgressIndicator(),
                ))),
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
                child: Text("Financial Year",
                    style: TextStyle(
                        fontFamily: 'Poppins',
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
                      hintText: "Search",
                      hintStyle: new TextStyle(color: Colors.black),
                    ),
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
          "Financial Year",
          style: new TextStyle(color: Colors.black),
        ),
      );
      _isSearching = false;
      _searchQuery.clear();
      _searchOperation("");
    });
  }

  _searchOperation(String searchText) {
    List<FinancialYearElement> filteredFinancialYear = [];
    print(_dateFormat(DateTime(2022, 03, 01))
        .toLowerCase()
        .contains(searchText.toLowerCase()));
    filteredFinancialYear = _filteredFinancialYear
        .where((element) =>
            _dateFormat(element.fromDate)
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            _dateFormat(element.toDate)
                .toLowerCase()
                .contains(searchText.toLowerCase()))
        .toList();
    _setFinancialYearList(filteredFinancialYear);
  }

  // Date Format
  String _dateFormat(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  _getWarehouseItem(FinancialYearElement financialListElement) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddOrEditFinancialYear(
                  financialYear: financialListElement,
                )));
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Decimal ${financialListElement.decimal}",
                        style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.5,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "From  ${_dateFormat(financialListElement.fromDate)}",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "To      ${_dateFormat(financialListElement.toDate)}",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                financialListElement.status == 1
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.7)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Active",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          decoration:
                              BoxDecoration(color: Colors.red.withOpacity(0.7)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "DeActive",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
