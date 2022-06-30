import 'package:abacux/common/app_constant.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/vendor_model.dart';
import 'package:abacux/services/vendor_service.dart';
import 'package:abacux/widgets/vendor_items.dart';
import 'package:another_flushbar/flushbar.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorScreen extends StatefulWidget {
  const VendorScreen({Key key}) : super(key: key);

  @override
  _VendorScreenState createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  final GlobalKey flushBarKey = GlobalKey();
  TextEditingController _searchQuery = TextEditingController();

  List<Vendor> _vendorDetails = [];

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
      Text("Vendors",
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
    _getCustomerList();
  }

  // Get Customer Listing
  _getCustomerList() async {
    Map body = {
      'user_id': userId.toString(),
      'token': token.toString(),
      'company_id': companyId.toString(),
    };
    print("Customer User $body");
    await VendorService().vendorList(body).then((value) {
      _vendorDetails = value;
      setState(() {
        _isLoading = true;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = true;
      });
      _showFlushBar(
          context, "Error Occur Try Again Later", Icons.error, Colors.red);
    });
    _sortByName();
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
    _vendorDetails.sort((a, b) {
      print("${a.vendor_name}:${b.vendor_name}");
      return a.vendor_name == null
          ? 0
          : b.vendor_name == null
              ? 0
              : a.vendor_name
                  .toLowerCase()
                  .compareTo(b.vendor_name.toLowerCase());
    });
    _groupByAlphabet(_vendorDetails);
  }

  _groupByAlphabet(List<Vendor> _vendorDetails) {
    groupByAlphabet = groupBy(_vendorDetails, (Vendor obj) {
      return obj.vendor_name[0];
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
        appBar: buildBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/add_vendor');
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

                      _vendorDetails.length > 0
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
                                      // physics: NeverScrollableScrollPhysics(),
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
                                        return VendorItems(e.value[index]);
                                      },
                                    )
                                  ],
                                );
                              }).toList(),
                            )
                          : (Center(
                              child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 150,
                                  left: 110.0,
                                  right: 120,
                                  bottom: 300),
                              child: Text("No data Found !"),
                            ))),
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
                child: Text("Vendors",
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
                      hintText: "Search customers",
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
          "Customers",
          style: new TextStyle(color: Colors.black),
        ),
      );
      _isSearching = false;
      _searchQuery.clear();
    });
  }

  _searchOperation(String searchText) {
    print(searchText);
    List<Vendor> filteredCustomer = [];
    filteredCustomer = _vendorDetails
        .where((element) => element.vendor_name
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
    _groupByAlphabet(filteredCustomer);
  }
}
