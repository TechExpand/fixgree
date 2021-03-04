import 'package:flutter/material.dart';
import 'package:fixme/Screens/GeneralUsers/Home/HomePage.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:provider/provider.dart';

void popDialog(BuildContext context, String message, String imagepath) {
  var data = Provider.of<DataProvider>(context, listen: false);
  showModalBottomSheet(
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: (){},
        child: Container(
          height: 200,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/scan.gif",
                  height: 125.0,
                  width: 125.0,
                ),
                Text('Getting Nearby Services', style:TextStyle(fontWeight:FontWeight.bold), textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),
      );
    },
  );

  Future.delayed(Duration(seconds: 30), (){
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          data.setSelectedBottomNavBar(0);
          return HomePage();
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
  });
}

Future popDialogs(BuildContext context, String message, String imagepath) async {
  return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            Center(
              child: Container(
                height: 100,
                child: Image.asset(
                  imagepath,
                  scale: 1.5,
                  //  width: 100,
                  // height: 100,
                ),
              ),
            ),
            // Center(child: Text('Successfully Uploaded'),),
          ],
        );
      });
}
