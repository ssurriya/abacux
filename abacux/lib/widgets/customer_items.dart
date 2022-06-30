import 'package:abacux/model/customer_model.dart';
import 'package:abacux/screens/customer/customer_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerItems extends StatefulWidget {
  final Customer customerDetail;

  CustomerItems(this.customerDetail);

  @override
  _CustomerItemsState createState() => _CustomerItemsState();
}

class _CustomerItemsState extends State<CustomerItems> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   width: MediaQuery.of(context).size.width,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
        //     child: Text(widget.customerDetail['Name'][0],
        //         style: GoogleFonts.publicSans(
        //             fontSize: 16, fontWeight: FontWeight.w600)),
        //   ),
        // ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(
              new MaterialPageRoute(
                settings: const RouteSettings(name: '/customer_edit'),
                builder: (context) => new CustomerDetailScreen(
                  customerDetails: widget.customerDetail,
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
                    widget.customerDetail.customerName,
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
}
