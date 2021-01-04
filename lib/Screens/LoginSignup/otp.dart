import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SignupPassword.dart';
import 'package:fixme/Services/network_service.dart';


class OTPPAGE extends StatefulWidget {
    var verificationID;
    var data;
    var Credential;
    String page;

    OTPPAGE({this.verificationID, this.data, this.Credential, this.page});

    @override
    OTPState createState() => OTPState();
}

class OTPState extends State<OTPPAGE> {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    static final TextEditingController controller1 = TextEditingController();
    static final TextEditingController controller2 = TextEditingController();
    static final TextEditingController controller3 = TextEditingController();
    static final TextEditingController controller4 = TextEditingController();
    static final TextEditingController controller5 = TextEditingController();
    static final TextEditingController controller6 = TextEditingController();

Timer _timer;
int _start = 120;

void startTimer() {
  const oneSec = const Duration(seconds: 1);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    },
  );
}



    void initState(){
      super.initState();
      startTimer();
    }

    @override
void dispose() {
  _timer.cancel();
  super.dispose();
}

    @override
    Widget build(BuildContext context) {
        controller1.selection = TextSelection.fromPosition(
            TextPosition(offset: controller1.text.length));
        controller2.selection = TextSelection.fromPosition(
            TextPosition(offset: controller2.text.length));
        controller3.selection = TextSelection.fromPosition(
            TextPosition(offset: controller3.text.length));
        controller4.selection = TextSelection.fromPosition(
            TextPosition(offset: controller4.text.length));
        controller5.selection = TextSelection.fromPosition(
            TextPosition(offset: controller5.text.length));
        controller6.selection = TextSelection.fromPosition(
            TextPosition(offset: controller6.text.length));
        var node = FocusScope.of(context);
        var data = Provider.of<DataProvider>(context);
        var auth = FirebaseAuth.instance;
var network = Provider.of<WebServices>(context);


        //register user if code is correct after code has been sent again
        signinWithPhoneAndSMScode(id, sms_code) async {
            try {
                AuthCredential authcred =
                PhoneAuthProvider.credential(verificationId: id, smsCode: sms_code);

                final User user =
                    (await FirebaseAuth.instance.signInWithCredential(authcred)).user;
                data.setUserID(user.uid);
                //otpTimer.cancel();
                await widget.page=="SignUp"?Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                           network.Login_SetState();
                            return SignUpPassword();
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: animation,
                                child: child,
                            );
                        },
                    ),
                ):network.Login(context: context, scaffoldKey:scaffoldKey);
            } catch (e) {
                print(e.message);
                scaffoldKey.currentState
                    .showSnackBar(SnackBar(content: Text(e.message)));
            }
        }



        return Scaffold(
            key: scaffoldKey,
            body: Material(
                child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 45),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Text(
                                'Enter code',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                    'An SMS code was sent to',
                                    style: TextStyle(
                                        fontSize: 12,
                                    ),
                                ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 10),
                                child: Text(
                                    widget.data ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                    ),
                                ),
                            ),
                            Text(
                                'Edit phone number',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4A154B),
                                ),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(top: 10, left: 6),
                                        height: 39,
                                        width: 39,
                                        child: TextField(
                                            onChanged: (value) {
                                                if (controller1.text.length == 1) {
                                                    data.setOTPfocus_value(
                                                        focus1: false,
                                                        focus2: true,
                                                        focus3: false,
                                                        focus4: false,
                                                        focus5: false,
                                                        focus6: false,
                                                    );
                                                    node.nextFocus();
                                                }
                                                data.setCombineOtpValue(
                                                    cont1: controller1,
                                                    cont2: controller2,
                                                    cont3: controller3,
                                                    cont4: controller4,
                                                    cont5: controller5,
                                                    cont6: controller6);
                                            },
                                            controller: controller1,
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.phone,
                                            maxLength: 1,
                                            onTap: () {
                                                data.setOTPfocus_value(
                                                    focus1: true,
                                                    focus2: false,
                                                    focus3: false,
                                                    focus4: false,
                                                    focus5: false,
                                                    focus6: false,
                                                );
                                            },
                                            decoration: InputDecoration(
                                                fillColor: data.focus_value
                                                    ? Colors.white
                                                    : Color(0xFFE5E5E5),
                                                filled: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Color(0xFF9B049B)),
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(10.0),
                                                    )),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0),
                                                    )),
                                                counterText: ''
//                            border: InputBorder.none, counterText: ''
                                            ),
                                        ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 10, left: 6),
                                        height: 39,
                                        width: 39,
                                        child: TextField(
                                            onChanged: (value) {
                                                if (controller2.text.length == 1) {
                                                    data.setOTPfocus_value(
                                                        focus1: false,
                                                        focus2: false,
                                                        focus3: true,
                                                        focus4: false,
                                                        focus5: false,
                                                        focus6: false,
                                                    );
                                                    node.nextFocus();
                                                }
                                                data.setCombineOtpValue(
                                                    cont1: controller1,
                                                    cont2: controller2,
                                                    cont3: controller3,
                                                    cont4: controller4,
                                                    cont5: controller5,
                                                    cont6: controller6);
                                            },
                                            controller: controller2,
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.phone,
                                            maxLength: 1,
                                            onTap: () {
                                                data.setOTPfocus_value(
                                                    focus1: false,
                                                    focus2: true,
                                                    focus3: false,
                                                    focus4: false,
                                                    focus5: false,
                                                    focus6: false,
                                                );
                                            },
                                            decoration: InputDecoration(
                                                fillColor: data.focus_value1
                                                    ? Colors.white
                                                    : Color(0xFFE5E5E5),
                                                filled: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Color(0xFF9B049B)),
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(10.0),
                                                    )),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0),
                                                    )),
                                                counterText: ''
//                            border: InputBorder.none, counterText: ''
                                            ),
                                        ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 10, left: 6),
                                        height: 39,
                                        width: 39,
                                        child: TextField(
                                            onChanged: (value) {
                                                if (controller3.text.length == 1) {
                                                    data.setOTPfocus_value(
                                                        focus1: false,
                                                        focus2: false,
                                                        focus3: false,
                                                        focus4: true,
                                                        focus5: false,
                                                        focus6: false,
                                                    );
                                                    node.nextFocus();
                                                }
                                                data.setCombineOtpValue(
                                                    cont1: controller1,
                                                    cont2: controller2,
                                                    cont3: controller3,
                                                    cont4: controller4,
                                                    cont5: controller5,
                                                    cont6: controller6);
                                            },
                                            controller: controller3,
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.phone,
                                            maxLength: 1,
                                            onTap: () {
                                                data.setOTPfocus_value(
                                                    focus1: false,
                                                    focus2: false,
                                                    focus3: true,
                                                    focus4: false,
                                                    focus5: false,
                                                    focus6: false,
                                                );
                                            },
                                            decoration: InputDecoration(
                                                fillColor: data.focus_value2
                                                    ? Colors.white
                                                    : Color(0xFFE5E5E5),
                                                filled: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Color(0xFF9B049B)),
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(10.0),
                                                    )),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0),
                                                    )),
                                                counterText: ''
//                            border: InputBorder.none, counterText: ''
                                            ),
                                        ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 10, left: 6),
                                        height: 39,
                                        width: 39,
                                        child: TextField(
                                            onChanged: (value) {
                                                if (controller4.text.length == 1) {
                                                    data.setOTPfocus_value(
                                                        focus1: false,
                                                        focus2: false,
                                                        focus3: false,
                                                        focus4: false,
                                                        focus5: true,
                                                        focus6: false,
                                                    );
                                                    node.nextFocus();
                                                }
                                                data.setCombineOtpValue(
                                                    cont1: controller1,
                                                    cont2: controller2,
                                                    cont3: controller3,
                                                    cont4: controller4,
                                                    cont5: controller5,
                                                    cont6: controller6);
                                            },
                                            controller: controller4,
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.phone,
                                            maxLength: 1,
                                            onTap: () {
                                                data.setOTPfocus_value(
                                                    focus1: false,
                                                    focus2: false,
                                                    focus3: false,
                                                    focus4: true,
                                                    focus5: false,
                                                    focus6: false,
                                                );
                                            },
                                            decoration: InputDecoration(
                                                fillColor: data.focus_value3
                                                    ? Colors.white
                                                    : Color(0xFFE5E5E5),
                                                filled: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Color(0xFF9B049B)),
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(10.0),
                                                    )),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0),
                                                    )),
                                                counterText: ''
//                            border: InputBorder.none, counterText: ''
                                            ),
                                        ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 10, left: 6),
                                        height: 39,
                                        width: 39,
                                        child: TextField(
                                            onChanged: (value) {
                                                if (controller5.text.length == 1) {
                                                    data.setOTPfocus_value(
                                                        focus1: false,
                                                        focus2: false,
                                                        focus3: false,
                                                        focus4: false,
                                                        focus5: false,
                                                        focus6: true,
                                                    );
                                                    node.nextFocus();
                                                }
                                                data.setCombineOtpValue(
                                                    cont1: controller1,
                                                    cont2: controller2,
                                                    cont3: controller3,
                                                    cont4: controller4,
                                                    cont5: controller5,
                                                    cont6: controller6);
                                            },
                                            controller: controller5,
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.phone,
                                            maxLength: 1,
                                            onTap: () {
                                                data.setOTPfocus_value(
                                                    focus1: false,
                                                    focus2: false,
                                                    focus3: false,
                                                    focus4: false,
                                                    focus5: true,
                                                    focus6: false,
                                                );
                                            },
                                            decoration: InputDecoration(
                                                fillColor: data.focus_value4
                                                    ? Colors.white
                                                    : Color(0xFFE5E5E5),
                                                filled: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Color(0xFF9B049B)),
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(10.0),
                                                    )),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0),
                                                    )),
                                                counterText: ''
//                            border: InputBorder.none, counterText: ''
                                            ),
                                        ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 10, left: 6),
                                        height: 39,
                                        width: 39,
                                        child: TextField(
                                            onChanged: (value) {
                                                if (controller6.text.length == 1) {
                                                    data.setOTPfocus_value(
                                                        focus1: false,
                                                        focus2: false,
                                                        focus3: false,
                                                        focus4: false,
                                                        focus5: false,
                                                        focus6: false,
                                                    );
                                                    node.unfocus();
                                                }
                                                data.setCombineOtpValue(
                                                    cont1: controller1,
                                                    cont2: controller2,
                                                    cont3: controller3,
                                                    cont4: controller4,
                                                    cont5: controller5,
                                                    cont6: controller6);
                                            },
                                            controller: controller6,
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.phone,
                                            maxLength: 1,
                                            onTap: () {
                                                data.setOTPfocus_value(
                                                    focus1: false,
                                                    focus2: false,
                                                    focus3: false,
                                                    focus4: false,
                                                    focus5: false,
                                                    focus6: true,
                                                );
                                            },
                                            decoration: InputDecoration(
                                                fillColor: data.focus_value5
                                                    ? Colors.white
                                                    : Color(0xFFE5E5E5),
                                                filled: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Color(0xFF9B049B)),
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(10.0),
                                                    )),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0),
                                                    )),
                                                counterText: ''
//                            border: InputBorder.none, counterText: ''
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                           _start!=0? Align(
                             alignment: Alignment.bottomRight,
                               child: Padding(
                               padding: const EdgeInsets.only(right:50.0, top:15),
                               child: Container(
                                 width: 25,
                                 height: 25,
                                 decoration: BoxDecoration(
                                    color:  Color(0x909B049B),
                                   shape: BoxShape.circle,
                                 ),
                                 child: Center(child: Text('$_start'))),
                             ),
                           ):Align(
                             alignment: Alignment.bottomRight,
                                  child: FlatButton(
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: (){
                                   
                                       FirebaseAuth.instance.verifyPhoneNumber(
                                            phoneNumber: data.number.toString(),
                                            verificationCompleted: (credential) async {
                                                await auth.signInWithCredential(credential);
                                                await Navigator.pushReplacement(
                                                    context,
                                                    PageRouteBuilder(
                                                        pageBuilder: (context, animation, secondaryAnimation) {
                                                            return SignUpPassword();
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
                                            verificationFailed: (FirebaseAuthException e) {
                                                scaffoldKey.currentState
                                                    .showSnackBar(SnackBar(content: Text(e.message)));
                                            },
                                            timeout: Duration(seconds: 120),
                                            codeSent: (String verificationId, int resendToken) {
                                                widget.verificationID = verificationId;
                                                scaffoldKey.currentState
                                                    .showSnackBar(SnackBar(content: Text('Code Sent')));
                                            },
                                            codeAutoRetrievalTimeout: (String verificationId) {},
                                        ).then((value){
                                          setState(() {
                                             _start = 120;
                                      startTimer();
                                          });
           
                                    });
                                  },
                                  child:Text('Resend Code')
                                ),
                           ),
                           
                            Spacer(),
                            Align(
                                alignment: Alignment.center,
                                child: !network.login_state?Container(
                                    margin: EdgeInsets.only(
                                        bottom: 50,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(26)),
                                    child: FlatButton(
                                        disabledColor: Color(0x909B049B),
                                        onPressed: controller1.text.isEmpty ||
                                            controller2.text.isEmpty ||
                                            controller3.text.isEmpty ||
                                            controller4.text.isEmpty ||
                                            controller5.text.isEmpty ||
                                            controller6.text.isEmpty
                                            ? null
                                            : () {
                                            network.Login_SetState();
                                            signinWithPhoneAndSMScode(
                                                widget.verificationID, data.otp);
                                        },
                                        color: Color(0xFF9B049B),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(26)),
                                        padding: EdgeInsets.all(0.0),
                                        child: Ink(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(26)),
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
                                ):Padding(
                      padding: const EdgeInsets.only(bottom:50.0),
                      child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),),
                    )
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
