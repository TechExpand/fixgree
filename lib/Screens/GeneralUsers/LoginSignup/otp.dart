import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SignupPassword.dart';
import 'package:fixme/Services/network_service.dart';

class OTPPAGE extends StatefulWidget {
  var verificationID;
  final data;
  final mainCredential;
  String page;

  OTPPAGE({this.verificationID, this.data, this.mainCredential, this.page});

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
  int _start = 100;

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

  void initState() {
    super.initState();
    Provider.of<LocationService>(context, listen: false).getCurrentLocation();
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
    var data = Provider.of<DataProvider>(context,  listen: true);
    var auth = FirebaseAuth.instance;
    var network = Provider.of<WebServices>(context);

    //register user if code is correct after code has been sent again
    signinWithPhoneAndSMScode(id, smsCode) async {
      try {
        AuthCredential authcred =
        PhoneAuthProvider.credential(verificationId: id, smsCode: smsCode);

        final User user =
            (await FirebaseAuth.instance.signInWithCredential(authcred)).user;
        if (user != null) {
          //data.setUserID(user.uid);
        }
        //otpTimer.cancel();
        widget.page == "SignUp"
            ? Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              network.loginSetState();
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
        )
            : network.login(context: context, scaffoldKey: scaffoldKey);
      } catch (e) {
  
        network.loginSetState();
         await showTextToast(
                                                                            text: e.message,
                                                                              context: context,
                                                                                             );
       
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading:  IconButton(
          icon:Icon(Icons.keyboard_backspace, color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      key: scaffoldKey,
      body: Material(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Enter code',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Edit phone number',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A154B),
                  ),
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
                          data.setOTPfocusValue(
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
                        data.setOTPfocusValue(
                          focus1: true,
                          focus2: false,
                          focus3: false,
                          focus4: false,
                          focus5: false,
                          focus6: false,
                        );
                      },
                      decoration: InputDecoration(
                          fillColor: data.focusValue
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
                          data.setOTPfocusValue(
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
                        data.setOTPfocusValue(
                          focus1: false,
                          focus2: true,
                          focus3: false,
                          focus4: false,
                          focus5: false,
                          focus6: false,
                        );
                      },
                      decoration: InputDecoration(
                          fillColor: data.focusValue1
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
                          data.setOTPfocusValue(
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
                        data.setOTPfocusValue(
                          focus1: false,
                          focus2: false,
                          focus3: true,
                          focus4: false,
                          focus5: false,
                          focus6: false,
                        );
                      },
                      decoration: InputDecoration(
                          fillColor: data.focusValue2
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
                          data.setOTPfocusValue(
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
                        data.setOTPfocusValue(
                          focus1: false,
                          focus2: false,
                          focus3: false,
                          focus4: true,
                          focus5: false,
                          focus6: false,
                        );
                      },
                      decoration: InputDecoration(
                          fillColor: data.focusValue3
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
                          data.setOTPfocusValue(
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
                        data.setOTPfocusValue(
                          focus1: false,
                          focus2: false,
                          focus3: false,
                          focus4: false,
                          focus5: true,
                          focus6: false,
                        );
                      },
                      decoration: InputDecoration(
                          fillColor: data.focusValue4
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
                          data.setOTPfocusValue(
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
                        data.setOTPfocusValue(
                          focus1: false,
                          focus2: false,
                          focus3: false,
                          focus4: false,
                          focus5: false,
                          focus6: true,
                        );
                      },
                      decoration: InputDecoration(
                          fillColor: data.focusValue5
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
              _start != 0
                  ? Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 50.0, top: 15),
                  child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Color(0x909B049B),
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text('$_start'))),
                ),
              )
                  : Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      FirebaseAuth.instance
                          .verifyPhoneNumber(
                        phoneNumber: data.number.toString(),
                        verificationCompleted: (credential) async {
                          await auth.signInWithCredential(credential).then((value){
                            widget.page == "SignUp"
                                ? Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  network.loginSetState();
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
                            )
                                : network.login(context: context, scaffoldKey: scaffoldKey);
                          });

                        },
                        verificationFailed: (FirebaseAuthException e) async{
                           await showTextToast(
                                                                            text: e.message,
                                                                              context: context,
                                                                                             );
                         
                        },
                        timeout: Duration(seconds: 120),
                        codeSent:
                            (String verificationId, int resendToken) async{
                          widget.verificationID = verificationId;
                            await showTextToast(
                                                                            text: 'Code Sent',
                                                                              context: context,
                                                                                             );
                         
                        },
                        codeAutoRetrievalTimeout:
                            (String verificationId) {},
                      )
                          .then((value) {
                        setState(() {
                          _start = 100;
                          startTimer();
                        });
                      });
                    },
                    child: Text('Resend Code')),
              ),
              Spacer(),
              Align(
                  alignment: Alignment.center,
                  child: !network.loginState
                      ? Container(
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
                        network.loginSetState();
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
                              maxWidth:
                              MediaQuery.of(context).size.width / 1.3,
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
                  )
                      : Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            accentColor: Color(
                                                                0xFF9B049B)),
                                                    child:
                                                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                                       strokeWidth: 2,
                                              backgroundColor: Colors.white,
                                                    )),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
