import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/purchase_order_model.dart';
import 'package:abacux/services/purchase_order_service.dart';
import 'package:another_flushbar/flushbar.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'add_or_edit_purchase_order_screen.dart';

class PurchaseOrderScreen extends StatefulWidget {
  const PurchaseOrderScreen({Key key}) : super(key: key);

  @override
  _PurchaseOrderScreenState createState() => _PurchaseOrderScreenState();
}

class _PurchaseOrderScreenState extends State<PurchaseOrderScreen> {
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

  DateTime startDate = DateTime.now();

  DateTime endDate = DateTime.now();

  bool _isSearching = false;

  TextEditingController _searchQuery = TextEditingController();

  List<PurchaseOrder> _purchaseOrders = []; //Purchase Order Listing

  List<PurchaseOrder> _filteredPurchaseOrder = [];

  int userId, id, companyId; //Save values from storage
  String token; //Save values from storage

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

  Map groupByAlphabet = {};

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

  // Get User, Company Id and token
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

    // Call Purchase order listing service
    _getPurchaseOrderList();
  }

  // Purchase order listing service
  _getPurchaseOrderList() async {
    Map body = {"user_id": userId.toString(), "token": token};
    setState(() {
      _isLoading = true;
    });
    await PurchaseOrderService.getInstance()
        .getPurchaseOrderList(body)
        .then((value) async {
      setState(() {
        _purchaseOrders = value;
        _filteredPurchaseOrder = value;
        _isLoading = false;
      });
      _sortByName();
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      _showFlushBar(
          context, "Error Occur Try Again Later", Icons.error, Colors.red);
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

  _sortByName() {
    setState(() {
      _filteredPurchaseOrder
        ..sort((a, b) {
          return a.vendorName == null
              ? 0
              : b.vendorName == null
                  ? 0
                  : a.vendorName
                      .toLowerCase()
                      .compareTo(b.vendorName.toLowerCase());
        });
    });

    _groupByAlphabet(_filteredPurchaseOrder);
  }

  _groupByAlphabet(List<PurchaseOrder> _purchaseOrders) {
    groupByAlphabet = groupBy(_purchaseOrders, (PurchaseOrder obj) {
      return obj.vendorName[0];
    });
    setState(() {});
  }

  // Date Format
  String _dateFormat(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
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
            PurchaseOrderService.getInstance().deleteAllPurchaseProduct();
            PurchaseOrderService.getInstance()
                .deleteAllPurchaseAdditionalCharges();

            PurchaseOrderService.getInstance().setVendor(null);
            PurchaseOrderService.getInstance().setDateTime(null);
            PurchaseOrderService.getInstance()
                .setPurchaseOrderEditUsingId(null);
            PurchaseOrderService.getInstance().setAdditionalChargeIds(null);
            PurchaseOrderService.getInstance().setDiscountInAmt(null);
            PurchaseOrderService.getInstance().setDiscountInPercenatge(null);
            PurchaseOrderService.getInstance().setInvoiceNo(null);
            Navigator.pushReplacementNamed(
                context, '/add_purchase_order_screen');
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
                                    return purchaseOrderItem(e.value[index]);
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
                child: Text("Purchase Order",
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
                        hintText: "Search Purchase Orders",
                        hintStyle: new TextStyle(color: Colors.black)),
                    onChanged: (value) {
                      _searchOperation(value);
                    },
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
          "Purchase Order",
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
    _filteredPurchaseOrder = [];
    setState(() {
      _filteredPurchaseOrder = _purchaseOrders
          .where((element) => element.vendorName
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    });
    _groupByAlphabet(_filteredPurchaseOrder);
  }

  Widget purchaseOrderItem(PurchaseOrder purchaseOrders) {
    return GestureDetector(
      onTap: () async {
        Map body = {
          "user_id": userId.toString(),
          "company_id": companyId.toString(),
          "token": token,
          "id": purchaseOrders.id.toString()
        };
        await PurchaseOrderService.getInstance()
            .getPurchaseOrderEditUsingId(body)
            .then((value) {
          PurchaseOrderService.getInstance().deleteAllPurchaseProduct();
          PurchaseOrderService.getInstance()
              .deleteAllPurchaseAdditionalCharges();
          PurchaseOrderService.getInstance().setVendor(null);
          PurchaseOrderService.getInstance().setDateTime(null);
          PurchaseOrderService.getInstance().setPurchaseOrderEditUsingId(null);
          PurchaseOrderService.getInstance().setAdditionalChargeIds(null);
          PurchaseOrderService.getInstance().setDiscountInAmt(null);
          PurchaseOrderService.getInstance().setDiscountInPercenatge(null);
          PurchaseOrderService.getInstance().setInvoiceNo(null);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddOrEditPurchaseOrderScreen(
                    purchaseOrder: value,
                  )));
        });
      },
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
                        purchaseOrders.vendorName,
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "PO-${purchaseOrders.poNo}",
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
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, right: 8.0, bottom: 8.0),
                      child: Text(
                        '₹ ${purchaseOrders.grandTotal}.00',
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        _dateFormat(purchaseOrders.poDate),
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
}
