import 'dart:convert';
import 'dart:io';

import 'dart:ui';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/login_model.dart';
import 'package:abacux/services/account_service.dart';
import 'package:abacux/services/permission_service.dart';
import 'package:abacux/services/user_and_company_role_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unique_identifier/unique_identifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  String identifier1;
  String message;
  bool _isEmailError = false;
  bool _isPasswordError = false;
  bool _isPageLoading = false;
  int companyCount = 0;
  int companyId; // If single company id only available
  @override
  void initState() {
    check_internet();
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
            // Background Image
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Container(
                child: Image.asset(
                  'assets/images/launcherScreenBackground.png',
                  // height: 100,
                ),
              ),
            ),

            //Application Icon
            Padding(
              padding: const EdgeInsets.only(top: 75.0, left: 24.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF2222ff),
                child: Image.asset('assets/images/AbacuxOnlyWhiteSymbol.png'),
              ),
            ),

            // Sign Up button
            Padding(
              padding: EdgeInsets.only(top: 76.0, left: width / 1.4),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 11.0, horizontal: 20),
                  child: Text(
                    "Sign Up",
                    style: GoogleFonts.openSans(
                        fontSize: 14, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),

            // Text Fields
            Padding(
              padding: const EdgeInsets.only(top: 210.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        "Sign in",
                        style: GoogleFonts.openSans(
                            fontSize: 38, fontWeight: FontWeight.w900),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Enter your details to proceed further",
                          style: GoogleFonts.openSans(
                              fontSize: 16, color: Color(0xFF8083A3)),
                        ),
                      ),
                    ],
                  ),

                  //Text Fields
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, right: 25, top: 38),
                    child: Column(
                      children: [
                        _textField("Email", _email, Icons.email_outlined,
                            _isEmailError),
                        Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: _textField("Password", _password,
                                Icons.lock_outline, _isPasswordError)),
                      ],
                    ),
                  ),

                  // Remember me
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0, left: 30),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Color(0xFF2222FF), width: 5)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text("Remember me",
                              style: GoogleFonts.openSans(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),

                  //Sign in button
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 32,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (_email.text != "" && _password.text != "") {
                          setState(() {
                            check_internet();
                            _isEmailError = false;
                            _isPasswordError = false;
                          });
                          _onLogin();
                        } else {
                          setState(() {
                            if (_email.text == "") {
                              _isEmailError = true;
                            } else {
                              _isEmailError = false;
                              _isPasswordError = true;
                            }
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF2222FF),
                          borderRadius: BorderRadius.circular(40),
                        ),

                        //---- Consumer -----
                        child:
                            //Shown Text
                            Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: height / 50, horizontal: width / 2.5),
                          child: _isPageLoading
                              ? Center(
                                  widthFactor: 1.2,
                                  heightFactor: 0.5,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                  ),

                  // Text - Or
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 65.0, top: 50, right: 55),
                    child: Row(
                      children: [
                        _horizontalDivider(),
                        Text(
                          "Or",
                          style: GoogleFonts.openSans(
                              fontSize: 14, color: Color(0xFF8083A3)),
                        ),
                        _horizontalDivider(),
                      ],
                    ),
                  ),

                  // Sign up with Google
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 38.0, left: 30, right: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.4),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 14.0),
                              child: SvgPicture.asset(
                                'assets/images/google.svg',
                                height: 16,
                                width: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 75.0),
                              child: Text(
                                "Sign Up with Google",
                                style: GoogleFonts.openSans(
                                    fontSize: 12, fontWeight: FontWeight.w900),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _horizontalDivider() {
    return Expanded(
      child: new Container(
          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
          child: Divider(
            color: Colors.grey,
            height: 36,
          )),
    );
  }

  Widget _textField(String labelText, TextEditingController controller,
      IconData icon, bool isError) {
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: new Border.all(
          color: isError ? Colors.red : Colors.grey,
          width: isError ? 0.8 : 0.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: new TextField(
          controller: controller,
          style:
              GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w900),
          obscureText: labelText == 'Password' ? true : false,
          textAlign: TextAlign.start,
          decoration: new InputDecoration(
            labelText: labelText,
            labelStyle: GoogleFonts.openSans(
                fontSize: 12,
                color: Color(0xFF8083A3),
                fontWeight: FontWeight.w900),
            suffixIcon: Icon(
              icon,
              color: Colors.black,
              size: 18,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Future<void> _onLogin() async {
    Map body = {
      "email": _email.text,
      "password": _password.text,
    };
    setState(() {
      _isPageLoading = true;
    });
    await AccountService().login(body).then((value) async {
      setState(() {
        _isPageLoading = false;
      });

      if (value.status == "200") {
        var authorization =
            base64Encode(utf8.encode('${_email.text}:${_password.text}'));

        print(value.token);
        await Storage().saveString("token", value.token);
        await Storage().saveString('authorization', authorization);
        await _insertUserRoleValue(value.userRoles);
        await _insertCompanyRoleValue(value.companyRoles);
        _navigate();
      }
    }).catchError((onError) {
      setState(() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Incorrect Email or password Please Try Again..!"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        _isPageLoading = false;
      });
    });
  }

  _insertCompanyRoleValue(List<CompanyRole> companyRoles) {
    companyCount = 0;
    companyRoles.map((e) async {
      companyCount += 1;
      companyId = e.companyId;
      await UserAndCompanyRoleService().insertCompanyRole(e).then((value) {
        print(value);
      });
    }).toList();
  }

  _insertUserRoleValue(List<UserRole> userRoles) {
    userRoles.map((e) async {
      await Storage().saveInt("userId", e.userId);
      await UserAndCompanyRoleService().insertUserRole(e).then((value) {
        print(value);
      });
    }).toList();
  }

  _navigate() {
    if (companyCount == 1) {
      _getPermission(companyId);
    } else {
      Navigator.pushReplacementNamed(context, '/launcherScreen');
    }
  }

  _getPermission(int companyId) async {
    String token = await Storage().readString("token");
    int userId = await Storage().readInt("userId");

    Map body = {
      "user_id": userId.toString(),
      "company_id": companyId.toString(),
      "token": token
    };

    print(body);

    await PermissionService().getPermission(body).then((value) async {
      await Storage()
          .saveInt("selectedCompanyId", int.parse(value.companyAuthId));
      await Storage().saveStringList("permission", value.permissions);
      Navigator.pushReplacementNamed(context, '/dashboard');
    }).catchError((onError) {
      // Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  check_internet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('not connected');
        var identifier = await UniqueIdentifier.serial;
        setState(() {
          identifier1 = identifier;
        });
        print(identifier);
        print("identifier");
      }
    } on SocketException catch (_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Connect Your Internet"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
