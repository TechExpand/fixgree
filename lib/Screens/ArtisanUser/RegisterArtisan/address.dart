import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bvn.dart';

class SignUpAddress extends StatefulWidget {
  @override
  SignUpAddressState createState() => SignUpAddressState();
}

class SignUpAddressState extends State<SignUpAddress> {
  var password;
  TextEditingController  officeAddress = TextEditingController();
  TextEditingController homeAddress = TextEditingController();
TextEditingController businessName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var data =Provider.of<DataProvider>(context, listen: false);
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
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20,),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, top: 15),
              child: Text(
                'Enter your Address',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              width: MediaQuery.of(context).size.width / 0.2,
              height: 55,
              child: TextFormField(
                onFieldSubmitted: (v){
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                textCapitalization:
                TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                maxLines: null,
                controller: homeAddress,
                onChanged: (value) {
                  setState(() {
                    data.sethomeAdress(value);
                  });

                },
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: TextStyle(color: Colors.black38),
                  labelText: 'Home Address',
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
            Container(
              width: MediaQuery.of(context).size.width / 0.2,
              height: 55,
              child: TextFormField(
                onFieldSubmitted: (v){
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                textCapitalization:
                TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                maxLines: null,
                controller: officeAddress,
                onChanged: (value) {
                  setState(() {
                    data.setofficeAddress(value);
                  });

                },
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: TextStyle(color: Colors.black38),
                  labelText: 'Office Address',
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
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, top: 15),
              child: Text(
                'Enter your Business Name',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              width: MediaQuery.of(context).size.width / 0.2,
              height: 55,
              child: TextFormField(
                onFieldSubmitted: (v){
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                textCapitalization:
                TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                maxLines: null,
                controller: businessName,
                onChanged: (value) {
                  setState(() {
                    data.setBusinessName(value);
                  });
                },
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: TextStyle(color: Colors.black38),
                  labelText: 'Business Name',
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

    Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Consumer<DataProvider>(
      builder: (context, conData, child) {
      return Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 30,
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(26)),
                  child: FlatButton(
                    disabledColor: Color(0x909B049B),
                    onPressed:
                   officeAddress.text.isEmpty || homeAddress.text.isEmpty|| businessName.text.isEmpty
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) {
                                      return SignUpBvn();
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
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
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
              );}),
    ),
          ],
        ),
      ),
    );
  }
}
