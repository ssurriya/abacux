import 'package:abacux/helper/custom_string_helper.dart';
import 'package:abacux/model/estimate_model.dart';
import 'package:abacux/screens/estimate/add_or_edit_estimates_screen.dart';
import 'package:abacux/services/estimate_service.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EstimatesItem extends StatefulWidget {
  final Estimate estimatesList;
  final int userId, companyId;
  final String token;

  EstimatesItem(this.estimatesList, this.userId, this.companyId, this.token);

  @override
  _EstimatesITemState createState() => _EstimatesITemState();
}

class _EstimatesITemState extends State<EstimatesItem> {
  _showFlushBar(String message) {
    Flushbar(
      icon: Icon(
        Icons.error_outline_outlined,
        size: 28.0,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(8),
      duration: Duration(seconds: 5),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.red,
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    )..show(context);
  }

  // Date Format
  String _dateFormat(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await EstimateService.getInstance().deleteAllEstimateProduct();
        await EstimateService.getInstance()
            .deleteAllEstimateAdditionalCharges();
        await EstimateService.getInstance().setCustomer(null);
        await EstimateService.getInstance().setDateTime(null);
        await EstimateService.getInstance().setEstimateEditUsingId(null);
        await EstimateService.getInstance().setDiscountInAmt(null);
        await EstimateService.getInstance().setDiscountInPercentage(null);

        Map body = {
          'user_id': widget.userId.toString(),
          'token': widget.token.toString(),
          'company_id': widget.companyId.toString(),
          'id': widget.estimatesList.id.toString()
        };
        await EstimateService.getInstance()
            .getEstimateListUsingId(body)
            .then((value) {
          print(value);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddOrEditEstimatesScreen(
                      estimateEditUsingId: value,
                    )),
          );
        }).catchError((onError) {
          _showFlushBar("Try Again Later");
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
                        widget.estimatesList.customerName,
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.estimatesList.estimateNo,
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
                        "Rs ${CustomStringHelper().formattDoubleToString(double.parse(widget.estimatesList.grandTotal))}",
                        // 'Rs${widget.estimatesList.grandTotal}.00',
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        _dateFormat(widget.estimatesList.estimateDate),
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
