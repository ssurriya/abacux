import 'package:abacux/common/app_constant.dart';
import 'package:abacux/model/Product_model.dart';
import 'package:abacux/screens/products/product/add_or_edit_product_screen.dart';
import 'package:abacux/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abacux/helper/storage_helper.dart';

class ProductDetailScreen extends StatefulWidget {
  Product productDetails;

  ProductDetailScreen({this.productDetails});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  int userId;
  int companyId;
  String token;
  TabController tabController;

  TextEditingController _productName = TextEditingController();
  TextEditingController _hsnCode = TextEditingController();
  TextEditingController _partNo = TextEditingController();
  TextEditingController _availableStock = TextEditingController();
  TextEditingController _productDescription = TextEditingController();

  void initState() {
    _getUserAndCompanyId();
    tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    super.initState();
  }

  _getUserAndCompanyId() async {
    await Storage().readInt("userId").then((value) {
      userId = value;
    });
    await Storage().readString("token").then((value) {
      token = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/product_list");
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/product_list');
              },
              child: Icon(
                Icons.arrow_back,
                color: AppConstant().appThemeColor,
              ),
            ),
          ),
          title: Text("Product",
              style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 0.2,
                  color: Colors.black,
                  fontWeight: FontWeight.w600)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 38.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(
                      builder: (context) => AddAndEditProductScreen(
                        productDetails: widget.productDetails,
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.edit,
                  color: AppConstant().appThemeColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext) => _buildPopupDialog(
                      context,
                      widget.productDetails.id.toString(),
                      userId.toString(),
                      token.toString(),
                    ),
                  );
                },
                child: Icon(
                  Icons.delete,
                  color: AppConstant().appThemeColor,
                ),
              ),
            )
          ],
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  // height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, left: 28.0),
                            child: Text(
                              '${widget.productDetails.productName}',
                              style: GoogleFonts.publicSans(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                left: 28.0,
                                right: 25.0,
                                bottom: 20.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.call,
                                          size: 25,
                                          color: AppConstant().appThemeColor,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 40.0),
                                          child: Icon(
                                            Icons.mail_outline,
                                            size: 25,
                                            color: AppConstant().appThemeColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 40.0),
                                          child: Icon(
                                            Icons.location_on,
                                            size: 25,
                                            color: AppConstant().appThemeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 130,
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Rs0.00",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "Open",
                                      style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1.0,
                                          color: AppConstant().appThemeColor),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Rs0.00",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "Overdue",
                                      style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1.0,
                                          color: AppConstant().appThemeColor),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                TabBar(
                    // indicatorPadding: EdgeInsets.all(10),
                    indicatorColor: AppConstant().appThemeColor,
                    labelStyle: TextStyle(fontSize: 22.0, color: Colors.black),
                    unselectedLabelStyle:
                        TextStyle(fontSize: 22, color: Colors.grey),
                    unselectedLabelColor: Colors.grey,
                    controller: tabController,
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "ACTIVITES",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "DETAILS",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ]),
                new Container(
                  height: 900,
                  child: new TabBarView(
                    controller: tabController,
                    children: <Widget>[
                      new Card(),
                      new Card(
                        child: Column(
                          children: [
                            _textField(_productName, "Product Name   ",
                                widget.productDetails.productName.toString()),
                            _textField(
                                _productDescription,
                                "Description         ",
                                widget.productDetails.productDescription
                                    .toString()),
                            _textField(_hsnCode, "HSN Code           ",
                                widget.productDetails.hsnCode.toString()),
                            _textField(_partNo, "Part No                ",
                                widget.productDetails.partNo.toString()),
                            _textField(_availableStock, "Available Stock  ",
                                widget.productDetails.avilableStock.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupDialog(
    BuildContext context,
    String id,
    String user_id,
    String token,
  ) {
    return AlertDialog(
      title: const Text('Are you sure you want to delete?'),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            textColor: Theme.of(context).primaryColor,
            child: Text('Cancel')),
        FlatButton(
          onPressed: () {
            ProductService.getInstance()
                .deleteProduct(
              id.toString(),
              user_id.toString(),
              token.toString(),
            )
                .then((value) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/product_list', (Route<dynamic> route) => false);
            });
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _textField(
      TextEditingController controller, String label, String hint) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 28),
        child: Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 28.0, top: 8, bottom: 8.0),
          child: Container(
            child: new TextField(
              textAlign: TextAlign.start,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 16,
                  )),
            ),
          ),
        ),
      ),
    ]);
  }
}
