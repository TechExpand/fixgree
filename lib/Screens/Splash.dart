import 'package:flutter/material.dart';
import 'LoginSignup/selectauth.dart';
<<<<<<< HEAD
import 'Home/HomePage.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

=======
>>>>>>> 57fe2cbcdab49a93de83395d586d59e6e661f2cd

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
<<<<<<< HEAD
    Future.delayed(Duration(seconds: 5), ()async{
    return Navigator.pushReplacement(
=======
    Future.delayed(Duration(seconds: 5), () async {
      return Navigator.pushReplacement(
>>>>>>> 57fe2cbcdab49a93de83395d586d59e6e661f2cd
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

<<<<<<< HEAD

  /*Future<Widget> decideFirstWidget() async {
=======
  /* Future<Widget> decideFirstWidget() async {
>>>>>>> 57fe2cbcdab49a93de83395d586d59e6e661f2cd
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
