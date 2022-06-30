import 'dart:convert';

import 'package:abacux/helper/custom_string_helper.dart';
import 'package:abacux/model/proforma_invoice_list_model.dart';
import 'package:abacux/screens/proforma_invoice/add_or_edit_proforma_invoices.dart';
import 'package:abacux/services/proforma_invoice_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: camel_case_types
class ProformaInvoicesItem extends StatefulWidget {
  final ProformaInvoiceList proformaInvoicesList;
  final int userId, companyId;
  final String token;

  ProformaInvoicesItem(
      {this.proformaInvoicesList, this.userId, this.companyId, this.token});

  @override
  _ProformaInvoicesItemState createState() => _ProformaInvoicesItemState();
}

// ignore: camel_case_types
class _ProformaInvoicesItemState extends State<ProformaInvoicesItem> {
  // Date Format
  String _dateFormat(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        ProformaInvoiceService.getInstance().deleteAllProductToLocal();
        ProformaInvoiceService.getInstance()
            .deleteAllProformaAdditionalChargesToLocal();
        ProformaInvoiceService.getInstance().setCustomer(null);
        ProformaInvoiceService.getInstance().setDateTime(null);
        ProformaInvoiceService.getInstance()
            .setProformaInvoiceEditUsingId(null);
        Map body = {
          "user_id": widget.userId.toString(),
          "id": widget.proformaInvoicesList.id.toString(),
          "company_id": widget.companyId.toString(),
          "token": widget.token.toString()
        };

        await ProformaInvoiceService.getInstance()
            .getProformaInvoiceEditUsingId(body)
            .then((value) {
          print(value);

          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddOrEditproformaInvoicesScreen(
                      proformaInvoice: value,
                    )),
          );
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
                        widget.proformaInvoicesList.customerName,
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.proformaInvoicesList.invoiceNo,
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, right: 8.0, bottom: 8.0),
                      child: Text(
                        'Rs ${CustomStringHelper().formattDoubleToString(double.parse(widget.proformaInvoicesList.grandTotal))}',
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        _dateFormat(widget.proformaInvoicesList.invoiceDate),
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
