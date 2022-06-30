import 'package:abacux/common/check_connectivity.dart';
import 'package:abacux/helper/storage_helper.dart';
import 'package:abacux/screens/home_screen.dart';
import 'package:abacux/services/account_service.dart';
import 'package:abacux/services/user_and_company_role_service.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardScreem extends StatefulWidget {
  const DashboardScreem({Key key}) : super(key: key);

  @override
  _DashboardScreemState createState() => _DashboardScreemState();
}

class _DashboardScreemState extends State<DashboardScreem> {
  final GlobalKey flushBarKey = GlobalKey();
  DateTime currentBackPressTime;
  List _bottomNavigationBars = [
    {
      'icon': Icons.mobile_off_outlined,
    },
    {
      'icon': Icons.card_giftcard,
    },
    {
      'icon': Icons.list_alt_outlined,
    },
    {
      'icon': Icons.swap_calls_outlined,
    },
    {
      'icon': Icons.supervised_user_circle_outlined,
    }
  ];

  List _paths = [
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    HomeScreen()
  ];

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check Internet Connection
    CheckConnectivity.getInstance().checkConnectivity(context);
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
      duration: Duration(seconds: 6),
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

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 6)) {
      currentBackPressTime = now;
      _showFlushBar(context, "Press back again to exit ?",
          Icons.exit_to_app_outlined, Colors.black.withOpacity(0.7));
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: _bottomNavigationBars.map((e) {
            return BottomNavigationBarItem(
              icon: Icon(e['icon'], color: Colors.black),
              backgroundColor: Colors.white,
              label: '',
            );
          }).toList(),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 115.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/AbacuxOnlyBlueSymbol.png',
                          width: 38,
                          height: 38,
                        ),
                        Text(
                          "AbacuX",
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 1.5,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showExitPopup();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.grey, width: 0.9)),
                        child: Image.asset(
                          'assets/images/userIcon1.png',
                          width: 39,
                          height: 39,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: _paths.elementAt(_selectedIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            //title: Text('Exit App'),
            content: Text('Are you sure want to Logout?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF393939)),
                ),
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await Storage().readInt("userId").then((value) async {
                    Map body = {
                      "id": value.toString(),
                    };
                    await AccountService().logout(body).then((value) {
                      _logout();
                    });
                  });
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
    Navigator.pushReplacementNamed(context, '/login');
  }
}
