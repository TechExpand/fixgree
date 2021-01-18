import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'SignupPassword.dart';
import 'otp.dart';

class SignUp extends StatefulWidget {
    @override
    SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp>{
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final TextEditingController controller = TextEditingController();
     String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG',dialCode: '+234');
    var OTP;
    var auth = FirebaseAuth.instance;

    @override
    Widget build(BuildContext context) {
        var network = Provider.of<WebServices>(context);
        var data = Provider.of<DataProvider>(context);
        dynamic Credential = '';


        //verify phone number if numbe is correct and if  code is retrieved
        verifyNumber()async {
            try {
                await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: data.number.toString(),
                    verificationCompleted: (credential) async {
                        await auth.signInWithCredential(credential);
                        Credential = credential;
                        await Navigator.push(
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
                        network.Login_SetState();
                        scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text(e.message)));
                    },
                    timeout: Duration(seconds: 120),
                    codeSent: (String verificationId, int resendToken) {
                        network.Login_SetState();
      
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnihfmation) {
                                    return OTPPAGE(verificationID:verificationId,data: data.number.toString(),Credential: Credential, page:'SignUp');
                                },
                                transitionsBuilder: (context, animation, secondaryAnimation,
                                    child) {
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
            }catch(e){
                scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text(e.message)));
            }
        }


        //when phone is verify , then register the phone to the backend(firebase)
      
        return Scaffold(
            key: scaffoldKey,
            body: Material(
                child: Padding(
                    padding: const EdgeInsets.only(left:20.0,right:20,top:45),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Text(
                                'Enter your number',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top:15.0, bottom: 15),
                                child: Text(
                                    'We wil send a code to verify your mobile number',
                                ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width/0.2,
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFF9B049B),
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.only(left:7.0),
                                    child: InternationalPhoneNumberInput(
                                         initialValue: number,
                                        textStyle: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black
                                        ),
                                        inputBorder:  InputBorder.none,
                                        onInputChanged: (PhoneNumber num){
                                            data.setNumber(num);
                                        },
                                        
                                        onInputValidated: (bool value) {
                                            print(value);
                                        },
                                        selectorConfig: SelectorConfig(
                                            selectorType: PhoneInputSelectorType.DIALOG,
//                backgroundColor: Colors.black,
                                        ),
                                        ignoreBlank: false,
//              autoValidateMode: AutovalidateMode.disabled,
                                        selectorTextStyle: TextStyle(color: Colors.black),
                                        textFieldController: controller,
                                    ),
                                ),
                            ),
                            Spacer(),
                            Align(
                                alignment: Alignment.center,
                                child: !network.login_state?Container(
                                    padding: EdgeInsets.only(
                                        bottom: 50,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(color:  Colors.white),
                                        borderRadius: BorderRadius.circular(26)
                                    ),
                                    child: FlatButton(
                                        onPressed: data.number.toString()==data.number.dialCode?null:(){
//                        network.Login();
                                            network.Login_SetState();
                                            verifyNumber();

                                        },
                                        color:  Color(0xFF9B049B),
                                        disabledColor: Color(0x909B049B),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                                        padding: EdgeInsets.all(0.0),
                                        child: Ink(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(26)
                                            ),
                                            child: Container(
                                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/1.3, minHeight: 45.0),
                                                alignment: Alignment.center,
                                                child: Text(
                                                    "CONTINUE",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                    ),
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