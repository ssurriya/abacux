import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abacux/helper/storage_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Container(
                child: Image.asset(
                  'assets/images/launcherScreenBackground.png',
                  // height: 100,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width / 20, vertical: height / 10),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF2222ff),
                child: Image.asset('assets/images/AbacuxOnlyWhiteSymbol.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height / 9),
              child: Container(
                  child: Image.asset('assets/images/launcherScreenImage.png')),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: height / 1.84),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Let's get started.",
                      style: _textStyle1(),
                    ),
                    Text(
                      "You've missed!",
                      style: _textStyle1(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0, left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Enter your details to proceed further.",
                            style: _textStyle2(),
                          ),
                          Text(
                            "Money Back Guarantee get the item you",
                            style: _textStyle2(),
                          ),
                          Text(
                            "ordered or get your money back.",
                            style: _textStyle2(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height / 1.18, left: 45),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 80.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 12.0, bottom: 12.0, right: 65, left: 120.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEFF),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2222FF)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 12.0, bottom: 12.0, right: 60.0, left: 50.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF2222FF),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _textStyle1() {
    return GoogleFonts.openSans(fontSize: 38, fontWeight: FontWeight.w900);
  }

  _textStyle2() {
    return GoogleFonts.openSans(fontSize: 16, color: Color(0xFF8083A3));
  }
}
