import 'package:fixme/Screens/Chat/callscreens/listen_incoming_call.dart';
import 'package:fixme/Screens/Wallet/Wallet.dart';
import 'package:fixme/Screens/pending/pendingpage.dart';
import 'package:fixme/Screens/postrequest/postrequest.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Screens/Home/Home.dart';
import 'package:fixme/Screens/Notification/Notification.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _myPage;
  var search;
  final scafold_key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Provider.of<LocationService>(context, listen: false).getCurrentLocation();
    _myPage =
        PageController(initialPage: 0, viewportFraction: 1, keepPage: true);
  }

  @override
  void dispose() {
    _myPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
    var datas = Provider.of<WebServices>(context);
    // FirebaseApi.updateUsertoOnline(datas.mobile_device_token);
    var widget = Scaffold(
      key: scafold_key,
      drawer: SizedBox(
        width: 240,
        child: Drawer(
          child: DrawerWidget(context),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
            ),
          ],
        ),
        height: 60,
        child: BottomAppBar(
          elevation: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    _myPage.jumpToPage(0);
                    data.setSelectedBottomNavBar(0);
                  },
                  child: Tab(
                      child: Text('Home',
                          style: TextStyle(
                              color: data.selectedPage == 0
                                  ? Color(0xFFA40C85)
                                  : Color(0xFF555555))),
                      icon: Icon(
                        Icons.home,
                        color: data.selectedPage == 0
                            ? Color(0xFFA40C85)
                            : Color(0xFF555555),
                      ))),
              InkWell(
                  onTap: () {
                    _myPage.jumpToPage(1);
                    data.setSelectedBottomNavBar(1);
                  },
                  child: Tab(
                      child: Text('Wallet',
                          style: TextStyle(
                              color: data.selectedPage == 1
                                  ? Color(0xFFA40C85)
                                  : Color(0xFF555555))),
                      icon: Icon(Icons.account_balance_wallet,
                          color: data.selectedPage == 1
                              ? Color(0xFFA40C85)
                              : Color(0xFF555555)))),
              InkWell(
                  onTap: () {
                    _myPage.jumpToPage(2);
                    data.setSelectedBottomNavBar(2);
                  },
                  child: Tab(
                      child: Text('Post',
                          style: TextStyle(
                              color: data.selectedPage == 2
                                  ? Color(0xFFA40C85)
                                  : Color(0xFF555555))),
                      icon: Icon(Icons.add_circle_outline,
                          color: data.selectedPage == 2
                              ? Color(0xFFA40C85)
                              : Color(0xFF555555)))),
              InkWell(
                  onTap: () {
                    _myPage.jumpToPage(3);
                    data.setSelectedBottomNavBar(3);
                  },
                  child: Tab(
                      child: Text('Notification',
                          style: TextStyle(
                              color: data.selectedPage == 3
                                  ? Color(0xFFA40C85)
                                  : Color(0xFF555555))),
                      icon: Icon(Icons.notifications_none,
                          color: data.selectedPage == 3
                              ? Color(0xFFA40C85)
                              : Color(0xFF555555)))),
              InkWell(
                  onTap: () {
                    _myPage.jumpToPage(4);
                    data.setSelectedBottomNavBar(4);
                  },
                  child: Tab(
                      child: Text('Pending',
                          style: TextStyle(
                              color: data.selectedPage == 4
                                  ? Color(0xFFA40C85)
                                  : Color(0xFF555555))),
                      icon: Icon(Icons.access_time,
                          color: data.selectedPage == 4
                              ? Color(0xFFA40C85)
                              : Color(0xFF555555)))),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _myPage,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Home(scafold_key, data),
          Wallet(),
          PostScreen(),
          NotificationPage(scafold_key),
          PendingScreen(),
        ],
      ),
    );

    return PickupLayout(scaffold: widget);
  }
}
