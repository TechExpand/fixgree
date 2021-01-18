
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'SignUpProfileSetup.dart';

class SignUpPassword extends StatefulWidget {
    @override
    SignUpPasswordState createState() => SignUpPasswordState();
}

class SignUpPasswordState extends State<SignUpPassword> {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    Widget build(BuildContext context) {
        var data = Provider.of<DataProvider>(context);
        return Scaffold(
            key: scaffoldKey,
            body: Material(
                child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 45),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Text(
                                    'Enter a password',
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
                                    obscureText: data.password_obscure,
                                    onChanged: (value) {
                                        data.setPassword(value);
                                    },
                                    style: TextStyle(color: Colors.black),
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                                data.password_obscure
                                                    ? data.setPassWordObscure(false)
                                                    : data.setPassWordObscure(true);
                                            },
                                            icon: Icon(
                                                data.password_obscure
                                                    ? FontAwesomeIcons.eyeSlash
                                                    : FontAwesomeIcons.eye,
                                                color: Colors.black38,
                                                size: 20,
                                            )),
                                        labelStyle: TextStyle(color: Colors.black38),
                                        labelText: 'Password',
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
                                    )),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                    children: [
                                        Padding(
                                            padding: const EdgeInsets.only(right: 5.0),
                                            child: Icon(
                                                data.password.length < 8
                                                    ? Icons.check_circle_outline
                                                    : Icons.check_circle,
                                                color: Color(0xFF9B049B),
                                                size: 15,
                                            ),
                                        ),
                                        Text(
                                            'Password must contain atleast 8 characters',
                                            style: TextStyle(fontSize: 15, color: Colors.black38),
                                        ),
                                    ],
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
                                        onPressed: data.password.length < 8 || data.password.isEmpty
                                            ? null
                                            : () {
                                            Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                    pageBuilder:
                                                        (context, animation, secondaryAnimation) {
                                                        return SignUpProfileSetup();
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
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(26)),
                                            child: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: MediaQuery.of(context).size.width / 1.3,
                                                    minHeight: 45.0),
                                                alignment: Alignment.center,
                                                child: Text(
                                                    "CONFIRM",
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
            ),
        );
    }
}