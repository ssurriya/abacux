import 'package:abacux/common/app_constant.dart';
import 'package:abacux/model/sales_invoice_list.dart';
import 'package:abacux/screens/sales_invoice/add_or_edit_sales_invoices_screen.dart';
import 'package:abacux/services/sales_invoice_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesInvoicesItem extends StatefulWidget {
  final SaleInvoiceList salesInvoicesList;

  SalesInvoicesItem(this.salesInvoicesList);

  @override
  _SalesInvoicesItemState createState() => _SalesInvoicesItemState();
}

class _SalesInvoicesItemState extends State<SalesInvoicesItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Map body = {
          "sales_id": widget.salesInvoicesList.salesId.toString(),
        };
        await SalesInvoiceService.getInstance()
            .getSalesInvoiceDetailsList(body)
            .then((value) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddOrEditSalesInvoicesScreen(
                    salesInvoiceDetails: value,
                  )));
        }).catchError((onError) {});
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
                      child: Row(
                        children: [
                          Text(
                            "#${widget.salesInvoicesList.invoiceNo}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            " ${widget.salesInvoicesList.customerName}",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        _dateFormat(widget.salesInvoicesList.invoiceDate),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, right: 8.0, bottom: 8.0),
                      child: Text(
                        'Rs 1000',
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: widget.salesInvoicesList.invoiceNo == "2"
                              ? Colors.red.withOpacity(0.7)
                              : Colors.green.withOpacity(0.7),
                        ),
                        child: Padding(
                          padding: widget.salesInvoicesList.invoiceNo == "2"
                              ? EdgeInsets.only(
                                  top: 1.0, bottom: 1.0, right: 6.0, left: 6.0)
                              : EdgeInsets.only(
                                  top: 1.0,
                                  bottom: 1.0,
                                  right: 15.0,
                                  left: 15.0),
                          child: Text(
                            widget.salesInvoicesList.invoiceNo == "2"
                                ? "Unpaid"
                                : "Paid",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    )
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
}
