import 'package:another_flushbar/flushbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckConnectivity {
  static CheckConnectivity instance;

  CheckConnectivity._();

  static CheckConnectivity getInstance() {
    if (instance == null) {
      instance = new CheckConnectivity._();
    }
    return instance;
  }

  final GlobalKey flushBarKey = GlobalKey();
  bool _isModelShown = false;
  checkConnectivity(BuildContext context) async {
    var connectivityResult = Provider.of<ConnectivityResult>(context);

    if (connectivityResult == null) {
      return;
    }

    if (connectivityResult == ConnectivityResult.none) {
      await Future.delayed(Duration(milliseconds: 2000), () {
        // Do something
      });
      if (!_isModelShown) {
        _isModelShown = true;
        _showFlushBar(context, "Check your internet connection",
            Icons.signal_cellular_connected_no_internet_4_bar, Colors.black);
      }
    } else {
      if (_isModelShown) {
        _isModelShown = false;
        _dismissFlushBar();
      }
    }
  }

  _showFlushBar(
      BuildContext context, String message, IconData icon, Color color) {
    Flushbar(
      key: flushBarKey,
      icon: Icon(
        icon,
        size: 28.0,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(8),
      duration: Duration(seconds: 1000),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: color.withOpacity(0.7),
      messageText: Text(
        message,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
            letterSpacing: 0.5),
      ),
    )..show(context);
  }

  _dismissFlushBar() {
    (flushBarKey.currentWidget as Flushbar).dismiss();
  }
}
