import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeItem extends StatelessWidget {
  final String image;
  final String title;
  final String path;

  HomeItem(this.image, this.title, this.path);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(path);
        Navigator.pushNamed(context, path);
      },
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.grey.withOpacity(0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                image == '' ? 'assets/images/SalesInvoice.svg' : image,
                height: 40,
                width: 40,
              ),
            ),
          ),
          Expanded(
            child: Text(
              // title,
              title.replaceAll(' ', '\n'),
              // style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
