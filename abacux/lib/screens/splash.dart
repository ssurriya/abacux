import 'package:flutter/material.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'dart:async';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  List<dynamic> _lstcolors = [];
  String device1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    device_id();
    Timer(Duration(seconds: 2), () {
      Storage().readString('token').then((value) {
        value.isNotEmpty
            ? Navigator.pushReplacementNamed(context, '/dashboard')
            : Navigator.pushReplacementNamed(context, '/splash1');
      });
    });
  }

  void device_id() async {
    String device = await Storage().readString("device");
    setState(() {
      device1 = device;
    });
  }

  // void loadcolor() async {
  //   await SalesService.deviceId().then((_lstcolors) {
  //     setState(() {
  //       this._lstcolors = _lstcolors;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3243e3),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: Color(0xFF3243e3),
          elevation: 0,
          label: Container(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Image.asset(
                'assets/images/elroiwhite.png',
                height: 60,
              ),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo here
            Image.asset(
              'assets/images/whiteabacuxlogo.png',
              height: 60,
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFf4f5f7)),
            )
          ],
        ),
      ),
    );
  }
}
