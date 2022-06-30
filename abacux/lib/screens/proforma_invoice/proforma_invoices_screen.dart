import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/proforma_invoice_list_model.dart';
import 'package:abacux/services/proforma_invoice_service.dart';
import 'package:abacux/widgets/porforma_invoices_item.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";

class ProformaInvoicesScreen extends StatefulWidget {
  const ProformaInvoicesScreen({Key key}) : super(key: key);

  @override
  _ProformaInvoicesScreenState createState() => _ProformaInvoicesScreenState();
}

class _ProformaInvoicesScreenState extends State<ProformaInvoicesScreen> {
  final GlobalKey flushBarKey = GlobalKey();
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

  List<dynamic> proformaInvoicesLst = [];

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
      Text("Proforma Invoices",
          style: TextStyle(
              fontSize: 18,
              letterSpacing: 0.2,
              color: Colors.black,
              fontWeight: FontWeight.w600))
    ],
  );

  int userId, companyId;
  String token;

  bool _isLoading = false;

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
    _getProformaInvoiceListFromApi();
  }

  List<ProformaInvoiceList> proformaInvoiceList = [];

  Map groupByAlphabet = {};

  _getProformaInvoiceListFromApi() async {
    Map body = {"user_id": userId.toString(), "token": token.toString()};
    setState(() {
      _isLoading = true;
    });
    await ProformaInvoiceService.getInstance()
        .getProfromaInvoiceListFromApi(body)
        .then((value) {
      print(value);
      setState(() {
        proformaInvoiceList = value;
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      _showFlushBar(
          context, "Error Occur Try Again Later", Icons.error, Colors.red);
    });

    // ignore: unnecessary_statements
    proformaInvoiceList.isNotEmpty ? _sortByName() : null;
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

  _sortByName() {
    proformaInvoiceList.sort((a, b) {
      print("${a.customerName}:${b.customerName}");
      return a.customerName == null
          ? 0
          : b.customerName == null
              ? 0
              : a.customerName
                  .toLowerCase()
                  .compareTo(b.customerName.toLowerCase());
    });
    _groupByAlphabet(proformaInvoiceList);
  }

  _groupByAlphabet(List<ProformaInvoiceList> _estimateDetails) {
    groupByAlphabet = groupBy(_estimateDetails, (ProformaInvoiceList obj) {
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
            ProformaInvoiceService.getInstance().deleteAllProductToLocal();
            ProformaInvoiceService.getInstance()
                .deleteAllProformaAdditionalChargesToLocal();
            ProformaInvoiceService.getInstance().setCustomer(null);
            ProformaInvoiceService.getInstance().setDateTime(null);
            ProformaInvoiceService.getInstance()
                .setProformaInvoiceEditUsingId(null);
            ProformaInvoiceService.getInstance().setAdditionalChargeIds(null);
            ProformaInvoiceService.getInstance().setDiscountInPercentage(null);
            ProformaInvoiceService.getInstance().setDiscountInAmt(null);
            Navigator.pushReplacementNamed(context, '/add_proforma_invoices');
          },
          backgroundColor: AppConstant().appThemeColor,
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: CircularProgressIndicator(),
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
                                    return ProformaInvoicesItem(
                                      proformaInvoicesList: e.value[index],
                                      userId: userId,
                                      companyId: companyId,
                                      token: token,
                                    );
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
                child: Text("Proforma Invoices",
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
                        hintText: "Search proforma Invoices",
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
          "Proforma Invoices",
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
    List<ProformaInvoiceList> filteredProformaInvoice = [];
    filteredProformaInvoice = proformaInvoiceList
        .where((element) => element.customerName
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
    _groupByAlphabet(filteredProformaInvoice);
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
