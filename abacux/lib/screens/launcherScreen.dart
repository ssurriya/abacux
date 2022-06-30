import 'dart:io';
import 'dart:ui';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/model/login_model.dart';
import 'package:abacux/services/permission_service.dart';
import 'package:abacux/services/user_and_company_role_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({Key key}) : super(key: key);

  @override
  _LauncherScreenState createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  List<CompanyRole> companyRoles = [];

  CompanyRole selectedCompanyRole = CompanyRole();

  void initState() {
    super.initState();
    _getCompanyRoles();
  }

  // Get List of company role from the local db
  _getCompanyRoles() async {
    await UserAndCompanyRoleService().getCompanyRoles().then((value) {
      print(value);
      setState(() {
        companyRoles = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
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

              // Application Icon
              // Padding(
              //   padding: const EdgeInsets.only(top: 75.0, left: 24.0),
              //   child: CircleAvatar(
              //     radius: 20,
              //     backgroundColor: Color(0xFF2222ff),
              //     child: Image.asset('assets/images/AbacuxOnlyWhiteSymbol.png'),
              //   ),
              // ),

              // Text Fields
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 70.0, bottom: 10.0, left: 10.0, right: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showExitPopup();
                                },
                                child: Icon(Icons.arrow_back),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 45.0,
                          ),
                          Column(
                            children: [
                              Text(
                                "Select Your Company",
                                style: GoogleFonts.openSans(
                                    fontSize: 22, fontWeight: FontWeight.w600),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Please Select your company below",
                                  style: GoogleFonts.openSans(
                                      fontSize: 16, color: Color(0xFF8083A3)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _getPermission();
                        },
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: companyRoles.length,
                          itemBuilder: (context, index) {
                            var data = companyRoles[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                elevation: 2.0,
                                child: Container(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      data.companyName,
                                      style: GoogleFonts.openSans(
                                          color: Colors.grey[700],
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 40.0),
                      //   child: Container(
                      //     width: MediaQuery.of(context).size.width - 40,
                      //     margin: EdgeInsets.only(top: 10, bottom: 10),
                      //     child: DropdownSearch<CompanyRole>(
                      //       dropdownSearchDecoration: InputDecoration(
                      //         errorStyle: TextStyle(fontSize: 15.0),
                      //         enabledBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //             color: Color(0xFFd3d2d2),
                      //           ),
                      //           borderRadius: BorderRadius.circular(15),
                      //         ),
                      //         focusedBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(15),
                      //           borderSide: BorderSide(
                      //             color: Color(0XFF5050C7),
                      //           ),
                      //         ),
                      //         filled: true,
                      //         fillColor: Color(0xFFFFFF),
                      //         contentPadding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                      //       ),
                      //       onChanged: (CompanyRole value) {
                      //         setState(() {
                      //           selectedCompanyRole = value;
                      //         });
                      //       },
                      //       mode: Mode.MENU,
                      //       itemAsString: (CompanyRole companyRole) =>
                      //           companyRole.companyName,
                      //       items: companyRoles,
                      //       label: ("Select Your Company"),
                      //       showSearchBox: true,
                      //       validator: (text) {
                      //         if (text == null || text.companyName.isEmpty) {
                      //           return 'Company is not empty';
                      //         }
                      //         return null;
                      //       },
                      //       searchBoxDecoration: InputDecoration(
                      //         border: OutlineInputBorder(),
                      //         contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                      //         // labelText: "Employee Name",
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // GestureDetector(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 40.0),
                      //     child: Container(
                      //       width: MediaQuery.of(context).size.width - 40,
                      //       // margin: EdgeInsets.only(top: 10, bottom: 10),
                      //       decoration: BoxDecoration(
                      //         color: Color(0xFF2222FF),
                      //         borderRadius: BorderRadius.circular(15),
                      //       ),
                      //       child: Center(
                      //         child: Padding(
                      //           padding: const EdgeInsets.symmetric(vertical: 14),
                      //           child: Text(
                      //             'Ok',
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 18,
                      //                 fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     _getPermission();
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getPermission() async {
    String token = await Storage().readString("token");
    int userId = await Storage().readInt("userId");

    Map body = {
      "user_id": userId.toString(),
      "company_id": selectedCompanyRole.companyId.toString(),
      "token": token
    };

    print(body);

    await PermissionService().getPermission(body).then((value) async {
      await Storage()
          .saveInt("selectedCompanyId", int.parse(value.companyAuthId));
      await Storage().saveStringList("permission", value.permissions);
      Navigator.pushReplacementNamed(context, '/dashboard');
    }).catchError((onError) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF393939)),
                ),
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  _logout();
                },
                //Navigator.of(context).pop(true),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF393939)),
                ),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  void _logout() {
    // Storage().saveString("token", "");
    // Storage().saveString('authorization', "");
    Storage().deleteString("token");
    Storage().deleteString("authorization");
    Storage().deleteString("userId");
    Storage().deleteString("selectedCompanyId");
    Storage().deleteString("permission");

    UserAndCompanyRoleService().deleteUserRole();
    UserAndCompanyRoleService().deleteCompanyRole();
    exit(0);
  }
}
