import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Screens/GeneralUsers/Bids/Bidders.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BidPage extends StatefulWidget {
  @override
  _BidPageState createState() => _BidPageState();
}

class _BidPageState extends State<BidPage> {
  List<Bidify> notify;
  PageController myPage =
  PageController(initialPage: 0, viewportFraction: 1, keepPage: true);
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    stream:
                    FirebaseApi.userBidStream(network.userId.toString()),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        notify = snapshot.data.docs
                            .map((doc) => Bidify.fromMap(doc.data(), doc.id))
                            .toList();

                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
      return Center(child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            accentColor: Color(
                                                                0xFF9B049B)),
                                                    child:
                                                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                                       strokeWidth: 2,
                                              backgroundColor: Colors.white,
                                                    )),);
                          default:
                            if (snapshot.hasError) {
                              return buildText(
                                  'Something Went Wrong Try later');
                            } else {
                              final users = notify;
                              if (users.isEmpty) {
                                return buildText('No Notification Found');
                              } else
                                return Stack(
                                  children: [
                                    Container(
                                      child: PageView.builder(
                                        controller: myPage,
                                        itemBuilder: (context, index) {
                                          return Material(
                                            color: Colors.white,
                                            elevation: 1,
                                            child: Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                padding: EdgeInsets.all(8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      width:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.7,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                      text:
                                                                      '${users[index].bidder_name} ',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                          Colors.black)),
                                                                  TextSpan(
                                                                    text:
                                                                    'Accepted Your Project',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ]),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  pageBuilder: (context,
                                                                      animation,
                                                                      secondaryAnimation) {
                                                                    return BidderPage(
                                                                        users[
                                                                        index]); //SignUpAddress();
                                                                  },
                                                                  transitionsBuilder: (context,
                                                                      animation,
                                                                      secondaryAnimation,
                                                                      child) {
                                                                    return FadeTransition(
                                                                      opacity:
                                                                      animation,
                                                                      child:
                                                                      child,
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                  top: 15,
                                                                  bottom:
                                                                  12),
                                                              width: 105,
                                                              height: 28,
                                                              child: Center(
                                                                  child: Text(
                                                                      'VIEW PROFILE',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          13,
                                                                          color: Color(
                                                                              0xFFA40C85),
                                                                          fontWeight:
                                                                          FontWeight.w500))),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Color(
                                                                          0xFFA40C85)),
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      4)),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              FirebaseApi
                                                                  .clearJobBids(
                                                                users[index]
                                                                    .project_owner_user_id,
                                                              );
                                                            },
                                                            child: Container(
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                child: Text(
                                                                    'CANCEL ALL',
                                                                    style: TextStyle(
                                                                        fontStyle:
                                                                        FontStyle.italic))),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                            ),
                                          );

//
                                        },
                                        itemCount: users.length,
                                      ),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                .size
                                                .height /
                                                1.4),
                                        child: Text('Slide Through To See All',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic))),
                                    Container(
                                      margin: const EdgeInsets.only(top:40.0),
                                      child: Align(
                                        alignment:Alignment.topCenter,
                                        child: Image.asset(
                                          "assets/images/accept.gif",
                                          height: 250,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                            }
                        }
                      } else {
                        return Center(child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(accentColor: Color(0xFF9B049B)),
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                     strokeWidth: 2,
                                              backgroundColor: Colors.white,
)),);
                      }
                    },
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 15, color: Colors.black),
    ),
  );
}
