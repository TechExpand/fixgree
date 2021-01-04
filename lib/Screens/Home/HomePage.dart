import 'dart:io';
import 'dart:ui';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Screens/Chat/callscreens/listen_incoming_call.dart';
import 'package:fixme/Screens/Wallet/Wallet.dart';
import 'package:fixme/Screens/pending/pendingpage.dart';
import 'package:fixme/Screens/postrequest/postrequest.dart';
import 'package:fixme/Services/location_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fixme/Screens/Home/Home.dart';
import 'package:fixme/Screens/Notification/Notification.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _myPage;
  var search;
  final scafold_key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
     var data = Provider.of<Utils>(context, listen: false);

    // data.getData('firstName','Bearer','phoneNum', 'profile_pic_file_name', 'user_id', 'mobile_device_token',context);

    Provider.of<LocationService>(context, listen: false).getCurrentLocation();
    _myPage =
        PageController(initialPage: 0, viewportFraction: 1, keepPage: true);
      
  }

  @override
  void dispose() {
    _myPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
    var datas = Provider.of<Utils>(context, listen: false);
    
    // FirebaseApi.updateUsertoOnline(datas.mobile_device_token);
    var widget = Scaffold(
      key: scafold_key,
      drawer: SizedBox(
        width: 240,
        child: Drawer(
          child: DrawerWidget(context),
        ),
      ),
      bottomNavigationBar: Container(
       height: 60,
        child: BottomNavigationBar(
          onTap: (index){
           _myPage.jumpToPage(index);
           data.setSelectedBottomNavBar(index);
          
          },
          elevation: 20,
           type: BottomNavigationBarType.fixed,
        currentIndex: data.selectedPage,
          unselectedItemColor: Color(0xFF555555),
          selectedItemColor: Color(0xFFA40C85),
          selectedLabelStyle: TextStyle(
            fontSize: 13,
              fontFamily: 'Firesans'),
          unselectedLabelStyle: TextStyle(
              fontSize: 13,
              fontFamily: 'Firesans'),
          items:[
                BottomNavigationBarItem(
                
              icon: Icon(FeatherIcons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.briefcase),
              title:Text('Wallet'),
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.plusCircle),
              title: Text('Post'),
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.bell),
              title:Text('Notifications'),
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.clock),
              title:Text('Pending'),
            )
                              
          ] 
        ),
      ),
      body: WillPopScope(
         onWillPop: (){
           return showDialog(
               child: BackdropFilter(
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
                               width: 250,
                               child: Text(
                                 'DO YOU WANT TO EXIT THIS APP?',
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                   fontSize: 15,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black54,
                                 ),
                               ),
                             ),
                           ],
                         ),
                         ButtonBar(
                           alignment: MainAxisAlignment.center,
                     children: [Material(
                             borderRadius: BorderRadius.circular(26),
                             elevation: 2,
                             child: Container(
                               height: 35,
                               width: 100,
                               decoration: BoxDecoration(
                                   border: Border.all(color:  Color(0xFF9B049B)),
                                   borderRadius: BorderRadius.circular(26)),
                               child: FlatButton(
                                 onPressed: () {
                                   return exit(0);
                                 },
                                 color:  Color(0xFF9B049B),
                                 shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(26)),
                                 padding: EdgeInsets.all(0.0),
                                 child: Ink(
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(26)),
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
                                 border: Border.all(color:  Color(0xFF9B049B)),
                                 borderRadius: BorderRadius.circular(26)),
                             child: FlatButton(
                               onPressed: () {
                                 Navigator.pop(context);
                               },
                               color:  Color(0xFF9B049B),
                               shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(26)),
                               padding: EdgeInsets.all(0.0),
                               child: Ink(
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(26)),
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
                           ]
                         ),
                       ],
                     ),
                   ),
                 ),
               ),
               context: context);
      },
              child: PageView(
          controller: _myPage,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Home(scafold_key, data),
            Wallet(),
            PostScreen(),
            NotificationPage(scafold_key),
            PendingScreen(),
          ],
        ),
      ),
    );
           
    return PickupLayout(scaffold: widget);
  }
}
