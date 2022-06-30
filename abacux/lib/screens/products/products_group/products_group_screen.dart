import 'package:abacux/common/app_constant.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/product_groups_model.dart';
import 'package:abacux/services/product_group_service.dart';
import 'package:another_flushbar/flushbar.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_or_edit_product_group.dart';

class ProductsGroupScreen extends StatefulWidget {
  static const route = "/products_group_screen";
  const ProductsGroupScreen({Key key}) : super(key: key);

  @override
  State<ProductsGroupScreen> createState() => _ProductsGroupScreenState();
}

class _ProductsGroupScreenState extends State<ProductsGroupScreen> {
  final GlobalKey flushBarKey = GlobalKey();
  TextEditingController _searchQuery = TextEditingController();

  List<Productgroup> _productGroupDetails = [];

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
      Text("Products",
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
  // _getCustomerList() async {
  //   Map body = {
  //     'user_id': userId.toString(),
  //     'token': token.toString(),
  //     'company_id': companyId.toString(),
  //   };
  //   print("Customer User $body");
  //   await ProductService().ProductList(body).then((value) {
  //     _productDetails = value;
  //     setState(() {
  //       _isLoding = true;
  //     });
  //   });
  //   _sortByName();

  _getCustomerList() async {
    Map body = {
      "user_id": userId.toString(),
      "company_id": companyId.toString(),
      "token": token
    };
    print(body);
    await ProductGroupService.getInstance()
        .getProductGroups(body)
        .then((value) {
      setState(() {
        _productGroupDetails = value.productgroups;
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
    _productGroupDetails.sort((a, b) {
      return a.productGroupName == null
          ? 0
          : b.productGroupName == null
              ? 0
              : a.productGroupName
                  .toLowerCase()
                  .compareTo(b.productGroupName.toLowerCase());
    });
    _groupByAlphabet(_productGroupDetails);
  }

  _groupByAlphabet(List<Productgroup> _productDetails) {
    groupByAlphabet = groupBy(_productDetails, (Productgroup obj) {
      return obj.productGroupName[0];
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
            Navigator.pushReplacementNamed(
                context, AddOrEditProductGroup.route);
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

                      _productGroupDetails.length > 0
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
                                        return productGroupItem(e.value[index]);
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

  Widget productGroupItem(Productgroup productDetail) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(
              new MaterialPageRoute(
                builder: (context) => new AddOrEditProductGroup(
                  productGroup: productDetail,
                ),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20),
                  child: Text(
                    productDetail.productGroupName,
                    style: GoogleFonts.publicSans(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        )
      ],
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
                child: Text("Product Group",
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
                      hintText: "Search Product Group",
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
          "Product Group",
          style: new TextStyle(color: Colors.black),
        ),
      );
      _isSearching = false;
      _searchQuery.clear();
    });
  }

  _searchOperation(String searchText) {
    print(searchText);
    List<Productgroup> filteredCustomer = [];
    filteredCustomer = _productGroupDetails
        .where((element) => element.productGroupName
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
    _groupByAlphabet(filteredCustomer);
  }
}
