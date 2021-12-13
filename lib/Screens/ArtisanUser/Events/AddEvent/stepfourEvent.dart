import 'package:fixme/Screens/ArtisanUser/Events/AddEvent/stepfiveEvent.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class stepfourEvent extends StatefulWidget {
  @override
  stepfourEventState createState() => stepfourEventState();
}

class stepfourEventState extends State<stepfourEvent> {
  var password;
  TextEditingController  duration = TextEditingController();
  TextEditingController venueName = TextEditingController();
  TextEditingController address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var data =Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Step 4', style: TextStyle(color: Color(0xFF9B049B)),),
          )
        ],
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
                'Name of venue',
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
                controller: venueName,
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
                  labelText: 'Name of venue',
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
              padding: const EdgeInsets.only(bottom: 12.0, top: 0),
              child: Text(
                'Address',
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
                controller: address,
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
                  labelText: 'Address',
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
              padding: const EdgeInsets.only(bottom: 12.0, top: 0),
              child: Text(
                'Duration',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 0.2,
              height: 55,
              child: Stack(
                children: [
                  TextFormField(
                    onFieldSubmitted: (v){
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    textCapitalization:
                    TextCapitalization.sentences,
                    keyboardType: TextInputType.number,
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    autocorrect: true,
                    enableSuggestions: true,
                    maxLines: null,
                    controller: duration,
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
                      labelText: 'Duration',
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
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      child: Center(
                        child: Text('days'),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          border: Border.all(
                              color: Color(0xFF9B049B), width: 0.0)
                      ),
                      width: 70,
                      height: 55,
                    ),
                  )
                ],
              ),
            ),
SizedBox(height: 30,),
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
                          duration.text.isEmpty || address.text.isEmpty|| venueName.text.isEmpty
                              ? null
                              : () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return stepfiveEvent();
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
                           data.eventDuration =  duration.text ;
                           data.venueName = venueName.text;
                            data.addressVenue =address.text ;

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
