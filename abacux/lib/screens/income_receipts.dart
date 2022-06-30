import 'package:abacux/common/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

// import 'save_file_mobile.dart' if (dart.library.html) 'save_file_web.dart';

class IncomeReceiptsScreen extends StatefulWidget {
  const IncomeReceiptsScreen({Key key}) : super(key: key);

  @override
  _IncomeReceiptsScreenState createState() => _IncomeReceiptsScreenState();
}

class _IncomeReceiptsScreenState extends State<IncomeReceiptsScreen> {
  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();

  TextEditingController customerName = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController method = TextEditingController();
  TextEditingController ref = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController unappliedAmount = TextEditingController();
  TextEditingController messageOnStatement = TextEditingController();

  DateTime date = DateTime.now();

  TextStyle textStyle = TextStyle(color: Colors.black);
  TextStyle _textStyle = TextStyle(
      fontSize: 14.0,
      letterSpacing: 1.0,
      color: Colors.black.withOpacity(0.7),
      fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppConstant().appThemeColor,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Income Receipts",
              style: TextStyle(color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                _printScreen("1");
              },
              child: Text(
                "Save",
                style: TextStyle(color: AppConstant().appThemeColor),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.white,
                child: textField(customerName, "Customer",
                    icon: Icons.add_circle_outline),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectedDate(context);
                      },
                      child: textField(
                          startDate, DateFormat('dd/MM/yyyy').format(date),
                          icon: Icons.date_range),
                    ),
                    textField(method, 'Method', icon: Icons.arrow_drop_down),
                    textField(ref, 'Ref - 21 characters max'),
                    textField(amount, 'Amount'),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(TextEditingController controller, String hintText,
      {IconData icon}) {
    // ignore: unnecessary_statements

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        controller: controller,
        validator: (value) {
          if (value.isEmpty) {
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 14.0,
                letterSpacing: 1.0,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w600),
            fillColor: Color(0xFFEEEEFF),
            suffixIcon: Icon(
              icon,
              color: AppConstant().appThemeColor,
            )),
      ),
    );
  }

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date)
      setState(() {
        date = DateTime(picked.year, picked.month, picked.day, 23, 59);
      });
  }

  Future<void> share(String title) async {
    await FlutterShare.share(
      title: title,
      text: title,
    );
  }

  _printScreen(String salesId) async {
    // var url = Uri.parse("http://sp.abacux.io/salesinvoice_print/1");

    var url = Uri.parse("http://www.africau.edu/images/default/sample.pdf");
    http.Response responses = await http.get(url);
    var pdfData = responses.bodyBytes;
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }

//   Future<void> generateInvoice() async {
//     // Create a new PDF document.
//     final PdfDocument document = PdfDocument();
// // Add a PDF page and draw text.
//     final page = document.pages.add();

//     final page1 = document.pages.add();

//     final String invoiceNumber = 'Invoice Number: 2058557939\r\n\r\nDate:';

//     // ignore: leading_newlines_in_multiline_strings
//     const String address = '''Bill To: \r\n\r\nAbraham Swearegin,
//         \r\n\r\nUnited States, California, San Mateo,
//         \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136''';

//     const String address1 = '''Bill To: \r\n\r\nAbraham Swearegin,
//         \r\n\r\nUnited States, California, San Mateo,
//         \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136''';

//     page.graphics.drawString(
//         "$invoiceNumber\n $address \n $address1  $invoiceNumber\n $address \n ",
//         PdfStandardFont(PdfFontFamily.helvetica, 20));

//     page1.graphics.drawString("$invoiceNumber\n $address \n $address1 ",
//         PdfStandardFont(PdfFontFamily.helvetica, 20));

//     List<int> bytes = document.save();
//     document.dispose();

//     saveAndLaunchFile(bytes, 'Invoice.pdf');
//   }
}
