import 'package:abacux/model/Product_model.dart';
import 'package:abacux/screens/products/product/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductItems extends StatefulWidget {
  final Product ProductDetail;

  ProductItems(this.ProductDetail);

  @override
  _ProductItemsState createState() => _ProductItemsState();
}

class _ProductItemsState extends State<ProductItems> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(
              new MaterialPageRoute(
                builder: (context) => new ProductDetailScreen(
                  productDetails: widget.ProductDetail,
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
                    widget.ProductDetail.productName,
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
