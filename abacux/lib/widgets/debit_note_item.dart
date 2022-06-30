import 'package:abacux/screens/debit_notes/add_or_edit_debit_note_screen.dart';
import 'package:flutter/material.dart';

class DebitNoteItem extends StatefulWidget {
  final dynamic debitNoteLst;

  DebitNoteItem(this.debitNoteLst);

  @override
  _DebitNoteItemState createState() => _DebitNoteItemState();
}

class _DebitNoteItemState extends State<DebitNoteItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddOrEditDebitNoteScreen(
                  debitNote: widget.debitNoteLst,
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
                        widget.debitNoteLst['name'],
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.debitNoteLst['estimateNo'],
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
                        'Rs${widget.debitNoteLst['amount']}.00',
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        widget.debitNoteLst['date'],
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
