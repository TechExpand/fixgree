import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'SignUpSetName.dart';

class SignUpEmail extends StatefulWidget {
  @override
  SignUpEmailState createState() => SignUpEmailState();
}

class SignUpEmailState extends State<SignUpEmail> {
  var password;

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                'Enter your email',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 0.2,
              height: 50,
              child: TextFormField(
                onChanged: (value) {
                  data.setEmail(value);
                },
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black38),
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF9B049B), width: 0.0),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF9B049B), width: 0.0),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF9B049B), width: 0.0),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: 50,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(26)),
                child: FlatButton(
                  disabledColor: Color(0x909B049B),
                  onPressed: data.emails.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return SignUpSetProfile();
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
                  color: Color(0xFF9B049B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(26)),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 1.3,
                          minHeight: 45.0),
                      alignment: Alignment.center,
                      child: Text(
                        "CONTINUE",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}