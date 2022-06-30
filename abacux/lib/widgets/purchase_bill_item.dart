import 'package:abacux/screens/purchase_bill/add_or_edit_purchase_bill_screen.dart';
import 'package:flutter/material.dart';

class PurchaseBillItem extends StatefulWidget {
  final dynamic purchaseBillList;

  PurchaseBillItem(this.purchaseBillList);

  @override
  _PurchaseBillItemState createState() => _PurchaseBillItemState();
}

class _PurchaseBillItemState extends State<PurchaseBillItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddOrEditPurchaseBillScreen(
                // purchaseBill: widget.purchaseBillList,
                )));
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
                        widget.purchaseBillList['name'],
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.purchaseBillList['estimateNo'],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, right: 8.0, bottom: 8.0),
                      child: Text(
                        'Rs${widget.purchaseBillList['amount']}.00',
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        widget.purchaseBillList['date'],
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
