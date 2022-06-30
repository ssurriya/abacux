import 'package:abacux/model/vendor_model.dart';
import 'package:abacux/screens/vendors/vendors_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorItems extends StatefulWidget {
  final Vendor vendorDetail;

  VendorItems(this.vendorDetail);

  @override
  _VendorItemsState createState() => _VendorItemsState();
}

class _VendorItemsState extends State<VendorItems> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(
              new MaterialPageRoute(
                builder: (context) => new VendorDetailsScreen(
                  VendorDetails: widget.vendorDetail,
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
                    widget.vendorDetail.vendor_name,
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
