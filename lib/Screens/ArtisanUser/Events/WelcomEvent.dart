import 'package:fixme/Screens/ArtisanUser/RegisterArtisan/address.dart';
import 'package:fixme/Screens/ArtisanUser/RegisterArtisan/startprofile.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AddEvent/EventUpload.dart';


class EventWelcome extends StatefulWidget {
  @override
  EventWelcomeState createState() => EventWelcomeState();
}

class EventWelcomeState extends State<EventWelcome> {
  var password;

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
    var network = Provider.of<WebServices>(context);
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: InkWell(
                child: Icon(Icons.arrow_back, color: Color(0xFF9B049B)),
                onTap: () {
                  Navigator.pop(context);
                }),
            backgroundColor: Colors.transparent,
          ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Center(
              child: Text('Fixme for Event Managers',
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child: Text(
                      "Fixme prides in offering a great experience for each user, in order to gain the most from our platform we need you to understand and agree to the following before going forward and filling out your Business details.",
                      style:
                      TextStyle(height: 1.6, fontWeight: FontWeight.w500)),
                  alignment: Alignment.bottomLeft,
                )),
            Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child: Text("You agree to the following:"),
                  alignment: Alignment.bottomLeft,
                )),
            Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('1.  ', style: TextStyle(color: Colors.black)),
                        Expanded(
                          child: Text(
                              'Fill out your profile thoroughly and accurately',
                              style: TextStyle(color: Colors.black)),
                        )
                      ]),
                  alignment: Alignment.bottomLeft,
                )),
            Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('2.  ', style: TextStyle(color: Colors.black)),
                        Expanded(
                            child: Text('Submit your profile',
                                style: TextStyle(color: Colors.black))),
                      ]),
                  alignment: Alignment.bottomLeft,
                )),
            Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('3.  ', style: TextStyle(color: Colors.black)),
                        Expanded(
                          child: Text(
                              'Offer good services or products to every customer that contacts you and gain good reviews.',
                              style: TextStyle(color: Colors.black)),
                        )
                      ]),
                  alignment: Alignment.bottomLeft,
                )),
            Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('4.  ', style: TextStyle(color: Colors.black)),
                        Expanded(
                          child: Text(
                              'Upload good pictures of services or products sold to increase your chance of getting sales.',
                              style: TextStyle(color: Colors.black)),
                        )
                      ]),
                  alignment: Alignment.bottomLeft,
                )),
            Padding(
                padding: EdgeInsets.only(top: 25, left: 15),
                child: Align(
                  child: Text(
                      "Create a stand-out profile and build reviews, to increase your chances of getting daily customers.",
                      style: TextStyle(
                        height: 1.6,
                      )),
                  alignment: Alignment.bottomLeft,
                )),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                  top: 40,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(26)),
                child: FlatButton(
                  disabledColor: Color(0x909B049B),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return EventPhotoPage();
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
                        "Get Started",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
