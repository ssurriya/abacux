import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/screens/sales_receipt/sales_receipt_screen.dart';
import 'package:abacux/widgets/home_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'estimate_settings/estimate_settings_screen.dart';

import 'master/Invoice_groups/invoice_groups_screen.dart';
import 'master/additional_charges/additionalCharges_screen.dart';
import 'master/financial_year/financial_year_screen.dart';
import 'master/payment_attributes/payment_attributes_screen.dart';
import 'master/payment_modes/paymentMode_screen.dart';
import 'master/product_attribute/product_attribute_screen.dart';
import 'master/product_uoms/productUoms_screen.dart';
import 'master/referral/refferal_screen.dart';
import 'master/tax/tax_screen.dart';
import 'master/tax_class_tax/taxclasses_screen.dart';
import 'master/tax_classes/taxclasses_screen.dart';
import 'products/products_group/products_group_screen.dart';
import 'purchase_payments/purchase_payment_screen.dart';
import 'quotations_settings/quotation_setting_screen.dart';

import 'sales_invoice_settings/sale_invoice_settings_screen.dart';

import 'warehouse/warehousebins/ware_house_bin_screen.dart';
import 'warehouse/warehouses/warehouse_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<dynamic>> _dashboardItems = {
    "Customers": [
      {
        'image': 'assets/images/Estimates1.svg',
        'title': 'Estimates',
        'subTitle': '',
        'path': '/estimates'
      },
      {
        'image': 'assets/images/ProformaInvoices.svg',
        'title': 'Proforma Invoices',
        'subTitle': '',
        'path': '/proforma_invoices_screen'
      },
      {
        'image': 'assets/images/SalesInvoice.svg',
        'title': 'Sales Invoices',
        'subTitle': '',
        'path': '/sales_invoices_screen'
      },
      {
        'image': 'assets/images/SalesReceipts.svg',
        'title': 'Sales Receipts',
        'subTitle': '',
        'path': SalesReceiptListScreen.route
      },
      {
        'image': 'assets/images/Credits.svg',
        'title': 'Credit Note',
        'subTitle': '',
        'path': '/credit_note_screen'
      },
      {
        'image': 'assets/images/NewCustomers.svg',
        'title': 'Customers',
        'subTitle': '',
        'path': '/new_customer'
      },
    ],
    "Purchase": [
      {
        'image': 'assets/images/PurchaseOrders.svg',
        'title': 'Purchase Order',
        'subTitle': '',
        'path': '/purchase_order_screen'
      },
      {
        'image': '',
        'title': 'Purchase Bill',
        'subTitle': '',
        'path': '/purchase_bill_screen'
      },
      {
        'image': '',
        'title': 'Purchase Payments',
        'subTitle': '',
        'path': PurchasePaymentScreen.route
      },
      {
        'image': '',
        'title': 'Debit Note',
        'subTitle': '',
        'path': '/debit_note_screen'
      },
      {'image': '', 'title': 'Vendors', 'subTitle': '', 'path': '/new_vendors'},
    ],
    "Products": [
      {
        'image': '',
        'title': 'Products',
        'subTitle': '',
        'path': '/product_list'
      },
      {
        'image': '',
        'title': 'Products Group',
        'subTitle': '',
        'path': ProductsGroupScreen.route
      },
    ],
    "Warehouse": [
      {
        'image': '',
        'title': 'Ware Houses',
        'subTitle': '',
        'path': WarehousesScreen.route
      },
      {
        'image': '',
        'title': 'Ware Houses Bin',
        'subTitle': '',
        'path': WarehousesBinScreen.route
      },
    ],
    "Masters": [
      {
        'image': '',
        'title': 'Financial Year',
        'subTitle': '',
        'path': FinancialYearScreen.route
      },
      {
        'image': '',
        'title': 'Product Attributes',
        'subTitle': '',
        'path': ProductAttributeScreen.route
      },
      {
        'image': '',
        'title': 'Product Uoms',
        'subTitle': '',
        'path': ProductUomsScreen.route
      },
      {
        'image': '',
        'title': 'Tax Classes',
        'subTitle': '',
        'path': TaxClassesScreen.route
      },
      {'image': '', 'title': 'Tax', 'subTitle': '', 'path': TaxScreen.route},
      {
        'image': '',
        'title': 'Tax Class Tax',
        'subTitle': '',
        'path': TaxClassTaxScreen.route
      },
      {
        'image': '',
        'title': 'Payment Modes',
        'subTitle': '',
        'path': PaymentModeScreen.route
      },
      {
        'image': '',
        'title': 'Payment Attributes',
        'subTitle': '',
        'path': PaymentAttributesScreen.route
      },
      {
        'image': '',
        'title': 'Referral',
        'subTitle': '',
        'path': RefferalScreen.route
      },
      {
        'image': '',
        'title': 'Additional Charges',
        'subTitle': '',
        'path': AdditionalChargeScreen.route
      },
      {
        'image': '',
        'title': 'Invoice Groups',
        'subTitle': '',
        'path': InvoiceGroupScreen.route
      },
    ],
    "Settings": [
      {
        'image': 'assets/images/PurchaseOrders.svg',
        'title': 'Estimate',
        'subTitle': '',
        'path': EstimatesSettingsScreen.route
      },
      {
        'image': '',
        'title': 'Quotations',
        'subTitle': '',
        'path': QuotationSettingsScreen.route
      },
      {
        'image': '',
        'title': 'Sale Invoice',
        'subTitle': '',
        'path': SaleInvoiceSettingsScreen.route
      },
    ],
    "Accounts": [
      {
        'image': '',
        'title': 'Income Receipts',
        'subTitle': '',
        'path': '/income_receipts'
      },
      {'image': '', 'title': 'Expense Receipts', 'subTitle': '', 'path': ''},
    ],
    "Reports": [
      {'image': '', 'title': 'In Stocks', 'subTitle': '', 'path': ''},
      {'image': '', 'title': 'Less Stocks', 'subTitle': '', 'path': ''},
      // {'image': '', 'title': 'Dead Stocks', 'subTitle': '', 'path': ''},
      // {'image': '', 'title': 'Stock Transfer', 'subTitle': '', 'path': ''},
    ],
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check Internet Connection
    CheckConnectivity.getInstance().checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            CarouselSlider(
              items: [
                Container(
                  margin: EdgeInsets.all(6.0),
                  width: MediaQuery.of(context).size.width * 0.90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.orange[900].withOpacity(0.74),
                    // color: AppConstant().appThemeColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 8.0, left: 18),
                        child: Text(
                          'Organisation',
                          style: TextStyle(
                              fontSize: 28,
                              letterSpacing: 1,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text(
                          'This is your main tab where you\nwill access all of your business\nand accounting functions.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: 0.8),
                        ),
                      )
                    ],
                  ),
                ),
              ],

              //Slider Container properties
              options: CarouselOptions(
                height: 190.0,
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 2000),
                viewportFraction: 1,
              ),
            ),
            Column(
                children: _dashboardItems.entries.map((e) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Container(decoration: ,),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14.0, left: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.key,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                              'Run your business with a variety of functional apps',
                              style: TextStyle(
                                color: Colors.grey,
                                // fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,

                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10.0),
                    //     border: Border.all(color: Colors.grey, width: 0.3)),
                    child: GridView.builder(
                        padding: EdgeInsets.all(3.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 20.0,
                            // mainAxisSpacing: 15,

                            childAspectRatio: 0.65),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: e.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return HomeItem(e.value[index]['image'],
                              e.value[index]['title'], e.value[index]['path']);
                        }),
                  ),
                ],
              );
            }).toList()),
          ],
        ),
      ),
    );
  }
}
