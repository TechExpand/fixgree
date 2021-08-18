import 'dart:ui';
import 'package:fixme/Screens/ArtisanUser/Profile/ProfilePageNew.dart';
import 'package:fixme/Screens/GeneralUsers/Profile/ProfileNew.dart';
import 'package:fixme/Screens/GeneralUsers/pending/pendingpage.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Utils/icons.dart';
import 'package:share/share.dart';
import 'package:fixme/Screens/ArtisanUser/RegisterArtisan/thankyou.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/LoginSignup/Login.dart';
import 'package:fixme/Screens/GeneralUsers/Profile/Profile.dart';
import 'package:fixme/Screens/GeneralUsers/Support/SupportFeedback.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  final currentContext;
  final controller;

  DrawerWidget(this.currentContext, this.controller);

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    var data = Provider.of<DataProvider>(context);

    return SafeArea(
        child: Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Container(
            color: Color(0xFF9B049B),
            height: 100,
            child: Container(
              margin: EdgeInsets.only(top: 18),
              //alignment: Alignment.bottomLeft,
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(''),
                  radius: 22,
                  backgroundImage: NetworkImage(
                    network.profilePicFileName == 'no_picture_upload' ||
                            network.profilePicFileName == null
                        ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                        : 'https://uploads.fixme.ng/originals/${network.profilePicFileName}',
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white,
                ),
                title: Text(
                  '${network.firstName} ${network.lastName}',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      network.phoneNum,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      network.email,
                      style: TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Text('Account',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              )),
          InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.getString('role') == null ||
                        prefs.getString('role') == '' ||
                        prefs.getString('role') == 'user'
                    ? Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return ProfileNew();
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
                    : Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return ProfilePageNew();
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
              child: SizedBox(
                height: 40,
                child: ListTile(
                  leading: Icon(MyFlutterApp.profile,
                      size: 18, color: Color(0xF0A40C85)),
                  contentPadding: const EdgeInsets.only(
                    left: 10,
                  ),
                  minLeadingWidth: 10,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Profile',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              )),
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return ListenIncoming();
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
                FirebaseApi.clearCheckChat(
                  network.userId.toString(),
                );
              },
              child: SizedBox(
                height: 45,
                child: ListTile(
                  leading: Stack(
                    children: [
                      Icon(
                          MyFlutterApp.fill_1,
                          size: 19, color: Color(0xF0A40C85)),
                      Icon(Icons.more_horiz, size: 19, color: Colors.white,),
                    ],
                  ),
                  contentPadding: const EdgeInsets.only(
                    left: 10,
                  ),
                  minLeadingWidth: 10,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'My Chats',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              )),
          Divider(),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Text('Services',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              )),
          network.role == 'artisan' || network.role == 'business'
              ?Container():InkWell(
              onTap: () {
                  Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return SignThankyou();
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
              child: Container(
                margin: EdgeInsets.only(bottom: 5),
                height: 45,
                child: ListTile(
                  leading:
                      Icon( MyFlutterApp.switch_icon,
                          size: 24, color: Color(0xF0A40C85)),
                  contentPadding: const EdgeInsets.only(
                    left: 10,
                  ),
                  minLeadingWidth: 10,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Change to Business Account',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              )),

          InkWell(
            onTap: () {
              Navigator.pop(context);
              widget.controller.jumpToPage(2);
              data.setSelectedBottomNavBar(2);
            },
            child: SizedBox(
              height: 45,
              child: ListTile(
                leading:
                    Icon(MyFlutterApp.postarequest,
                        size: 20, color: Color(0xF0A40C85)),
                contentPadding: const EdgeInsets.only(
                  left: 10,
                ),
                minLeadingWidth: 10,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    'Post a request',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
          Divider(),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Text('General',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              )),

          InkWell(
            onTap: () {
              Navigator.pop(context);
              widget.controller.jumpToPage(3);
              data.setSelectedBottomNavBar(3);
              PendingScreen(paymentPush:true);
            },
            child: SizedBox(
              height: 40,
              child: ListTile(
                leading: Icon(MyFlutterApp.wallet__2_,
                    size: 18,
                    color: Color(0xF0A40C85)),
                contentPadding: const EdgeInsets.only(
                  left: 10,
                ),
                minLeadingWidth: 10,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    'Payments',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Share.share('Hey\n\n I use Fixme to find Service Providers or Businesses around me. Fixme is safe and would help you gain customers as a busness. \n\n Get Fixme for free at: https://fixme.ng\n\n My Referral Code is: Fixme-${network.userId}',
                  subject: 'Share Fixme');
            },
            child: SizedBox(
              height: 40,
              child: ListTile(
                leading: Icon(Icons.share, color: Color(0xF0A40C85)),
                contentPadding: const EdgeInsets.only(
                  left: 10,
                ),
                minLeadingWidth: 10,
                title: Text(
                  'Invite friends',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return SupportFeedback();
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
            child: SizedBox(
              height: 40,
              child: ListTile(
                leading: Icon(Icons.headset_mic, color: Color(0xF0A40C85)),
                contentPadding: const EdgeInsets.only(
                  left: 10,
                ),
                minLeadingWidth: 10,
                title: Text(
                  'Support',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              return showDialog(
                  context: context,
                  builder: (ctx) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: AlertDialog(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0))),
                        content: Container(
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Oops!!',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF9B049B),
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 15, bottom: 15),
                                    child: Center(
                                      child: Text(
                                        'DO YOU WANT TO LOGOUT?',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    Material(
                                      borderRadius: BorderRadius.circular(26),
                                      elevation: 2,
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xFF9B049B)),
                                            borderRadius:
                                            BorderRadius.circular(26)),
                                        child: FlatButton(
                                          onPressed: ()async{
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.clear();
                                            ScaffoldMessenger.of(context).dispose();
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation, secondaryAnimation) {
                                                  return Login();
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
                                              borderRadius:
                                              BorderRadius.circular(26)),
                                          padding: EdgeInsets.all(0.0),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(26)),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: 190.0, minHeight: 53.0),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Yes",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      borderRadius: BorderRadius.circular(26),
                                      elevation: 2,
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xFF9B049B)),
                                            borderRadius:
                                            BorderRadius.circular(26)),
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          color: Color(0xFF9B049B),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(26)),
                                          padding: EdgeInsets.all(0.0),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(26)),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: 190.0, minHeight: 53.0),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "No",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    );
                  });

            },
            child: SizedBox(
              height: 45,
              child: ListTile(
                leading: Icon(MyFlutterApp.vector__2_,
                    size: 20, color: Color(0xF0A40C85)),
                contentPadding: const EdgeInsets.only(
                  left: 10,
                ),
                minLeadingWidth: 10,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
