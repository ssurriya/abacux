import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/sales_invoice_list.dart';
import 'package:abacux/services/sales_invoice_service.dart';
import 'package:abacux/widgets/sales_invoices_item.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SalesInvoicesScreen extends StatefulWidget {
  static const route = "/sales_invoices_screen";
  const SalesInvoicesScreen({Key key}) : super(key: key);

  @override
  _SalesInvoicesScreenState createState() => _SalesInvoicesScreenState();
}

class _SalesInvoicesScreenState extends State<SalesInvoicesScreen> {
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

  List<SaleInvoiceList> salesInvoicesList = [];
  Map groupByAlphabet = {};

  DateTime startDate = DateTime.now();

  DateTime endDate = DateTime.now();

  bool _isSearching = false;

  bool _isLoading = false;

  TextEditingController _searchQuery = TextEditingController();

  int userId, companyId;
  String token;

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
      Text("Sales Invoices",
          style: TextStyle(
              fontSize: 18,
              letterSpacing: 0.2,
              color: Colors.black,
              fontWeight: FontWeight.w600))
    ],
  );

  @override
  void initState() {
    super.initState();
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
    setState(() {
      _isLoading = true;
    });
    await Storage().readInt("userId").then((value) {
      userId = value;
    });
    await Storage().readString("token").then((value) {
      token = value;
    });
    await Storage().readInt("selectedCompanyId").then((value) {
      companyId = value;
    });
    // Call Get Proforma Invoice List From Api
    _getSalesInvoicesList();
  }

  _getSalesInvoicesList() async {
    Map body = {
      "form_date": startDate.toString(),
      "to_date": endDate.toString()
    };
    await SalesInvoiceService.getInstance()
        .getSalesInvoiceList(body)
        .then((value) {
      setState(() {
        salesInvoicesList = value;
        _isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
    _sortByName();
  }

  _sortByName() {
    salesInvoicesList.sort((a, b) {
      print("${a.customerName}:${b.customerName}");
      return a.customerName == null
          ? 0
          : b.customerName == null
              ? 0
              : a.customerName
                  .toLowerCase()
                  .compareTo(b.customerName.toLowerCase());
    });
    _groupByAlphabet(salesInvoicesList);
  }

  _groupByAlphabet(List<SaleInvoiceList> salesInvoicesList) {
    groupByAlphabet = groupBy(salesInvoicesList, (SaleInvoiceList obj) {
      return obj.customerName[0];
    });
    setState(() {});
  }

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
            SalesInvoiceService.getInstance().setCustomer(null);
            SalesInvoiceService.getInstance().setDateTime(null);
            SalesInvoiceService.getInstance().setPaymentDateTime(null);
            SalesInvoiceService.getInstance().setTerms(null);
            SalesInvoiceService.getInstance().setDiscountInAmt(null);
            SalesInvoiceService.getInstance().setDiscountInPercentage(null);
            SalesInvoiceService.getInstance()
                .deleteAllSalesInvoiceProductToLocal();
            SalesInvoiceService.getInstance()
                .deleteAllSalesInvoiceAdditionalChargesToLocal();

            Navigator.pushReplacementNamed(
                context, '/add_sales_invoices_screen');
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
              _isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: AppConstant().appThemeColor,
                        ),
                      ),
                    )
                  : groupByAlphabet.isNotEmpty
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
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
                                  itemCount: e.value.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SalesInvoicesItem(e.value[index]);
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
                        ))
              // ListView.separated(
              //   shrinkWrap: true,
              //   separatorBuilder: (context, index) {
              //     return Divider(
              //       height: 0.5,
              //     );
              //   },
              //   itemCount: salesInvoicesList.length,
              //   itemBuilder: (context, index) {
              //     return SalesInvoicesItem(salesInvoicesList[index]);
              //   },
              // ),
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
                child: Text("Sales Invoices",
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
                        hintText: "Search Sales Invoices",
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
    List<SaleInvoiceList> filteredSaleInvoiceList = [];
    filteredSaleInvoiceList = salesInvoicesList
        .where((element) => element.customerName
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
    _groupByAlphabet(filteredSaleInvoiceList);
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
        _getSalesInvoicesList();
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
        _getSalesInvoicesList();
      });
  }
}
