import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignUpSetProfile extends StatefulWidget {
  @override
  SignUpSetProfileState createState() => SignUpSetProfileState();
}

class SignUpSetProfileState extends State<SignUpSetProfile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context);
    var data = Provider.of<DataProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 45),
        child: Material(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  'Enter your name',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    width: 140,
                    height: 40,
                    child: TextFormField(
                        onChanged: (value) {
                          data.setFirstName(value);
                        },
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black38),
                          labelText: 'First name',
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF9B049B), width: 0.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(12))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF9B049B), width: 0.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(12))),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF9B049B), width: 0.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(12))),
                        )),
                  ),
                  Container(
                    width: 140,
                    height: 40,
                    child: TextFormField(
                        onChanged: (value) {
                          data.setLastName(value);
                        },
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black38),
                          labelText: 'Last name',
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF9B049B), width: 0.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(12))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF9B049B), width: 0.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(12))),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF9B049B), width: 0.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(12))),
                        )),
                  ),
                ],
              ),
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(26)),
                    child: network.login_state == false
                        ? FlatButton(
                      disabledColor: Color(0x909B049B),
                      onPressed:
                      data.firstName.isEmpty || data.lastName.isEmpty
                          ? null
                          : () {
                        network.Login_SetState();
                        network.Register(context: context, scaffoldKey: scaffoldKey);
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
                            "DONE",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                        : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF9B049B)))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
