import 'package:flutter/material.dart';
import 'LoginSignup/selectauth.dart';
import 'Home/HomePage.dart';
import 'package:fixme/Utils/utils.dart';
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
    Future.delayed(Duration(seconds: 5), ()async{
    return Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SelectAuthScreen();
          },
          // transitionDuration: Duration(milliseconds: 700),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }


  /*Future<Widget> decideFirstWidget() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('Bearer');
  
    if (token == null || token == 'null'|| token == ''){
     return  Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SelectAuthScreen();
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
            return HomePage();
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
  }*/

 

  @override
  Widget build(BuildContext context) {
    // Provider.of<WebServices>(context, listen: false).initializeValues(context);
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
