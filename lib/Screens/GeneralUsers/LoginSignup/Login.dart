import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'SignUpNumber.dart';
import 'otp.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG', dialCode: '+234');
  var auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context);
    var data = Provider.of<DataProvider>(context);
    dynamic Credential = '';
    var OTP;
    var auth = FirebaseAuth.instance;
    verifyNumber() async {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: data.number.toString(),
          verificationCompleted: (credential) async {
            network.Login_SetState();
            await auth.signInWithCredential(credential);
            Credential = credential;
            await network.Login(context: context, scaffoldKey: scaffoldKey);
          },
          verificationFailed: (FirebaseAuthException e) {
            network.Login_SetState();
            scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text(e.message)));
          },
          timeout: Duration(seconds: 120),
          codeSent: (String verificationId, int resendToken) {
            network.Login_SetState();

            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnihfmation) {
                  return OTPPAGE(
                      verificationID: verificationId,
                      data: data.number.toString(),
                      Credential: Credential,
                      page: 'Login');
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
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        network.Login_SetState();
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
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 85.0),
                child: Hero(
                  tag: 'MainImage',
                  child: Image.asset(
                    'assets/images/fixme.png',
                    scale: 1.5,
                  ),
                ),
              )),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width / 0.2,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF9B049B),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 7.0),
                  child: InternationalPhoneNumberInput(
                    textStyle: TextStyle(fontSize: 17, color: Colors.black),
                    inputBorder: InputBorder.none,
                    onInputChanged: (PhoneNumber num) {
                      data.setNumber(num);
                      print(data.number.toString());
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG,
//                backgroundColor: Colors.black,
                    ),
                    ignoreBlank: false,
                    initialValue: number,

//              autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    textFieldController: controller,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () async {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return SignUp();
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
                      child: Center(
                          child: RichText(
                              text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: 'Don\'t have an account? ',
                          style:
                              TextStyle(color: Color(0xFF777777), fontSize: 16),
                        ),
                        TextSpan(
                          text: 'Sign up',
                          style:
                              TextStyle(color: Color(0xFF9B049B), fontSize: 16),
                        )
                      ]))))),
              Align(
                  alignment: Alignment.center,
                  child: !network.login_state
                      ? Container(
                          padding: EdgeInsets.only(
                            bottom: 50,
                            top: 50,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26)),
                          child: FlatButton(
                            onPressed:
                                data.number.toString() == data.number.dialCode
                                    ? null
                                    : () {
                                        network.Login_SetState();
                                        verifyNumber();
                                      },
                            color: Color(0xFF9B049B),
                            disabledColor: Color(0x909B049B),
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
                                  "LOGIN",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 50.0, top: 25),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(accentColor: Color(0xFF9B049B)),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
