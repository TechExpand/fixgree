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
  PickupLayout({
    @required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context);
    return StreamBuilder(
        stream: FirebaseApi.userBidStream(network.userId.toString()),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot2) {
          return snapshot2.hasData
              ? StreamBuilder<List<Message>>(
                  stream: callApi.getCallLogs(network.mobileDeviceToken),
                  builder: (context, snapshot) {
                    bidify = snapshot2.data.docs
                        .map((doc) => Bidify.fromMap(doc.data(), doc.id))
                        .toList();

                    final bid = bidify;
                    return snapshot.hasData || snapshot2.hasData
                        ? !snapshot.data.isEmpty
                            ? PickupScreen(message: snapshot.data[0])
                            : !bid.isEmpty
                                ? BidPage()
                                : scaffold
                        : scaffold;
                  },
                )
              : Material(child: Container());
        });
  } //BidPage
}
