import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Model/Message.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Model/Product.dart';
import 'package:fixme/Screens/GeneralUsers/Bids/Bids.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/callscreens/pickup_screen.dart';
import 'package:fixme/Screens/GeneralUsers/LoginSignup/Login.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/call_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickupLayout extends StatefulWidget {
  final Widget scaffold;
  PickupLayout({
    @required this.scaffold,
  });

  @override
  _PickupLayoutState createState() => _PickupLayoutState();
}


class _PickupLayoutState extends State<PickupLayout>{

  final CallApi callApi = CallApi();
  List<Bidify> bidify;
  List<Message> messageData;
  
  var market;

  callmarket(context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    network.checkData().then((value) {
      setState(() {
        market = value ;

      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callmarket(context);
  }


  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context);
    return Builder(
      builder:(context){
       return  market==null?Material(
         color: Colors.white,
         child: Center(
           child: Container(
             height: 80,
             child:   Image.asset(
               'assets/images/loader.gif',
               height: 100,
               width: 100,
               fit: BoxFit.cover,
             ),
           ),
         ),):  market=='timeout' || market == 'socket' || market =='error'?
       Material(
         color: Colors.white,
           child: Container(
           child:   Center(child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                   height: 200,
                   child:   Image.asset(
                     'assets/images/invalid.gif',
                     height: 20,
                     width: 200,
                     fit: BoxFit.cover,
                   ),
                 ),
               ),

               Text("TimeOut! No Network Available", style: TextStyle(
                   color: Colors.black,
                   fontSize: 21,
                   height: 1.4,
                   fontWeight: FontWeight.w500)),
               TextButton.icon(onPressed: (){
                 setState(() {
                   market = null;
                   callmarket(context);
                 });
               }, icon: Icon(Icons.refresh, color: Color(0xFF9B049B),),
                   label: Text('Refresh', style: TextStyle(color: Color(0xFF9B049B)),))
             ],
           ),),
       ),
         ) : market=='500'?Material(
         child: Container(
           child:   Center(child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                   height: 200,
                   child:   Image.asset(
                     'assets/images/invalid.gif',
                     height: 20,
                     width: 200,
                     fit: BoxFit.cover,
                   ),
                 ),
               ),

               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text("Account Logged in on Another Device!", style: TextStyle(
                     color: Colors.black,
                     fontSize: 21,
                     height: 1.4,
                     fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
               ),
               TextButton.icon(onPressed: ()async{
                 SharedPreferences prefs = await SharedPreferences.getInstance();
                 prefs.clear();
                 //ScaffoldMessenger.of(context).dispose();
                 Navigator.pushAndRemoveUntil(
                   context,
                   PageRouteBuilder(
                     pageBuilder: (context, animation, secondaryAnimation) {
                       return Login(); //SignUpAddress();
                     },
                     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                       return FadeTransition(
                         opacity: animation,
                         child: child,
                       );
                     },
                   ),
                       (route) => false,
                 );
               }, icon: Icon(Icons.logout, color: Color(0xFF9B049B),),
                   label: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text('Login into this Device',
                       style: TextStyle(color: Color(0xFF9B049B)), textAlign: TextAlign.center,),
                   ),)
             ],
           ),),
         ),
       ) :StreamBuilder(
            stream: FirebaseApi.userBidStream(network.userId.toString()),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot2) {
              return  snapshot2.hasData
                  ? StreamBuilder(
                stream: callApi.getCallLogs(network.mobileDeviceToken),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  return snapshot.hasData
                      ?Builder(builder: (context){
                    bidify = snapshot2.data.docs
                        .map((doc) => Bidify.fromMap(doc.data(), doc.id))
                        .toList();

                    messageData = snapshot.data.docs
                        .map((doc) => Message.fromMap(doc.data(), doc.id))
                        .toList();



                    final message = messageData;
                    final bid = bidify;
                    return snapshot.hasData && snapshot2.hasData
                        ? !message.isEmpty
                        ? PickupScreen(message: message[0])
                        : !bid.isEmpty
                        ? BidPage()
                        : widget.scaffold
                        : widget.scaffold;
                  }):Material(
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        height: 80,
                        child:   Image.asset(
                          'assets/images/loader.gif',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),);
                },
              )
                  : Material(
                color: Colors.white,
                child: Center(
                  child: Container(
                    height: 80,
                    child:   Image.asset(
                      'assets/images/loader.gif',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),);
            });
      }
    );
  } //BidPage
}
