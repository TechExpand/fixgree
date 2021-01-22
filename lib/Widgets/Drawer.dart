
import 'package:fixme/Screens/ArtisanUser/Profile/ProfilePage.dart';
import 'package:fixme/Screens/ArtisanUser/RegisterArtisan/address.dart';
import 'package:fixme/Screens/ArtisanUser/RegisterArtisan/thankyou.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/LoginSignup/Login.dart';
import 'package:fixme/Screens/GeneralUsers/Profile/Profile.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget{
  var currentContext;
  var controller;

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
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(''),
                  radius: 22,
                  backgroundImage:NetworkImage(
                    network.profile_pic_file_name=='no_picture_upload'||
                        network.profile_pic_file_name  ==null ?'https://uploads.fixme.ng/originals/no_picture_upload':
                    'https://uploads.fixme.ng/originals/${network.profile_pic_file_name}',
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white,
                ),
                title: Text(
                  network.firstName,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  network.phoneNum,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Account',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              )),
          InkWell(
            onTap: () async{
               SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.getString('role')==null||prefs.getString('role')==''||prefs.getString('role')=='user'?Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return Profile();
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              ):Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return ProfilePage();
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.person_outline, color: Color(0xF0A40C85)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('Profile'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
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
              },
              child: Row(
                children: [
                  Icon(Icons.chat, color: Color(0xF0A40C85)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('My Chats'),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Services',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              )),
              InkWell(
            onTap:(){
              network.role == 'artisan' || network.role == 'business'? Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return ProfilePage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ):Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return SignThankyou();
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
              
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.assignment_return, color: Color(0xF0A40C85)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('Become an Arisan'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.assignment, color: Color(0xF0A40C85)),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('Manage orders'),
                ),
              ],
            ),
          ),
          
         InkWell(
           onTap: (){
              Navigator.pop(context);
              widget.controller.jumpToPage(2);
               data.setSelectedBottomNavBar(2);
               
           },
           child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(FontAwesomeIcons.penSquare, color: Color(0xF0A40C85)),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('Post a request'),
                ),
              ],
            ),
          ),
         ) ,
          
          Divider(),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('General',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.offline_pin, color: Color(0xF0A40C85)),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('Online status'),
                ),
                Spacer(),
                Switch(value: true, onChanged: null)
              ],
            ),
          ),
          InkWell(
             onTap: (){
               Navigator.pop(context);
              widget.controller.jumpToPage(1);
               data.setSelectedBottomNavBar(1);
           },
            child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Color(0xF0A40C85)),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('Payments'),
                ),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.send, color: Color(0xF0A40C85)),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('Invite friends'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.headset_mic, color: Color(0xF0A40C85)),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('Support'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
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
              child: Row(
                children: [
                  Icon(Icons.assignment_ind, color: Color(0xF0A40C85)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                    child: Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
    );
  }
}
