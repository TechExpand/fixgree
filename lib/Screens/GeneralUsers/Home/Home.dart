import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixme/DummyData.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanPageNew.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ProfilePageNew.dart';
import 'package:fixme/Screens/ArtisanUser/RegisterArtisan/thankyou.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
import 'package:fixme/Screens/GeneralUsers/Home/NearbyArtisansSeeAll.dart';
import 'package:fixme/Screens/GeneralUsers/Home/NearbyShopsSeeAll.dart';
import 'package:fixme/Screens/GeneralUsers/Home/PopularServices.dart';
import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
import 'package:fixme/Screens/GeneralUsers/Notification/Notification.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/icons.dart';
import 'package:fixme/Widgets/Rating.dart';
import 'package:flutter/material.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final scafoldKey;
  var search;
  final data;
  final controller;

  Home(this.scafoldKey, this.data, this.controller);

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;


  String getDistance({String rawDistance}) {
    String distance;

    distance = '$rawDistance' + 'km';

    return distance;
  }
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;


@override
 void initState(){
   super.initState();
   var network = Provider.of<WebServices>(context, listen: false);
   var data = Provider.of<Utils>(context, listen: false);
   network.updateFCMToken(network.userId, data.fcmToken);
   initConnectivity();

   _connectivitySubscription =    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
   checkConnection();
 }






  Future<Widget> checkConnection()async{
    var locationStatus = await Permission.location.status;
    var notificationStatus = await Permission.notification.status;
    // var connectivityResult = await (Connectivity().checkConnectivity());
    if (_connectionStatus == ConnectivityResult.mobile) {
      if(locationStatus.isDenied && notificationStatus.isDenied){
        print(locationStatus.isGranted);
        print(notificationStatus.isGranted);
        print(locationStatus.isGranted);
        print(notificationStatus.isGranted);
        showDialog(
            barrierDismissible: false,
            context: context, builder: (context){
          return WillPopScope(
            onWillPop: (){},
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AlertDialog(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                content: Container(
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Notice',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF9B049B),
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 250,
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Center(
                              child: Text(
                                locationStatus.isDenied?'Accepting location permission is neccessary for the app to function': 'Accepting notification permission is neccessary for the app to function',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
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
                                        "Exit",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
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
                                  onPressed:Platform.isAndroid? () async{
                                    Navigator.pop(context);
                                    Map<Permission, PermissionStatus> statuses = await [
                                      Permission.notification,
                                      Permission.accessNotificationPolicy,
                                      Permission.locationAlways,
                                    ].request();
                                  }:(){
                                    Navigator.pop(context);
                                    note();
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
                                        "Grant Access",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
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
            ),
          );
        });
      }else{

      }
    } else if (_connectionStatus == ConnectivityResult.wifi) {
      if(locationStatus.isDenied && notificationStatus.isDenied){
        print('isGranted locationStatus ' + locationStatus.isGranted.toString());
        print('isLimited locationStatus '+locationStatus.isLimited.toString());
        print('isDenied locationStatus'+locationStatus.isDenied.toString());
        print('isRestricted locationStatus'+locationStatus.isRestricted.toString());
        print('isPermanentlyDenied locationStatus'+locationStatus.isPermanentlyDenied.toString());



        print('isGranted notificationStatus ' + notificationStatus.isGranted.toString());
        print('isLimited notificationStatus '+notificationStatus.isLimited.toString());
        print('isDenied notificationStatus'+notificationStatus.isDenied.toString());
        print('isRestricted notificationStatus'+notificationStatus.isRestricted.toString());
        print('isPermanentlyDenied notificationStatus'+notificationStatus.isPermanentlyDenied.toString());
        showDialog(
            barrierDismissible: false,
            context: context, builder: (context){
          return WillPopScope(
            onWillPop: (){},
            child:BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AlertDialog(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                content: Container(
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Notice',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF9B049B),
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 250,
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Center(
                              child: Text(
                                locationStatus.isDenied?'Accepting location permission is neccessary for the app to function': 'Accepting notification permission is neccessary for the app to function',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
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
                                        "Exit",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
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
                                  onPressed: Platform.isAndroid? () async{
                                    Navigator.pop(context);
                                    Map<Permission, PermissionStatus> statuses = await [
                                      Permission.notification,
                                      Permission.accessNotificationPolicy,
                                      Permission.locationAlways,
                                    ].request();
                                  }: (){
                                    Navigator.pop(context);
                                    note();
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
                                        "Grant Access",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
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
            ),
          );
        });
      }else{

      }
    }else{
      showDialog(context: context, builder: (context){
        return WillPopScope(
          onWillPop: (){},
          child: BackdropFilter(
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
                          width:250,
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: Center(
                            child: Text(
                              'No Network Activity Found',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
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
                                      "Exit",
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
          ),
        );
      });
    }
  }


  note()async{
    var locationStatus = await Permission.location.status;
    var notificationStatus = await Permission.notification.status;
    if(locationStatus.isDenied){
    AppSettings.openLocationSettings();
    }else if(notificationStatus.isDenied){
      AppSettings.openNotificationSettings();
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }


  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }


  @override
  Widget build(BuildContext context) {

    var network = Provider.of<WebServices>(context, listen: false);
    List<Notify> notify;
    var location = Provider.of<LocationService>(context);

    var data = Provider.of<DataProvider>(context);
    return Stack(
      children: [
        CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              forceElevated: true,
              backgroundColor: Colors.white,
              titleSpacing: 0.0,
              elevation: 2.5,
              shadowColor: Color(0xFFF1F1FD).withOpacity(0.5),
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top:4.0, bottom: 4, left:10),
                      child: IconButton(
                        onPressed: (){
                          widget.scafoldKey.currentState.openDrawer();
                        },
                        icon: Icon(MyFlutterApp.hamburger,
                          size: 17, color: Colors.black),
                      ),
                    ),
                  Spacer(),
                  Image.asset(
                    'assets/images/fixme1.png',
                    height: 70,
                    width: 70,
                  ),
               Spacer(),
               InkWell(
                 onTap: (){
                   Navigator.push(
                     context,
                     PageRouteBuilder(
                       pageBuilder:
                           (context, animation, secondaryAnimation) {
                         return NotificationPage(widget.scafoldKey, widget.controller);
                       },
                       transitionsBuilder:
                           (context, animation, secondaryAnimation, child) {
                         return FadeTransition(
                           opacity: animation,
                           child: child,
                         );
                       },
                     ),
                   );
                 },
                 child: Padding(
                        padding: const EdgeInsets.only(top: 5,right: 10, left:5),
                        child: Stack(
                          children: [
                            Icon(
                              MyFlutterApp.vector_4,
                              color:  Color(0xF0A40C85),
                              size: 24,),
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
                                              color: Colors.red,
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

                          ],
                        ),
                      ),
               ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return ListenIncoming();
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );

                      FirebaseApi.clearCheckChat(
                        network.mobileDeviceToken
                            .toString(),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top:8.0, bottom: 8, right: 16, left: 16),
                      child:  Stack(
                            children: [
                              Icon(
                                  MyFlutterApp.fill_1,
                                  size: 23, color: Color(0xF0A40C85)),
                              Icon(Icons.more_horiz, size: 23, color: Colors.white,),
                              StreamBuilder(
                                  stream: FirebaseApi.userCheckChatStream(
                                      network.mobileDeviceToken.toString()),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      notify = snapshot.data.docs
                                          .map((doc) =>
                                          Notify.fromMap(doc.data(), doc.id))
                                          .toList();

                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Positioned(
                                              right: 12, child: Container());
                                        default:
                                          if (snapshot.hasError) {
                                            return Positioned(
                                                right: 12, child: Container());
                                          } else {
                                            final users = notify;
                                            if (users.isEmpty || users == null) {
                                              return Positioned(
                                                  left: 12, child: Container());
                                            } else {
                                              return Container(
                                                margin: EdgeInsets.only(left: 12),
                                                    height: 12,
                                                      width: 12,
                                                   decoration: BoxDecoration(
                                                     color: Colors.red,
                                                     borderRadius: BorderRadius.circular(100)
                                                   ),
                                                  );
                                            }
                                          }
                                      }
                                    } else {
                                      return Positioned(
                                          right: 12, child: Container());
                                    }
                                  }),
                            ],
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                      width: MediaQuery.of(context).size.width / 0.2,
                      height: 60,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return SearchPage();
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'searchButton',
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                border: Border.all(color: Colors.black12),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFFF1F1FD).withOpacity(0.7),
                                      blurRadius: 10.0,
                                      offset: Offset(0.3, 4.0))
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black38,
                                    size: 20,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                      enabled: false,
                                      obscureText: true,
                                      style: TextStyle(color: Colors.black),
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration.collapsed(
                                        enabled: false,
                                        hintStyle: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 15),
                                        hintText: 'What are you looking for?',
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Popular Services',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),

                          // InkWell(
                          //   onTap: () {
                          //     //TODO: here
                          //   },
                          //   child: Text('See all',
                          //       style: TextStyle(
                          //           color: Color(0xFF9B049B), fontSize: 14)),
                          // )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 12.0,
                        left: 10,
                      ),
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: popularServices.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 105,
                            margin: const EdgeInsets.only(right: 7),
                            decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                border: Border.all(color: Color(0xFFF1F1FD)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFFF1F1F6),
                                      blurRadius: 10.0,
                                      offset: Offset(0.3, 4.0))
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return PopularServices(
                                        serviceName: popularServices[index]
                                            ['text'],
                                        serviceId: popularServices[index]['id'],
                                        latitude: location.locationLatitude,
                                        longitude: location.locationLongitude,
                                      );
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: Container(
                                        height: 90,
                                        width: 115,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(7),
                                                topRight: Radius.circular(7))),
                                        child: Image.asset(
                                          '${popularServices[index]['image']}',
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  Text(
                                    '${popularServices[index]['text']}',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nearby Shops',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return NearbyShopsSeeAll(
                                        longitude: location.locationLatitude,
                                        latitude: location.locationLatitude);
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text('See all',
                                style: TextStyle(
                                    color: Color(0xFF9B049B), fontSize: 14)),
                          )
                        ],
                      ),
                    ),
                    FutureBuilder(
                        future: network.nearbyShop(
                            latitude: location.locationLatitude,
                            longitude: location.locationLongitude,
                            context: context),
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Theme(
                                            data: Theme.of(context).copyWith(
                                                //accentColor: Color(0xFF9B049B)
                                      ),
                                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                              strokeWidth: 2,
                                              backgroundColor: Colors.white,
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Loading shops',
                                            style: TextStyle(
                                                color: Color(0xFF333333),
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ))
                              : snapshot.hasData && !snapshot.data.isEmpty
                                  ? Container(
                                      height: 222,
                                      margin: const EdgeInsets.only(bottom: 6),
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length > 10
                                            ? 10
                                            : snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          String distance = getDistance(
                                              rawDistance:
                                                  '${snapshot.data[index].distance}');
                                          return InkWell(
                                            onTap: () {
                                              network.postViewed(snapshot.data[index].id);
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                      animation,
                                                      secondaryAnimation) {
                                                    return ArtisanPageNew(
                                                        snapshot.data[index]);
                                                  },
                                                  transitionsBuilder: (context,
                                                      animation,
                                                      secondaryAnimation,
                                                      child) {
                                                    return FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: GridTile(
                                              child: Container(
                                                // width: 150,
                                                margin: const EdgeInsets.only(
                                                  left: 10,
                                                  top: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFFFFFFF),
                                                    border: Border.all(
                                                        color: Color(0xFFF1F1FD)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color:
                                                              Color(0xFFF1F1F6),
                                                          blurRadius: 10.0,
                                                          offset:
                                                              Offset(0.3, 4.0))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(7))),
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 4.0),
                                                            child: Container(
                                                              height: 90,
                                                              width: 150,
                                                              clipBehavior: Clip
                                                                  .antiAliasWithSaveLayer,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              7),
                                                                      topRight: Radius
                                                                          .circular(
                                                                              7))),
                                                              child:
                                                                  Image.network(
                                                                snapshot.data[index].urlAvatar ==
                                                                            'no_picture_upload' ||
                                                                        snapshot.data[index]
                                                                                .urlAvatar ==
                                                                            null
                                                                    ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                                                    : 'https://uploads.fixme.ng/originals/${snapshot.data[index].urlAvatar}',
                                                                fit: BoxFit.cover,
                                                              ),
                                                            )),
                                                        Positioned(
                                                          bottom: 4,
                                                          child: Container(
                                                            height: 20,
                                                            width: 150,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            color: Colors.black
                                                                .withOpacity(0.5),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .location_on,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 14,
                                                                ),
                                                                Text(
                                                                  '$distance away',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Align(
                                                        alignment:
                                                            Alignment.bottomLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0.0,
                                                                  right: 0.0),
                                                          child: Wrap(
                                                            children: [
                                                              Container(
                                                               // width:140,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top:8.0),
                                                                  child: Text(
                                                                    snapshot
                                                                                .data[
                                                                                    index]
                                                                                .businessName
                                                                                .isEmpty ||
                                                                            snapshot.data[index].businessName ==
                                                                                ''
                                                                        ? '${snapshot.data[index].name}\'s shop '
                                                                            .capitalizeFirstOfEach
                                                                        : '${snapshot.data[index].businessName}'
                                                                            .capitalizeFirstOfEach,
                                                                    style: TextStyle(
                                                                      fontSize: 13,
                                                                    ),
                                                                    maxLines: 1,
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    Container(
                                                      width: 150,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                            Alignment.center,
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets.only(
                                                                  left: 8.0,
                                                                  right: 8.0, top:2),
                                                              child: Wrap(
                                                                children: [
                                                                  Text(
                                                                    '${snapshot.data[index].serviceArea}',
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                  bottom: 2, top:4),
                                                                child: Center(
                                                                  child: StarRating(
                                                                      rating: double.parse(
                                                                          snapshot.data[index]
                                                                              .userRating
                                                                              .toString())),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )

                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : snapshot.data.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Container(
                                            color: Color(0xFFBBBBBB),
                                            padding: const EdgeInsets.all(4),
                                            child: Text(
                                              'No Nearby Shops',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        )
                                      : Container();
                        }),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nearby Service Provider',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return NearbyArtisansSeeAll(
                                        longitude: location.locationLatitude,
                                        latitude: location.locationLatitude);
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text('See all',
                                style: TextStyle(
                                    color: Color(0xFF9B049B), fontSize: 14)),
                          )
                        ],
                      ),
                    ),
                    FutureBuilder(
                        future: network.nearbyArtisans(
                            latitude: location.locationLatitude,
                            longitude: location.locationLongitude,
                            context:context
                        ),
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Theme(
                                            data: Theme.of(context).copyWith(
                                               accentColor: Color(0xFF9B049B)
                                      ),
                                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),

                                              strokeWidth: 2,
                                              backgroundColor: Colors.white,
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Loading Service Provider',
                                            style: TextStyle(
                                                color: Color(0xFF333333),
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ))
                              : snapshot.hasData && !snapshot.data.isEmpty
                                  ?

                          Container(
                            height: 222,
                            margin: const EdgeInsets.only(bottom: 6),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length > 10
                                                  ? 10
                                                  : snapshot.data.length,
                              itemBuilder: (context, index) {
                                String distance = getDistance(
                                    rawDistance:
                                    '${snapshot.data[index].distance}');
                                return InkWell(
                                  onTap: () {
                                    network.postViewed(snapshot.data[index].id);
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context,
                                            animation,
                                            secondaryAnimation) {
                                          return ArtisanPageNew(
                                              snapshot.data[index]);
                                        },
                                        transitionsBuilder: (context,
                                            animation,
                                            secondaryAnimation,
                                            child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: GridTile(
                                    child: Container(
                                      // width: 150,
                                      margin: const EdgeInsets.only(
                                        left: 10,
                                        top: 12,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFFFFFFF),
                                          border: Border.all(
                                              color: Color(0xFFF1F1FD)),
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                Color(0xFFF1F1F6),
                                                blurRadius: 10.0,
                                                offset:
                                                Offset(0.3, 4.0))
                                          ],
                                          borderRadius:
                                          BorderRadius.all(
                                              Radius.circular(7))),
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      bottom: 4.0),
                                                  child: Container(
                                                    height: 90,
                                                    width: 150,
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(
                                                                7),
                                                            topRight: Radius
                                                                .circular(
                                                                7))),
                                                    child:
                                                    Image.network(
                                                      snapshot.data[index].urlAvatar ==
                                                          'no_picture_upload' ||
                                                          snapshot.data[index]
                                                              .urlAvatar ==
                                                              null
                                                          ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                                          : 'https://uploads.fixme.ng/originals/${snapshot.data[index].urlAvatar}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                              Positioned(
                                                bottom: 4,
                                                child: Container(
                                                  height: 20,
                                                  width: 150,
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      left: 5),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .location_on,
                                                        color: Colors
                                                            .white,
                                                        size: 14,
                                                      ),
                                                      Text(
                                                        '$distance away',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontSize:
                                                            12,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                              alignment:
                                              Alignment.bottomLeft,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 0.0,
                                                    right: 0.0),
                                                child: Wrap(
                                                  children: [
                                                    Container(
                                                      // width:140,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top:8.0),
                                                        child: Text(
                                                          snapshot
                                                              .data[
                                                          index]
                                                              .businessName
                                                              .isEmpty ||
                                                              snapshot.data[index].businessName ==
                                                                  ''
                                                              ? '${snapshot.data[index].name}\'s shop '
                                                              .capitalizeFirstOfEach
                                                              : '${snapshot.data[index].businessName}'
                                                              .capitalizeFirstOfEach,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                          maxLines: 1,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          Container(
                                            width: 150,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment:
                                                  Alignment.center,
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 8.0, top:2),
                                                    child: Wrap(
                                                      children: [
                                                        Text(
                                                          '${snapshot.data[index].serviceArea}',
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          bottom: 2, top:4),
                                                      child: Center(
                                                        child: StarRating(
                                                            rating: double.parse(
                                                                snapshot.data[index]
                                                                    .userRating
                                                                    .toString())),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )

                                  : snapshot.data.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Container(
                                            color: Color(0xFFBBBBBB),
                                            padding: const EdgeInsets.all(4),
                                            child: Text(
                                              'No Nearby Service Provider',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        )
                                      : Container();
                        }),
                    Divider(),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.only(top: 8, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7)),
                        child: FlatButton(
                          onPressed: () {
                            network.role == 'artisan' || network.role == 'business'
                                ? Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return ProfilePageNew();
                                },
                                transitionsBuilder:
                                    (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            )
                                : Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return SignThankyou();
                                },
                                transitionsBuilder:
                                    (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          color: Color(0xFF9B049B),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width / 1.3,
                                  minHeight: 45.0),
                              alignment: Alignment.center,
                              child: Text('${network.role == 'artisan' || network.role == 'business'
                                  ? 'View Business Profile':'Change to Business Account'}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child:Text(''),
                      height:80,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
       Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            blurRadius: 10.0,
                            offset: Offset(5, 4.0))
                      ],
                      border: Border.all(color: Color(0xFFD0D0D0)),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 14,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7)),
                          child: FlatButton(
                            onPressed: () {
                              data.setCallToActionStatus = false;
                              widget.controller.jumpToPage(2);
                              data.setSelectedBottomNavBar(2);
                            },
                            color: Color(0xFF9B049B),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width / 1.1,
                                    minHeight: 45.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Get a job done",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )

      ],
    );
  }
}
