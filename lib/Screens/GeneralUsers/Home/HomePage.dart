import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/callscreens/listen_incoming_call.dart';
import 'package:fixme/Screens/GeneralUsers/Notification/Notification.dart';
import 'package:fixme/Screens/GeneralUsers/Wallet/Wallet.dart';
import 'package:fixme/Screens/GeneralUsers/pending/pendingpage.dart';
import 'package:fixme/Screens/GeneralUsers/postrequest/postrequest.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';

class  HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _myPage;
  var search;
  final scafoldKey = GlobalKey<ScaffoldState>();
  String _message = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    Provider.of<WebServices>(context, listen: false).initializeValues();
    getMessage();
    var data = Provider.of<Utils>(context, listen: false);
    var network = Provider.of<WebServices>(context, listen: false);
    var datas = Provider.of<DataProvider>(context, listen: false);
    datas.setSelectedBottomNavBar(0);
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    network.updateFCMToken(network.userId, data.fcmToken);
    Provider.of<LocationService>(context, listen: false).getCurrentLocation();
    _myPage =
        PageController(initialPage: 0, viewportFraction: 1, keepPage: true);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PostRequestProvider postRequestProvider =
          Provider.of<PostRequestProvider>(context, listen: false);
      postRequestProvider.getAllServices();
    });
  }

  Future onSelectNotification(String payload) {
    var data = Provider.of<DataProvider>(context);
    _myPage.jumpToPage(3);
    data.setSelectedBottomNavBar(3);
  }





  void getMessage() {
    var network = Provider.of<WebServices>(context, listen: false);
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print(message);
          print(message);
          showNotification(message["notification"]["title"],message["notification"]["body"]);
      FirebaseApi.uploadNotification(
        network.userId.toString(),
        message["notification"]["title"],
        message["data"]["notification_type"],
        '${message["data"]["lastName"]} ${message["data"]["firstName"]}',
        '${message["data"]["jobId"]}',
        '${message["data"]["bidId"]}',
        '${message["data"]["bidderId"]}',
        '${message["data"]["artisanId"]}',
        '${message['data']['budget']}'
      );
      FirebaseApi.uploadCheckNotify(
        network.userId.toString(),
      );
      //}

      setState(() => _message = message["notification"]["title"]);
    }, onResume: (Map<String, dynamic> message) async {
      setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      setState(() => _message = message["notification"]["title"]);
    });
  }

  // showNotification(value1, value2) async {
  //   var android = AndroidNotificationDetails('id', 'channel ', 'description',
  //       priority: Priority.high, importance: Importance.max);
  //   var iOS = IOSNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );
  //   var platform = new NotificationDetails(android: android, iOS: iOS);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, '$value1', '$value2', platform,
  //       payload: 'New job is available around you');
  // }

 showNotification(value1, value2) async {
    var android = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max, sound: RawResourceAndroidNotificationSound('sound'),
      playSound: true,
    );
    var iOS = IOSNotificationDetails(
      sound: 'sound.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, '$value1', '$value2', platform,
        payload: 'New job is available around you');
  }
  @override
  void dispose() {
    _myPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context, listen: false);
    WebServices network = Provider.of<WebServices>(context, listen: false);
    List<Notify> notify;
    // FirebaseApi.updateUsertoOnline(datas.mobile_device_token);

    var widget = Scaffold(
      key: scafoldKey,
      drawer: SizedBox(
        width: 240,
        child: Drawer(
          child: DrawerWidget(context, _myPage),
        ),
      ),
      bottomNavigationBar: Consumer<DataProvider>(
          builder: (context, conData, child) {
            return Container(
        height: 60,
        child: BottomNavigationBar(
            onTap: (index) {
              if (index == conData.selectedPage) {
              } else {
                setState(() {
                  _myPage.jumpToPage(index);
                  conData.setSelectedBottomNavBar(index);
                });

              }
            },
            elevation: 20,
            type: BottomNavigationBarType.fixed,
            currentIndex: conData.selectedPage,
            unselectedItemColor: Color(0xFF555555),
            selectedItemColor: Color(0xFFA40C85),
            selectedLabelStyle: TextStyle(fontSize: 12),
            unselectedLabelStyle: TextStyle(fontSize: 12),
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Icon(
                    conData.selectedPage == 0
                        ? Icons.home_rounded
                        : Icons.home_outlined,
                    size: 28,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Icon(conData.selectedPage == 1
                      ? Icons.account_balance_wallet
                      : Icons.account_balance_wallet_outlined),
                ),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: conData.selectedPage == 2
                      ? Icon(
                          Icons.add_circle_rounded,
                          size: 25,
                        )
                      : Icon(FeatherIcons.plusCircle),
                ),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Stack(
                    children: [
                      StreamBuilder(
                          stream: FirebaseApi.userCheckNotifyStream(
                              network.userId.toString()),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              notify = snapshot.data.docs
                                  .map((doc) =>
                                      Notify.fromMap(doc.data(), doc.id))
                                  .toList();

                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Positioned(
                                      left: 12,
                                      child: Container());
                                default:
                                  if (snapshot.hasError) {
                                    return Positioned(
                                        left: 12,
                                        child: Container());
                                  } else {
                                    final users = notify;
                                    if (users.isEmpty || users == null) {
                                      return Positioned(
                                          left: 12,
                                          child: Container());
                                    } else {
                                      return Positioned(
                                        left: 12,
                                          child: Icon(
                                        Icons.circle,
                                        color: Color(0xFF9B049B),
                                            size: 12,
                                      ));
                                    }
                                  }
                              }
                            } else {
                              return Positioned(
                                  left: 12,
                                  child: Container());
                            }
                          }),
                      Icon(FeatherIcons.bell),
                    ],
                  ),
                ),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Icon(FeatherIcons.clock),
                ),
                label: 'Manage',
              )
            ]),
      );}),


      body: WillPopScope(
        onWillPop: () {
          return showDialog(
              context: context,
              builder: (ctx) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: AlertDialog(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    content: Container(
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Oops!!',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF9B049B),
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                child: Center(
                                  child: Text(
                                    'DO YOU WANT TO EXIT THIS APP?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                Material(
                                  borderRadius: BorderRadius.circular(26),
                                  elevation: 2,
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFF9B049B)),
                                        borderRadius:
                                            BorderRadius.circular(26)),
                                    child: FlatButton(
                                      onPressed: () {
                                        return exit(0);
                                      },
                                      color: Color(0xFF9B049B),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(26)),
                                      padding: EdgeInsets.all(0.0),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(26)),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 190.0, minHeight: 53.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Yes",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(26),
                                  elevation: 2,
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFF9B049B)),
                                        borderRadius:
                                            BorderRadius.circular(26)),
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      color: Color(0xFF9B049B),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(26)),
                                      padding: EdgeInsets.all(0.0),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(26)),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 190.0, minHeight: 53.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "No",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        child: PageView(
          controller: _myPage,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Home(scafoldKey, data, _myPage),
            Wallet(),
            PostScreen(),
            NotificationPage(scafoldKey,  _myPage),
            PendingScreen(scafoldKey),
          ],
        ),
      ),
    );

    return PickupLayout(scaffold: widget);
  }
}
