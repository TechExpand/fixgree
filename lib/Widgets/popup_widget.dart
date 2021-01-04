import 'package:flutter/material.dart';

Future popDialog (BuildContext context, String message, String imagepath) async{
return showDialog(context: context,
child: AlertDialog(
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
  ],)
);
}