import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Model/Message.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Screens/GeneralUsers/Bids/Bids.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/callscreens/pickup_screen.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/call_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallApi callApi = CallApi();
  List<Bidify> bidify;
  List<Message> messageData;
  PickupLayout({
    @required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context);
    return StreamBuilder(
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
                          : scaffold
                          : scaffold;
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
  } //BidPage
}
