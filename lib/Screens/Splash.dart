import 'package:firebase_core/firebase_core.dart';
import 'package:fixme/Screens/GeneralUsers/IntroPages/intro.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'GeneralUsers/Home/HomePage.dart';
import 'GeneralUsers/LoginSignup/Login.dart';
import 'package:fixme/Utils/utils.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPLASHSTATE();
  }
}

class SPLASHSTATE extends State<SplashScreen> {




  @override
  void initState() {
    super.initState();
    checkForUpdate();
    Provider.of<WebServices>(context, listen: false).initializeValues();
    Provider.of<WebServices>(context, listen: false).checkDevice();
    Future.delayed(Duration(seconds: 5), () async {
      //sendAndRetrieveMessage();
      getit();


      return decideFirstWidget();
    });
  }

// Replace with server token from firebase console settings.
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  getit() async {
    var network = Provider.of<WebServices>(context, listen: false);
    var data = Provider.of<Utils>(context, listen: false);
    await firebaseMessaging.getToken().then((value) {
      data.setFCMToken(value);
    });
    network.updateFCMToken(network.userId, data.fcmToken);
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if(info.updateAvailability == UpdateAvailability.updateAvailable){
        InAppUpdate.performImmediateUpdate()
            .catchError((e){
          print(e);
        });
      }
    }).catchError((e) {
      print(e);
    });
  }





  Future<Widget> decideFirstWidget() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('Bearer');
    var data = Provider.of<DataProvider>(context, listen: false);
    data.setSplash(true);

    if (token == null || token == 'null' || token == '') {
      return Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return IntroPage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
        (route) => false,
      );
    } else {
      return Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return HomePage(); //SignUpAddress();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Hero(
            tag: 'MainImage',
            child: Image.asset(
              'assets/images/fixme.png',
              scale: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
