import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'GeneralUsers/Home/HomePage.dart';
import 'GeneralUsers/LoginSignup/Login.dart';
import 'package:fixme/Utils/utils.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
  final String serverToken =
      'AAAA2lAKGZU:APA91bFmok2miRE6jWBUgfmu5jhvxQGJ5ITwrcwrHMghkPOZCIYYxLu-rIs-ub6HQ5YdiEGx3jG2tMvmiEjq-KW4rEgGrckHNkGdFrO2iUDoidvmh867VQj0FKx-_cxbi8AQpR1S3cCu';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  getit() async {
    var data = Provider.of<Utils>(context, listen: false);
    await firebaseMessaging.getToken().then((value) {
      data.setFCMToken(value);
    });
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



  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    try {
      var data = Provider.of<Utils>(context, listen: false);
      await firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false),
      );

      await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'this is a body',
              'title': 'this is a title'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': await firebaseMessaging.getToken(),
          },
        ),
      );

      final Completer<Map<String, dynamic>> completer =
          Completer<Map<String, dynamic>>();

      firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          completer.complete(message);
        },
      );

      return completer.future;
    } catch (e) {}
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
            return Login();
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
