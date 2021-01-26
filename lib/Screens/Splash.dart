
import 'package:flutter/material.dart';
import 'ArtisanUser/RegisterArtisan/address.dart';
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
     Provider.of<WebServices>(context, listen: false).initializeValues();
    Future.delayed(Duration(seconds: 5), ()async{
        getit();
    return decideFirstWidget();
  
    });
  }




// Replace with server token from firebase console settings.
final String serverToken = '<Server-Token>';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

getit()async{
 await firebaseMessaging.getToken().then((value){
   print('e dey work oooo ha ha ha $value');
     print('e dey work oooo ha ha ha $value');
     print('e dey work oooo ha ha ha $value');
      print('e dey work oooo ha ha ha $value');
 });
}



Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
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
}

  Future<Widget> decideFirstWidget() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('Bearer');
  
    if (token == null || token == 'null'|| token == ''){
     return  Navigator.pushReplacement(
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
      );
    } else {
      return  Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return HomePage();//SignUpAddress();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
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
