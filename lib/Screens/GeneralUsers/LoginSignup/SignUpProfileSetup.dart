import 'package:flutter/material.dart';
import 'SignUpSetName.dart';
import 'SignupEmail.dart';

class SignUpProfileSetup extends StatefulWidget {
  @override
  SignUpProfileSetupState createState() => SignUpProfileSetupState();
}

class SignUpProfileSetupState extends State<SignUpProfileSetup> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var password;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.keyboard_backspace))),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 3.5,
              ),
              width: MediaQuery.of(context).size.width / 0.2,
              height: 50,
              child: Text(
                'Set up your profile',
                style: TextStyle(
                  letterSpacing: 0.5,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,),
              ),




            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(26)),
                child: FlatButton(
                  onPressed: () {

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return SignUpEmail();
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                        "CONTINUE WITH EMAIL",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: 40,
                ),
                child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return SignUpSetProfile();
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Text('Skip')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}