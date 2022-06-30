import 'package:abacux/common/app_constant.dart';
import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/estimate_model.dart';
import 'package:abacux/services/estimate_service.dart';
import 'package:abacux/widgets/estimates_item.dart';
import 'package:another_flushbar/flushbar.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EstimatesScreen extends StatefulWidget {
  const EstimatesScreen({Key key}) : super(key: key);

  @override
  _EstimatesScreenState createState() => _EstimatesScreenState();
}

class _EstimatesScreenState extends State<EstimatesScreen> {
  final GlobalKey flushBarKey = GlobalKey();
  TextEditingController _searchQuery = TextEditingController();

  List<Estimate> _estimateDetails = [];

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
      Text("Estimates",
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
    await EstimateService.getInstance().estimateList(body).then((value) {
      _estimateDetails = value;
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
    _estimateDetails.sort((a, b) {
      print("${a.customerName}:${b.customerName}");
      return a.customerName == null
          ? 0
          : b.customerName == null
              ? 0
              : a.customerName
                  .toLowerCase()
                  .compareTo(b.customerName.toLowerCase());
    });
    _groupByAlphabet(_estimateDetails);
  }

  _groupByAlphabet(List<Estimate> _estimateDetails) {
    groupByAlphabet = groupBy(_estimateDetails, (Estimate obj) {
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
        appBar: buildBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await EstimateService.getInstance().deleteAllEstimateProduct();
            await EstimateService.getInstance()
                .deleteAllEstimateAdditionalCharges();
            await EstimateService.getInstance().setCustomer(null);
            await EstimateService.getInstance().setDateTime(null);
            await EstimateService.getInstance().setEstimateEditUsingId(null);
            await EstimateService.getInstance().setAdditionalChargeId(null);
            await EstimateService.getInstance().setDiscountInAmt(null);
            await EstimateService.getInstance().setDiscountInPercentage(null);
            Navigator.pushReplacementNamed(context, '/add_estimate_screen');
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

                      _estimateDetails.length > 0
                          ? groupByAlphabet.isNotEmpty
                              ? Column(
                                  children: groupByAlphabet.entries.map((e) {
                                    print(e);
                                    return Column(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14.0, horizontal: 20),
                                            child: Text(e.key,
                                                style: GoogleFonts.publicSans(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ),
                                        ListView.separated(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          separatorBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: Divider(
                                                height: 1.5,
                                              ),
                                            );
                                          },
                                          shrinkWrap: true,
                                          itemCount: e.value.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return EstimatesItem(e.value[index],
                                                userId, companyId, token);
                                          },
                                        )
                                      ],
                                    );
                                  }).toList(),
                                )
                              : Center(
                                  child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 150,
                                      left: 110.0,
                                      right: 120,
                                      bottom: 550),
                                  child: Text("Search Not Found !"),
                                  // child: Image.asset(
                                  //   "assets/images/searchNotFound.png",
                                  //   height: 70,
                                  // ),
                                ))
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
                child: Text("Estimates",
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
          "Customers",
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
    List<Estimate> filteredCustomer = [];
    filteredCustomer = _estimateDetails
        .where((element) => element.customerName
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
    _groupByAlphabet(filteredCustomer);
  }
}
