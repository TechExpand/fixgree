import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Model/Project.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chat.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/icons.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PendingScreen extends StatefulWidget {
  final scafoldKey;
  final paymentPush;

  PendingScreen({this.scafoldKey, this.paymentPush});

  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  var search;
  bool index = false;
  bool isStatus = false;


  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Utils>(context, listen: false);
    var network = Provider.of<WebServices>(context, listen: false);
    List<Notify> notify;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        elevation: 2.5,
        shadowColor: Color(0xFFF1F1FD).withOpacity(0.5),
        title: Container(
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 4.0, bottom: 4, left: 0),
                    child: IconButton(
                      onPressed: () {
                        widget.scafoldKey.currentState.openDrawer();
                      },
                      icon: Icon(MyFlutterApp.hamburger,
                          size: 17, color: Colors.black),
                    ),
                  ),

                  Spacer(),
                  Image.asset(
                    'assets/images/fixme1.png',
                    height: 70,
                    width: 70,
                  ),
                  Spacer(),
                  // Container(
                  //   margin: EdgeInsets.only(top: 4, left: 1),
                  //   width: MediaQuery.of(context).size.width / 1.5,
                  //   height: 35,
                  //   child: InkWell(
                  //     splashColor: Colors.transparent,
                  //     hoverColor: Colors.transparent,
                  //     focusColor: Colors.transparent,
                  //     highlightColor: Colors.transparent,
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         PageRouteBuilder(
                  //           pageBuilder:
                  //               (context, animation, secondaryAnimation) {
                  //             return SearchPage();
                  //           },
                  //           transitionsBuilder: (context, animation,
                  //               secondaryAnimation, child) {
                  //             return FadeTransition(
                  //               opacity: animation,
                  //               child: child,
                  //             );
                  //           },
                  //         ),
                  //       );
                  //     },
                  //     child: TextFormField(
                  //         obscureText: true,
                  //         enabled: false,
                  //         style: TextStyle(color: Colors.black),
                  //         cursorColor: Colors.black,
                  //         decoration: InputDecoration(
                  //           prefixIcon: Icon(Icons.search),
                  //           labelStyle: TextStyle(color: Colors.black38),
                  //           labelText: 'What are you looking for?',
                  //           enabledBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Colors.black38, width: 0.0),
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(4))),
                  //           focusedBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Colors.black38, width: 0.0),
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(4))),
                  //           border: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Colors.black38, width: 0.0),
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(4))),
                  //         )),
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return ListenIncoming();
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
                        FirebaseApi.clearCheckChat(
                          network.mobileDeviceToken.toString(),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Stack(
                              children: [
                                Icon(MyFlutterApp.fill_1,
                                    size: 23, color: Color(0xF0A40C85)),
                                Icon(
                                  Icons.more_horiz,
                                  size: 23,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            StreamBuilder(
                                stream: FirebaseApi.userCheckChatStream(
                                    network.mobileDeviceToken.toString()),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    notify = snapshot.data.docs
                                        .map((doc) =>
                                            Notify.fromMap(doc.data(), doc.id))
                                        .toList();

                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Positioned(
                                            left: 12, child: Container());
                                      default:
                                        if (snapshot.hasError) {
                                          return Positioned(
                                              left: 12, child: Container());
                                        } else {
                                          final users = notify;
                                          if (users.isEmpty || users == null) {
                                            return Positioned(
                                                left: 12, child: Container());
                                          } else {
                                            return Container(
                                              margin: EdgeInsets.only(left: 12),
                                              height: 12,
                                              width: 12,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                            );
                                          }
                                        }
                                    }
                                  } else {
                                    return Positioned(
                                        left: 12, child: Container());
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ])),
        backgroundColor: Colors.white,
        //forceElevated: true,
        // bottom: TabBar(
        //   unselectedLabelColor: Colors.black38,
        //   labelColor: Colors.black,
        //   indicatorColor: Color(0xFF9B049B),
        //   tabs: [
        //     Tab(
        //         child: Text('Pending',
        //             style: GoogleFonts.poppins(
        //                 fontSize: 15, fontWeight: FontWeight.w600))),
        //     Tab(
        //         child: Text('Started',
        //             style: GoogleFonts.poppins(
        //                 fontSize: 15, fontWeight: FontWeight.w600))),
        //     Tab(
        //         child: Text('Completed',
        //             style: GoogleFonts.poppins(
        //                 fontSize: 15, fontWeight: FontWeight.w600))),
        //   ],
        // ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: [
            Material(
              elevation: 0.5,
              child: Container(
                color: Colors.white,
                height: 40,
                child: InkWell(
                  onTap: () {
                    print(data.fcmToken);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 8),
                      Icon(Icons.search),
                      SizedBox(width: 8),
                      Spacer(),
                      InkWell(
                          onTap: data.isExpanded
                              ? () {
                                  setState(() {
                                    data.onExpansionChanged(false);
                                  });
                                }
                              : () {
                                  setState(() {
                                    data.onExpansionChanged(true);
                                  });
                                },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 5, bottom: 5),
                            child: Icon(
                              MyFlutterApp.filter,
                              color: Color(0xF0A40C85),
                              size: 20,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              color: Color(0xFFF6F6F6),
              duration: Duration(milliseconds: 400),
              height: data.isExpanded ? 50 : 0,
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Sort By: '),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = true;
                        isStatus = true;
                      });
                      // _myPage.jumpToPage(0);
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        height: 25,
                        width: 70,
                        decoration: BoxDecoration(
                            color: index == true
                                ? Color(0xFFA40C85)
                                : Color(0xFFC4C4C4),
                            borderRadius: BorderRadius.circular(14)),
                        child: Center(
                            child: Text('Status',
                                style: TextStyle(
                                  color: index == true
                                      ? Colors.white
                                      : Colors.black,
                                )))),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = false;
                        isStatus = false;
                      });
                      //_myPage.jumpToPage(1);
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        height: 25,
                        width: 75,
                        decoration: BoxDecoration(
                            color: index == false
                                ? Color(0xFFA40C85)
                                : Color(0xFFC4C4C4),
                            borderRadius: BorderRadius.circular(14)),
                        child: Center(
                            child: Text('Date',
                                style: TextStyle(
                                  color: index == false
                                      ? Colors.white
                                      : Colors.black,
                                )))),
                  ),
                ]),
              ),
            ),
            undoneProject(),
//                                   snapshot.data[index].status ==
//                                     'pending'
//                                     ? Padding(
//                                   padding:
//                                   const EdgeInsets.only(
//                                       left: 20,
//                                       right: 20,
//                                       bottom: 14),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                           margin:
//                                           const EdgeInsets
//                                               .only(
//                                               top: 10),
//                                           height: 25,
//                                           child: Center(
//                                               child: Text(
//                                                 '${snapshot.data[index].jobTitle}',
//                                                 style: TextStyle(
//                                                     color: Color(
//                                                         0xFF9B049B),
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .bold,
//                                                     fontSize: 9.5),
//                                                 textAlign: TextAlign
//                                                     .center,
//                                               )),
//                                           width: 73,
//                                           decoration:
//                                           BoxDecoration(
//                                             borderRadius:
//                                             BorderRadius
//                                                 .circular(
//                                                 30),
//                                             color: Color(
//                                                 0xFFA40C85)
//                                                 .withOpacity(
//                                                 0.35),
//                                           )),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets
//                                             .only(
//                                             left: 10.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment
//                                               .start,
//                                           children: [
//                                             Padding(
//                                               padding:
//                                               const EdgeInsets
//                                                   .only(
//                                                   bottom:
//                                                   4.0),
//                                               child: Text(
//                                                   '${snapshot.data[index].jobDescription}'
//                                                       .isEmpty
//                                                       ? 'No Desription'
//                                                       : '${snapshot.data[index].jobDescription}',
//                                                   style: TextStyle(
//                                                       color: Colors
//                                                           .black)),
//                                             ),
//                                             Text(
//                                                 '${snapshot.data[index].status}',
//                                                 style: TextStyle(
//                                                     color: Colors
//                                                         .black,
//                                                     fontSize:
//                                                     13)),
//                                           ],
//                                         ),
//                                       ),
//                                       Spacer(),
//                                       Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment
//                                             .end,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment
//                                             .end,
//                                         children: [
//                                           Padding(
//                                               padding:
//                                               const EdgeInsets.only(
//                                                   bottom:
//                                                   3.0),
//                                               child:
//                                               PopupMenuButton(
//                                                   offset:
//                                                   const Offset(
//                                                       0,
//                                                       1),
//                                                   elevation:
//                                                   0.1,
//                                                   color: Color(
//                                                       0xFFF6F6F6),
//                                                   shape: RoundedRectangleBorder(
//                                                       borderRadius: BorderRadius.circular(
//                                                           5)),
//                                                   icon: Icon(
//                                                       FeatherIcons
//                                                           .moreHorizontal,
//                                                       color: Color(
//                                                           0xFF9B049B)),
//                                                   itemBuilder:
//                                                       (context) =>
//                                                   [
//                                                     PopupMenuItem(
//                                                         value: 1,
//                                                         child: InkWell(
//                                                           onTap: () {
// //                                                                    network.requestPayment(network.user_id, bid_id);
// //                                                                    Navigator.pop(context);
//                                                           },
//                                                           child: Padding(
//                                                             padding: const EdgeInsets.all(8),
//                                                             child: Text('Project still pending'),
//                                                           ),
//                                                         )),
//                                                   ])),
//                                           Text(
//                                             '${DateFormat('MMM dd, y').format(DateTime.parse(snapshot.data[index].dateOpen))}',
//                                             style: TextStyle(
//                                                 color: Colors
//                                                     .black38),
//                                           )
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                                     : Container();

          ],
        ),
      ),

//
//       DefaultTabController(
//         length: 3,
//         initialIndex: 0,
//         child:  Container(
//           child: TabBarView(
//             children: [
//               FutureBuilder(
//                   future: network.getUndoneProject(context),
//                   builder: (context, snapshot) {
//                     return snapshot.hasData
//                         ? ListView(
//                         padding: EdgeInsets.only(top: 2),
//                         physics: ScrollPhysics(),
//                         shrinkWrap: true,
//                         children: [
//                           Column(children: [
//                             Container(
//                               height: 67,
//                               width: MediaQuery.of(context).size.width *
//                                   0.92,
//                               child: Card(
//                                 color: Color(0xFF9B049B),
//                                 child: Center(
//                                   child: FutureBuilder(
//                                     future: network
//                                         .getUserInfo(network.userId),
//                                     builder: (context, snapshot) {
//                                       return snapshot.data == null
//                                           ? RichText(
//                                           text: TextSpan(children: [
//                                             TextSpan(
//                                                 text:
//                                                 'Wallet  Balance ',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .bold,
//                                                     color: Colors
//                                                         .white)),
//                                             TextSpan(
//                                                 text: '₦0.00',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .bold,
//                                                     fontSize: 19,
//                                                     color: Colors
//                                                         .white)),
//                                           ]))
//                                           : RichText(
//                                           text: TextSpan(children: [
//                                             TextSpan(
//                                                 text:
//                                                 'Wallet  Balance ',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .bold,
//                                                     color: Colors
//                                                         .white)),
//                                             TextSpan(
//                                                 text:
//                                                 '₦${double.parse(snapshot.data['balance'].toString()).toStringAsFixed(2)}',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .bold,
//                                                     fontSize: 19,
//                                                     color: Colors
//                                                         .white)),
//                                           ]));
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             ListView.builder(
//                                 physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: snapshot.data.length,
//                                 padding: EdgeInsets.only(top: 2),
//                                 itemBuilder: (context, index) {
//                                   return snapshot.data[index].status ==
//                                       'pending'
//                                       ? Padding(
//                                     padding:
//                                     const EdgeInsets.only(
//                                         left: 20,
//                                         right: 20,
//                                         bottom: 14),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                             margin:
//                                             const EdgeInsets
//                                                 .only(
//                                                 top: 10),
//                                             height: 25,
//                                             child: Center(
//                                                 child: Text(
//                                                   '${snapshot.data[index].jobTitle}',
//                                                   style: TextStyle(
//                                                       color: Color(
//                                                           0xFF9B049B),
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .bold,
//                                                       fontSize: 9.5),
//                                                   textAlign: TextAlign
//                                                       .center,
//                                                 )),
//                                             width: 73,
//                                             decoration:
//                                             BoxDecoration(
//                                               borderRadius:
//                                               BorderRadius
//                                                   .circular(
//                                                   30),
//                                               color: Color(
//                                                   0xFFA40C85)
//                                                   .withOpacity(
//                                                   0.35),
//                                             )),
//                                         Padding(
//                                           padding:
//                                           const EdgeInsets
//                                               .only(
//                                               left: 10.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment
//                                                 .start,
//                                             children: [
//                                               Padding(
//                                                 padding:
//                                                 const EdgeInsets
//                                                     .only(
//                                                     bottom:
//                                                     4.0),
//                                                 child: Text(
//                                                     '${snapshot.data[index].jobDescription}'
//                                                         .isEmpty
//                                                         ? 'No Desription'
//                                                         : '${snapshot.data[index].jobDescription}',
//                                                     style: TextStyle(
//                                                         color: Colors
//                                                             .black)),
//                                               ),
//                                               Text(
//                                                   '${snapshot.data[index].status}',
//                                                   style: TextStyle(
//                                                       color: Colors
//                                                           .black,
//                                                       fontSize:
//                                                       13)),
//                                             ],
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .end,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment
//                                               .end,
//                                           children: [
//                                             Padding(
//                                                 padding:
//                                                 const EdgeInsets.only(
//                                                     bottom:
//                                                     3.0),
//                                                 child:
//                                                 PopupMenuButton(
//                                                     offset:
//                                                     const Offset(
//                                                         0,
//                                                         1),
//                                                     elevation:
//                                                     0.1,
//                                                     color: Color(
//                                                         0xFFF6F6F6),
//                                                     shape: RoundedRectangleBorder(
//                                                         borderRadius: BorderRadius.circular(
//                                                             5)),
//                                                     icon: Icon(
//                                                         FeatherIcons
//                                                             .moreHorizontal,
//                                                         color: Color(
//                                                             0xFF9B049B)),
//                                                     itemBuilder:
//                                                         (context) =>
//                                                     [
//                                                       PopupMenuItem(
//                                                           value: 1,
//                                                           child: InkWell(
//                                                             onTap: () {
// //                                                                    network.requestPayment(network.user_id, bid_id);
// //                                                                    Navigator.pop(context);
//                                                             },
//                                                             child: Padding(
//                                                               padding: const EdgeInsets.all(8),
//                                                               child: Text('Project still pending'),
//                                                             ),
//                                                           )),
//                                                     ])),
//                                             Text(
//                                               '${DateFormat('MMM dd, y').format(DateTime.parse(snapshot.data[index].dateOpen))}',
//                                               style: TextStyle(
//                                                   color: Colors
//                                                       .black38),
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                       : Container();
//                                 }),
//                           ]),
//                         ])
//                         : Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Theme(
//                               data: Theme.of(context).copyWith(
//                                   accentColor: Color(0xFF9B049B)),
//                               child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
//                                 strokeWidth: 2,
//                                 backgroundColor: Colors.white,
//                               )),
//                           Text(
//                             'Loading',
//                             style: TextStyle(
//                                 fontSize: 18, color: Colors.black38),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     );
//                   }),
//               DefaultTabController(
//                   length: 2,
//                   child: Scaffold(
//                       appBar: TabBar(
//                         unselectedLabelColor: Colors.black38,
//                         labelColor: Colors.black,
//                         indicatorColor: Color(0xFF9B049B),
//                         tabs: [
//                           Tab(
//                               child: Text('Ongoing Posted Job',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600))),
//                           Tab(
//                               child: Text('Ongoing Received Job',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600))),
//                         ],
//                       ),
//
// //
//                       body: TabBarView(children: [
//                         FutureBuilder(
//                             future: network.getUndoneProject(context),
//                             builder: (context, snapshot) {
//                               return snapshot.hasData
//                                   ? ListView(
//                                   padding: EdgeInsets.only(top: 2),
//                                   physics: ScrollPhysics(),
//                                   shrinkWrap: true,
//                                   children: [
//                                     Column(children: [
//                                       Container(
//                                         height: 67,
//                                         width: MediaQuery.of(context)
//                                             .size
//                                             .width *
//                                             0.92,
//                                         child: Card(
//                                           color: Color(0xFF9B049B),
//                                           child: Center(
//                                             child: FutureBuilder(
//                                               future:
//                                               network.getUserInfo(
//                                                   network.userId),
//                                               builder:
//                                                   (context, snapshot) {
//                                                 return snapshot.data ==
//                                                     null
//                                                     ? RichText(
//                                                     text: TextSpan(
//                                                         children: [
//                                                           TextSpan(
//                                                               text:
//                                                               'Wallet  Balance ',
//                                                               style: TextStyle(
//                                                                   fontWeight:
//                                                                   FontWeight.bold,
//                                                                   color: Colors.white)),
//                                                           TextSpan(
//                                                               text:
//                                                               '₦0.00',
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .bold,
//                                                                   fontSize:
//                                                                   19,
//                                                                   color:
//                                                                   Colors.white)),
//                                                         ]))
//                                                     : RichText(
//                                                     text: TextSpan(
//                                                         children: [
//                                                           TextSpan(
//                                                               text:
//                                                               'Wallet  Balance ',
//                                                               style: TextStyle(
//                                                                   fontWeight:
//                                                                   FontWeight.bold,
//                                                                   color: Colors.white)),
//                                                           TextSpan(
//                                                               text:
//                                                               '₦${double.parse(snapshot.data['balance'].toString()).toStringAsFixed(2)}',
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .bold,
//                                                                   fontSize:
//                                                                   19,
//                                                                   color:
//                                                                   Colors.white)),
//                                                         ]));
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       ListView.builder(
//                                           physics:
//                                           NeverScrollableScrollPhysics(),
//                                           shrinkWrap: true,
//                                           itemCount:
//                                           snapshot.data.length,
//                                           padding:
//                                           EdgeInsets.only(top: 2),
//                                           itemBuilder:
//                                               (context, index) {
//                                             return snapshot.data[index]
//                                                 .status ==
//                                                 'ongoing'
//                                                 ? Padding(
//                                               padding:
//                                               const EdgeInsets
//                                                   .only(
//                                                   left: 20,
//                                                   right: 20,
//                                                   bottom: 14),
//                                               child: Row(
//                                                 children: [
//                                                   Container(
//                                                       height: 25,
//                                                       child:
//                                                       Center(
//                                                           child:
//                                                           Text(
//                                                             '${snapshot.data[index].jobTitle}',
//                                                             style: TextStyle(
//                                                                 color: Color(
//                                                                     0xFF9B049B),
//                                                                 fontWeight: FontWeight
//                                                                     .bold,
//                                                                 fontSize:
//                                                                 9.5),
//                                                             textAlign:
//                                                             TextAlign
//                                                                 .center,
//                                                           )),
//                                                       width: 73,
//                                                       decoration:
//                                                       BoxDecoration(
//                                                         borderRadius:
//                                                         BorderRadius.circular(
//                                                             30),
//                                                         color: Color(
//                                                             0xFFA40C85)
//                                                             .withOpacity(
//                                                             0.35),
//                                                       )),
//                                                   Padding(
//                                                     padding: const EdgeInsets
//                                                         .only(
//                                                         left:
//                                                         10.0),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                       CrossAxisAlignment
//                                                           .start,
//                                                       children: [
//                                                         Padding(
//                                                           padding:
//                                                           const EdgeInsets.only(bottom: 4.0),
//                                                           child: Text(
//                                                               '${snapshot.data[index].jobDescription}'.isEmpty
//                                                                   ? 'No Desription'
//                                                                   : '${snapshot.data[index].jobDescription}',
//                                                               style:
//                                                               TextStyle(color: Colors.black)),
//                                                         ),
//                                                         Text(
//                                                             '${snapshot.data[index].status}',
//                                                             style: TextStyle(
//                                                                 color: Colors.black,
//                                                                 fontSize: 13)),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Spacer(),
//                                                   Column(
//                                                     children: [
//                                                       Padding(
//                                                           padding:
//                                                           const EdgeInsets.only(bottom: 3.0),
//                                                           child: PopupMenuButton(
//                                                               offset: const Offset(0, 1),
//                                                               elevation: 5,
//                                                               icon: Icon(
//                                                                 Icons.more_vert,
//                                                                 size: 22,
//                                                               ),
//                                                               itemBuilder: (context) => [
//                                                                 PopupMenuItem(
//                                                                   value: 1,
//                                                                   child: Padding(
//                                                                     padding: const EdgeInsets.all(8),
//                                                                     child: Text('Project is currently on going'),
//                                                                   ),
//                                                                 ),
//                                                               ])),
//                                                       Text(
//                                                         '${snapshot.data[index].dateOpen.toString().substring(0, 10)}',
//                                                         style: TextStyle(
//                                                             color:
//                                                             Colors.black38),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                                 : Container();
//                                           }),
//                                     ]),
//                                   ])
//                                   : Center(
//                                 child: Column(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.center,
//                                   children: [
//                                     Theme(
//                                         data: Theme.of(context)
//                                             .copyWith(
//                                             accentColor:
//                                             Color(0xFF9B049B)),
//                                         child:
//                                         CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
//                                           strokeWidth: 2,
//                                           backgroundColor: Colors.white,
//                                         )),
//                                     Text(
//                                       'Loading',
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           color: Colors.black38),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }),
//                         FutureBuilder(
//                             future: network.getBiddedJobs(context),
//                             builder: (context, snapshot) {
//                               return snapshot.hasData
//                                   ? ListView(
//                                   padding: EdgeInsets.only(top: 2),
//                                   physics: ScrollPhysics(),
//                                   shrinkWrap: true,
//                                   children: [
//                                     Column(children: [
//                                       Container(
//                                         height: 67,
//                                         width: MediaQuery.of(context)
//                                             .size
//                                             .width *
//                                             0.92,
//                                         child: Card(
//                                           color: Color(0xFF9B049B),
//                                           child: Center(
//                                             child: FutureBuilder(
//                                               future:
//                                               network.getUserInfo(
//                                                   network.userId),
//                                               builder:
//                                                   (context, snapshot) {
//                                                 return snapshot.data ==
//                                                     null
//                                                     ? RichText(
//                                                     text: TextSpan(
//                                                         children: [
//                                                           TextSpan(
//                                                               text:
//                                                               'Wallet  Balance ',
//                                                               style: TextStyle(
//                                                                   fontWeight:
//                                                                   FontWeight.bold,
//                                                                   color: Colors.white)),
//                                                           TextSpan(
//                                                               text:
//                                                               '₦0.00',
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .bold,
//                                                                   fontSize:
//                                                                   19,
//                                                                   color:
//                                                                   Colors.white)),
//                                                         ]))
//                                                     : RichText(
//                                                     text: TextSpan(
//                                                         children: [
//                                                           TextSpan(
//                                                               text:
//                                                               'Wallet  Balance ',
//                                                               style: TextStyle(
//                                                                   fontWeight:
//                                                                   FontWeight.bold,
//                                                                   color: Colors.white)),
//                                                           TextSpan(
//                                                               text:
//                                                               '₦${double.parse(snapshot.data['balance'].toString()).toStringAsFixed(2)}',
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .bold,
//                                                                   fontSize:
//                                                                   19,
//                                                                   color:
//                                                                   Colors.white)),
//                                                         ]));
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       ListView.builder(
//                                           physics:
//                                           NeverScrollableScrollPhysics(),
//                                           shrinkWrap: true,
//                                           itemCount:
//                                           snapshot.data.length,
//                                           padding:
//                                           EdgeInsets.only(top: 2),
//                                           itemBuilder:
//                                               (context, index) {
//                                             return snapshot.data[index]
//                                                 .status ==
//                                                 'ongoing'
//                                                 ? PopupMenuButton(
//                                                 offset: const Offset(0, 1),
//                                                 elevation: 5,
//                                                 child:     Padding(
//                                                   padding:
//                                                   const EdgeInsets
//                                                       .only(
//                                                       left: 20,
//                                                       right: 20,
//                                                       bottom: 14),
//                                                   child:  Row(
//                                                     children: [
//                                                       Container(
//                                                           height: 25,
//                                                           child:
//                                                           Center(
//                                                               child:
//                                                               Text(
//                                                                 '${snapshot.data[index].jobTitle}',
//                                                                 style: TextStyle(
//                                                                     color: Color(
//                                                                         0xFF9B049B),
//                                                                     fontWeight: FontWeight
//                                                                         .bold,
//                                                                     fontSize:
//                                                                     9.5),
//                                                                 textAlign:
//                                                                 TextAlign
//                                                                     .center,
//                                                               )),
//                                                           width: 73,
//                                                           decoration:
//                                                           BoxDecoration(
//                                                             borderRadius:
//                                                             BorderRadius.circular(
//                                                                 30),
//                                                             color: Color(
//                                                                 0xFFA40C85)
//                                                                 .withOpacity(
//                                                                 0.35),
//                                                           )),
//                                                       Padding(
//                                                         padding: const EdgeInsets
//                                                             .only(
//                                                             left:
//                                                             10.0),
//                                                         child: Column(
//                                                           children: [
//                                                             Column(
//                                                               crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                               children: [
//                                                                 Padding(
//                                                                   padding:
//                                                                   const EdgeInsets.only(bottom: 4.0),
//                                                                   child: Text(
//                                                                       '${snapshot.data[index].jobDescription}'.isEmpty
//                                                                           ? 'No Desription'
//                                                                           : '${snapshot.data[index].jobDescription}',
//                                                                       style:
//                                                                       TextStyle(color: Colors.black)),
//                                                                 ),
//                                                                 Text(
//                                                                     '${snapshot.data[index].status}',
//                                                                     style: TextStyle(
//                                                                         color: Colors.black,
//                                                                         fontSize: 13)),
//                                                               ],
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       Spacer(),
//                                                       Column(
//                                                         children: [
//                                                           Padding(
//                                                               padding:
//                                                               const EdgeInsets.only(bottom: 3.0),
//                                                               child: Icon(Icons.more_vert)),
//                                                           Text(
//                                                             '${snapshot.data[index].dateOpen.toString().substring(0, 10)}',
//                                                             style: TextStyle(
//                                                                 color:
//                                                                 Colors.black38),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 // icon: Icon(
//                                                 //   Icons.more_vert,
//                                                 //   size: 22,
//                                                 // ),
//                                                 itemBuilder: (context) => [
//                                                   PopupMenuItem(
//                                                       value: 1,
//                                                       child: InkWell(
//                                                         onTap: () {
//                                                           network.requestPayment(
//                                                               snapshot.data[index].sn.toString(),
//                                                               snapshot.data[index].projectBid.toString()
//
//                                                           ).then((value) {
//                                                             setState(() {
//                                                               print('done');
//                                                             });
//                                                           });
//                                                           Navigator.pop(context);
//                                                         },
//                                                         child: Padding(
//                                                           padding: const EdgeInsets.all(8),
//                                                           child: Text('Mark This Task as Completed'),
//                                                         ),
//                                                       )),
//                                                 ])
//                                                 : Container();
//                                           }),
//                                     ]),
//                                   ])
//                                   : Center(
//                                 child: Column(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.center,
//                                   children: [
//                                     Theme(
//                                         data: Theme.of(context)
//                                             .copyWith(
//                                             accentColor:
//                                             Color(0xFF9B049B)),
//                                         child:
//                                         CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
//                                           strokeWidth: 2,
//                                           backgroundColor: Colors.white,
//                                         )),
//                                     Text(
//                                       'Loading',
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           color: Colors.black38),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }),
//                       ]))),
//               DefaultTabController(
//                   length: 2,
//                   child: Scaffold(
//                       appBar: TabBar(
//                         unselectedLabelColor: Colors.black38,
//                         labelColor: Colors.black,
//                         indicatorColor: Color(0xFF9B049B),
//                         tabs: [
//                           Tab(
//                               child: Text('Completed Posted Job',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600))),
//                           Tab(
//                               child: Text('Completed Received Job',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600))),
//                         ],
//                       ),
//
// //
//                       body: TabBarView(children: [
//                         FutureBuilder(
//                             future: network.getUndoneProject(context),
//                             builder: (context, snapshot) {
//                               return snapshot.hasData
//                                   ? ListView(
//                                   padding: EdgeInsets.only(top: 2),
//                                   physics: ScrollPhysics(),
//                                   shrinkWrap: true,
//                                   children: [
//                                     Column(children: [
//                                       Container(
//                                         height: 67,
//                                         width: MediaQuery.of(context)
//                                             .size
//                                             .width *
//                                             0.92,
//                                         child: Card(
//                                           color: Color(0xFF9B049B),
//                                           child: Center(
//                                             child: FutureBuilder(
//                                               future:
//                                               network.getUserInfo(
//                                                   network.userId),
//                                               builder:
//                                                   (context, snapshot) {
//                                                 return snapshot.data ==
//                                                     null
//                                                     ? RichText(
//                                                     text: TextSpan(
//                                                         children: [
//                                                           TextSpan(
//                                                               text:
//                                                               'Wallet  Balance ',
//                                                               style: TextStyle(
//                                                                   fontWeight:
//                                                                   FontWeight.bold,
//                                                                   color: Colors.white)),
//                                                           TextSpan(
//                                                               text:
//                                                               '₦0',
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .bold,
//                                                                   fontSize:
//                                                                   19,
//                                                                   color:
//                                                                   Colors.white)),
//                                                         ]))
//                                                     : RichText(
//                                                     text: TextSpan(
//                                                         children: [
//                                                           TextSpan(
//                                                               text:
//                                                               'Wallet  Balance ',
//                                                               style: TextStyle(
//                                                                   fontWeight:
//                                                                   FontWeight.bold,
//                                                                   color: Colors.white)),
//                                                           TextSpan(
//                                                               text:
//                                                               '₦${snapshot.data['balance']}',
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .bold,
//                                                                   fontSize:
//                                                                   19,
//                                                                   color:
//                                                                   Colors.white)),
//                                                         ]));
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       ListView.builder(
//                                           physics:
//                                           NeverScrollableScrollPhysics(),
//                                           shrinkWrap: true,
//                                           itemCount:
//                                           snapshot.data.length,
//                                           padding:
//                                           EdgeInsets.only(top: 2),
//                                           itemBuilder:
//                                               (context, index) {
//                                             return snapshot.data[index]
//                                                 .status ==
//                                                 'completed'
//                                                 ? Padding(
//                                               padding:
//                                               const EdgeInsets
//                                                   .only(
//                                                   left: 20,
//                                                   right: 20,
//                                                   bottom: 14),
//                                               child: Row(
//                                                 children: [
//                                                   Container(
//                                                       height: 25,
//                                                       child:
//                                                       Center(
//                                                           child:
//                                                           Text(
//                                                             '${snapshot.data[index].jobTitle}',
//                                                             style: TextStyle(
//                                                                 color: Color(
//                                                                     0xFF9B049B),
//                                                                 fontWeight: FontWeight
//                                                                     .bold,
//                                                                 fontSize:
//                                                                 9.5),
//                                                             textAlign:
//                                                             TextAlign
//                                                                 .center,
//                                                           )),
//                                                       width: 73,
//                                                       decoration:
//                                                       BoxDecoration(
//                                                         borderRadius:
//                                                         BorderRadius.circular(
//                                                             30),
//                                                         color: Color(
//                                                             0xFFA40C85)
//                                                             .withOpacity(
//                                                             0.35),
//                                                       )),
//                                                   Padding(
//                                                     padding: const EdgeInsets
//                                                         .only(
//                                                         left:
//                                                         10.0),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                       CrossAxisAlignment
//                                                           .start,
//                                                       children: [
//                                                         Padding(
//                                                           padding:
//                                                           const EdgeInsets.only(bottom: 4.0),
//                                                           child: Text(
//                                                               '${snapshot.data[index].jobDescription}'.isEmpty
//                                                                   ? 'No Desription'
//                                                                   : '${snapshot.data[index].jobDescription}',
//                                                               style:
//                                                               TextStyle(color: Colors.black)),
//                                                         ),
//                                                         Text(
//                                                             '${snapshot.data[index].status}',
//                                                             style: TextStyle(
//                                                                 color: Colors.black,
//                                                                 fontSize: 13)),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Spacer(),
//                                                   Column(
//                                                     children: [
//                                                       Padding(
//                                                           padding:
//                                                           const EdgeInsets.only(bottom: 3.0),
//                                                           child: PopupMenuButton(
//                                                               offset: const Offset(0, 1),
//                                                               elevation: 5,
//                                                               icon: Icon(
//                                                                 Icons.more_vert,
//                                                                 size: 22,
//                                                               ),
//                                                               itemBuilder: (context) => [
//                                                                 PopupMenuItem(
//                                                                     value: 1,
//                                                                     child: InkWell(
//                                                                       onTap: () {
// //                                                                    network.requestPayment(network.user_id, bid_id);
// //                                                                    Navigator.pop(context);
//                                                                       },
//                                                                       child: Padding(
//                                                                         padding: const EdgeInsets.all(8),
//                                                                         child: Text('Project Has Been Completed'),
//                                                                       ),
//                                                                     )),
//                                                               ])),
//                                                       Text(
//                                                         '${snapshot.data[index].dateOpen.toString().substring(0, 10)}',
//                                                         style: TextStyle(
//                                                             color:
//                                                             Colors.black38),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                                 : Container();
//                                           }),
//                                     ]),
//                                   ])
//                                   : Center(
//                                 child: Column(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.center,
//                                   children: [
//                                     Theme(
//                                         data: Theme.of(context)
//                                             .copyWith(
//                                             accentColor:
//                                             Color(0xFF9B049B)),
//                                         child:
//                                         CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
//                                           strokeWidth: 2,
//                                           backgroundColor: Colors.white,
//                                         )),
//                                     Text(
//                                       'Loading',
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           color: Colors.black38),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }),
//                         FutureBuilder(
//                             future: network.getBiddedJobs(context),
//                             builder: (context, snapshot) {
//                               return snapshot.hasData
//                                   ? ListView(
//                                   padding: EdgeInsets.only(top: 2),
//                                   physics: ScrollPhysics(),
//                                   shrinkWrap: true,
//                                   children: [
//                                     Column(children: [
//                                       Container(
//                                         height: 67,
//                                         width: MediaQuery.of(context)
//                                             .size
//                                             .width *
//                                             0.92,
//                                         child: Card(
//                                           color: Color(0xFF9B049B),
//                                           child: Center(
//                                             child: FutureBuilder(
//                                               future:
//                                               network.getUserInfo(
//                                                   network.userId),
//                                               builder:
//                                                   (context, snapshot) {
//                                                 return snapshot.data ==
//                                                     null
//                                                     ? RichText(
//                                                     text: TextSpan(
//                                                         children: [
//                                                           TextSpan(
//                                                               text:
//                                                               'Wallet  Balance ',
//                                                               style: TextStyle(
//                                                                   fontWeight:
//                                                                   FontWeight.bold,
//                                                                   color: Colors.white)),
//                                                           TextSpan(
//                                                               text:
//                                                               '₦0',
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .bold,
//                                                                   fontSize:
//                                                                   19,
//                                                                   color:
//                                                                   Colors.white)),
//                                                         ]))
//                                                     : RichText(
//                                                     text: TextSpan(
//                                                         children: [
//                                                           TextSpan(
//                                                               text:
//                                                               'Wallet  Balance ',
//                                                               style: TextStyle(
//                                                                   fontWeight:
//                                                                   FontWeight.bold,
//                                                                   color: Colors.white)),
//                                                           TextSpan(
//                                                               text:
//                                                               '₦${snapshot.data['balance']}',
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .bold,
//                                                                   fontSize:
//                                                                   19,
//                                                                   color:
//                                                                   Colors.white)),
//                                                         ]));
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       ListView.builder(
//                                           physics:
//                                           NeverScrollableScrollPhysics(),
//                                           shrinkWrap: true,
//                                           itemCount:
//                                           snapshot.data.length,
//                                           padding:
//                                           EdgeInsets.only(top: 2),
//                                           itemBuilder:
//                                               (context, index) {
//                                             return snapshot.data[index]
//                                                 .status ==
//                                                 'completed'
//                                                 ? Padding(
//                                               padding:
//                                               const EdgeInsets
//                                                   .only(
//                                                   left: 20,
//                                                   right: 20,
//                                                   bottom: 14),
//                                               child: Row(
//                                                 children: [
//                                                   Container(
//                                                       height: 25,
//                                                       child:
//                                                       Center(
//                                                           child:
//                                                           Text(
//                                                             '${snapshot.data[index].jobTitle}',
//                                                             style: TextStyle(
//                                                                 color: Color(
//                                                                     0xFF9B049B),
//                                                                 fontWeight: FontWeight
//                                                                     .bold,
//                                                                 fontSize:
//                                                                 9.5),
//                                                             textAlign:
//                                                             TextAlign
//                                                                 .center,
//                                                           )),
//                                                       width: 73,
//                                                       decoration:
//                                                       BoxDecoration(
//                                                         borderRadius:
//                                                         BorderRadius.circular(
//                                                             30),
//                                                         color: Color(
//                                                             0xFFA40C85)
//                                                             .withOpacity(
//                                                             0.35),
//                                                       )),
//                                                   Padding(
//                                                     padding: const EdgeInsets
//                                                         .only(
//                                                         left:
//                                                         10.0),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                       CrossAxisAlignment
//                                                           .start,
//                                                       children: [
//                                                         Padding(
//                                                           padding:
//                                                           const EdgeInsets.only(bottom: 4.0),
//                                                           child: Text(
//                                                               '${snapshot.data[index].jobDescription}'.isEmpty
//                                                                   ? 'No Desription'
//                                                                   : '${snapshot.data[index].jobDescription}',
//                                                               style:
//                                                               TextStyle(color: Colors.black)),
//                                                         ),
//                                                         Text(
//                                                             '${snapshot.data[index].status}',
//                                                             style: TextStyle(
//                                                                 color: Colors.black,
//                                                                 fontSize: 13)),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Spacer(),
//                                                   Column(
//                                                     children: [
//                                                       Padding(
//                                                           padding:
//                                                           const EdgeInsets.only(bottom: 3.0),
//                                                           child: PopupMenuButton(
//                                                               offset: const Offset(0, 1),
//                                                               elevation: 5,
//                                                               icon: Icon(
//                                                                 Icons.more_vert,
//                                                                 size: 22,
//                                                               ),
//                                                               itemBuilder: (context) => [
//                                                                 PopupMenuItem(
//                                                                   value: 1,
//                                                                   child: Padding(
//                                                                     padding: const EdgeInsets.all(8),
//                                                                     child: Text('Congratulation you are done with this project'),
//                                                                   ),
//                                                                 ),
//                                                               ])),
//                                                       Text(
//                                                         '${snapshot.data[index].dateOpen.toString().substring(0, 10)}',
//                                                         style: TextStyle(
//                                                             color:
//                                                             Colors.black38),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                                 : Container();
//                                           }),
//                                     ]),
//                                   ])
//                                   : Center(
//                                 child: Column(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.center,
//                                   children: [
//                                     Theme(
//                                         data: Theme.of(context)
//                                             .copyWith(
//                                             accentColor:
//                                             Color(0xFF9B049B)),
//                                         child:
//                                         CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
//                                           strokeWidth: 2,
//                                           backgroundColor: Colors.white,
//                                         )),
//                                     Text(
//                                       'Loading',
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           color: Colors.black38),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }),
//                       ]))),
//             ],
//           ),
//         ),
//       ),
    );
  }


 Widget undoneProject(){
    var network = Provider.of<WebServices>(context, listen: false);
  return  FutureBuilder(
        future: network.getUndoneProject(context),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView(
              padding: EdgeInsets.only(top: 2),
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: [
                Column(children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF9B049B),
                    ),
                    margin: EdgeInsets.only(top: 10),
                    height: 50,
                    width:
                    MediaQuery.of(context).size.width * 0.89,
                    child: Center(
                      child: FutureBuilder(
                        future:
                        network.getUserInfo(network.userId),
                        builder: (context, snapshot) {
                          return snapshot.data == null
                              ? RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Wallet  Balance ',
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.white)),
                                TextSpan(
                                    text: '₦0.00',
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 19,
                                        color: Colors.white)),
                              ]))
                              : RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Wallet  Balance ',
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.white)),
                                TextSpan(
                                    text:
                                    '₦${double.parse(snapshot.data['balance'].toString()).toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 19,
                                        color: Colors.white)),
                              ]));
                        },
                      ),
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      padding: EdgeInsets.only(top: 2),
                      itemBuilder: (context, index) {
                        List<Project> sortedList = snapshot.data;
                        sorted() {
                          List<Project> pending = [];
                          List<Project> completed = [];
                          List<Project> ongoing = [];
                          for (var projects in sortedList) {
                            if (projects.status == 'pending') {
                              pending.add(projects);
                              print(pending.length);
                            } else if (projects.status ==
                                "completed") {
                              completed.add(projects);
                              print(completed.length);
                            } else if (projects.status ==
                                "ongoing") {
                              ongoing.add(projects);
                              print(ongoing.length);
                            }
                          }
                          // setState(() {
                          sortedList =
                              completed + ongoing + pending;
                          // });
                        }

                        isStatus ? sorted() : null;
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 10, right: 10),
                          child: InkWell(
                            onTap: () {
                              sortedList[index].status ==
                                  'ongoing' &&  sortedList[index].projectType!='posted'
                                  ? _completeTask(
                                  data: sortedList[index]):
                              sortedList[index].status ==
                                  'completed'?_completed(
                                  data: sortedList[index]):
                              _viewTask(
                                  data: sortedList[index]);
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.only(
                                          bottomLeft: Radius
                                              .circular(2),
                                          topLeft:
                                          Radius.circular(
                                              2)),
                                      color: sortedList[index]
                                          .status ==
                                          'pending'
                                          ? Color(0xFFFFBD00)
                                          : sortedList[index]
                                          .status ==
                                          'completed'
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    child: Text(''),
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(left: 14),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          6),
                                      color: Color(0xFFFFFFFF),
                                    ),
                                    height: 45,
                                    child: Column(
                                      children: [
                                        Text(
                                          '${DateFormat('dd').format(DateTime.parse(sortedList[index].dateOpen))}',
                                          style: TextStyle(
                                              color: Color(
                                                  0xFF6F6F6F),
                                              fontSize: 17.5,
                                              fontWeight:
                                              FontWeight
                                                  .bold),
                                        ),
                                        Text(
                                          '${DateFormat('MMM').format(DateTime.parse(sortedList[index].dateOpen))}',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                              fontWeight:
                                              FontWeight
                                                  .w400),
                                        ),
                                      ],
                                    ),
                                    width: 45,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        left: 15.0),
                                    child: Container(
                                      width:
                                      MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.5,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            '${sortedList[index].jobTitle}',
                                            style: TextStyle(
                                                color:
                                                Colors.black,
                                                fontWeight:
                                                FontWeight
                                                    .bold),
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow
                                                .ellipsis,
                                          ),
                                          Text(
                                            '${sortedList[index].jobDescription}'
                                                .isEmpty
                                                ? 'No Desription'
                                                : '${sortedList[index].jobDescription}',
                                            style: TextStyle(
                                                color:
                                                Colors.grey,
                                                fontSize: 13,
                                                fontWeight:
                                                FontWeight
                                                    .w400),
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow
                                                .ellipsis,
                                          ),
                                          Row(
                                            children: [
                                              sortedList[index].projectType=='posted'? Icon(Icons.verified,
                                                  size: 15,
                                                  color:Colors.blue):Icon(Icons.verified,
                                                  size: 15,
                                                  color:Colors.green),
                                              Text(
                                                sortedList[index].projectType=='posted'?'Posted Task':'Recieved Task',
                                                style: TextStyle(
                                                    color:
                                                    Colors.grey,
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight
                                                        .w400),
                                                maxLines: 1,
                                                softWrap: true,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                              ),
                                            ],
                                          ),
                                         // projectType
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        right: 19.0),
                                    child: Text(
                                      '${sortedList[index].status}',
                                      style: TextStyle(
                                          color: sortedList[index]
                                              .status ==
                                              'pending'
                                              ? Color(0xFFFFBD00)
                                              : sortedList[index]
                                              .status ==
                                              'completed'
                                              ? Colors.green
                                              : Colors.grey,
                                          fontSize: 13,
                                          fontWeight:
                                          FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(2),
                                color: Color(0xFFF6F6F6),
                              ),
                            ),
                          ),
                        );

//
                      }),
                ]),
              ])
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Theme(
                      data: Theme.of(context).copyWith(
                          accentColor: Color(0xFF9B049B)),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF9B049B)),
                        strokeWidth: 2,
                        backgroundColor: Colors.white,
                      )),
                  Text(
                    'Loading',
                    style: TextStyle(
                        fontSize: 18, color: Colors.black38),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        });
  }


  _viewTask({data}) {
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.55,
            color: Colors.transparent,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  color: Colors.transparent,
                  height: 100,
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.cancel,
                        size: 40,
                        color: Color(0xFFC7C7C7),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 55),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    color: Colors.black38,
                  ),
                  child: Text(''),
                ),
                Container(
                    margin: EdgeInsets.only(top: 60),
                    height: MediaQuery.of(context).size.height * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                      color: Colors.white,
                    ),
                    child: Container(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18, top: 18),
                            child: Text(
                              data.jobDescription.toString().isEmpty
                                  ? 'No Description'
                                  : '${data.jobDescription}'
                                      .capitalizeFirstOfEach,
                              style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 18,
                            ),
                            child: Text(
                              '${DateFormat('dd').format(DateTime.parse(data.dateOpen))} ${DateFormat('MMMM').format(DateTime.parse(data.dateOpen))}, ${DateFormat('yyyy').format(DateTime.parse(data.dateOpen))}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Divider(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 18, right: 18, top: 7),
                            child: Text('Service Provider:'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 18, right: 18, top: 7),
                            child: Row(
                              children: [
                                Stack(children: <Widget>[
                                  CircleAvatar(
                                    child: Text(''),
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      data.user.urlAvatar ==
                                                  'no_picture_upload' ||
                                          data.user.urlAvatar == null
                                          ? 'https://uploads.fixme.ng/thumbnails/no_picture_upload'
                                          : 'https://uploads.fixme.ng/thumbnails/${data.user.urlAvatar}',
                                    ),
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.white,
                                  ),
                                ]),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                              '${data.user.name} ${data.user.userLastName}'
                                                  .capitalizeFirstOfEach,
                                              style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          '${data.user.serviceArea}'.toUpperCase(),
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                            '${data.user.userRating}',
                                            style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Color(0xFFFC5302),
                                            size: 18,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            '(${data.user.reviews} reviews)',
                                            style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 16,
                                            ),
                                          ),
                                          // StarRating(
                                          //   rating: double.parse(
                                          //       widget.userData.userRating.toString()),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 18, right: 18, top: 5),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: FlatButton(
                                    onPressed: () {
                                      FirebaseApi.addUserChat(
                                        token2: data.user.fcmToken,
                                        token: data.user.fcmToken,
                                        recieveruserId2: network.userId,
                                        recieveruserId: data.user.id,
                                        serviceId: data.user.serviceId,
                                        serviceId2: network.serviceId,
                                        urlAvatar2:
                                            'https://uploads.fixme.ng/thumbnails/${network.profilePicFileName}',
                                        name2: network.firstName,
                                        idArtisan: network.mobileDeviceToken,
                                        artisanMobile: network.phoneNum,
                                        userMobile: data.user.userMobile,
                                        idUser: data.user.idUser,
                                        urlAvatar:
                                            'https://uploads.fixme.ng/thumbnails/${data.user.urlAvatar}',
                                        name: data.user.name,
                                      );

                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return ChatPage(
                                                user:  data.user);
                                          },
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
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
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 120, minHeight: 35.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Message",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  height: 35,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFFE9E9E9), width: 1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: FlatButton(
                                    disabledColor: Color(0x909B049B),
                                    onPressed: () async {
                                      await UrlLauncher.launch("tel://${data.user.fullNumber}");
                                    },
                                    // full_number
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 100, minHeight: 35.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Call",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        });
  }






  _completed({data}) {
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            color: Colors.transparent,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  color: Colors.transparent,
                  height: 100,
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.cancel,
                        size: 40,
                        color: Color(0xFFC7C7C7),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 55),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    color: Color(0xFFFFBD00),
                  ),
                  child: Text(''),
                ),
                Container(
                    margin: EdgeInsets.only(top: 60),
                    height: MediaQuery.of(context).size.height * 0.50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                      color: Colors.white,
                    ),
                    child: Container(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18, top: 18),
                            child: Text(
                              data.jobDescription.toString().isEmpty
                                  ? 'No Description'
                                  : '${data.jobDescription}'
                                  .capitalizeFirstOfEach,
                              style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 18,
                            ),
                            child: Text(
                              '${DateFormat('dd').format(DateTime.parse(data.dateOpen))} ${DateFormat('MMMM').format(DateTime.parse(data.dateOpen))}, ${DateFormat('yyyy').format(DateTime.parse(data.dateOpen))}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 18, right: 18, top: 5),
                            child:Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: FlatButton(
                                    onPressed: () {
                                      FirebaseApi.addUserChat(
                                        token2: data.user.fcmToken,
                                        token: data.user.fcmToken,
                                        recieveruserId2: network.userId,
                                        recieveruserId: data.user.id,
                                        serviceId: data.user.serviceId,
                                        serviceId2: network.serviceId,
                                        urlAvatar2:
                                        'https://uploads.fixme.ng/thumbnails/${network.profilePicFileName}',
                                        name2: network.firstName,
                                        idArtisan: network.mobileDeviceToken,
                                        artisanMobile: network.phoneNum,
                                        userMobile: data.user.userMobile,
                                        idUser: data.user.idUser,
                                        urlAvatar:
                                        'https://uploads.fixme.ng/thumbnails/${data.user.urlAvatar}',
                                        name: data.user.name,
                                      );

                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return ChatPage(
                                                user:  data.user);
                                          },
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
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
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 120, minHeight: 35.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Message",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  height: 35,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFFE9E9E9), width: 1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: FlatButton(
                                    disabledColor: Color(0x909B049B),
                                    onPressed: () async {
                                      await UrlLauncher.launch("tel://${data.user.fullNumber}");
                                    },
                                    // full_number
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 100, minHeight: 35.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Call",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Divider(),
                          ),
                          Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 7,
                                margin: const EdgeInsets.only(
                                    left: 18, right: 18, top: 25),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(colors: [
                                      Color(0xFF6f6f6f),
                                      Color(0xFFC4C4C4)
                                    ])),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    left: 18, right: 18, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Tab(
                                        icon: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                color: Color(0xFF6F6F6F),
                                                shape: BoxShape.circle),
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            )),
                                        text: 'Pending'),
                                    Tab(
                                        icon:  Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                color: Color(0xFF6F6F6F),
                                                shape: BoxShape.circle),
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            )),
                                        text: 'Started'),
                                    Tab(
                                        icon:  Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                color: Colors.orangeAccent,
                                                shape: BoxShape.circle),
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            )),
                                        text: 'Complete'),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Divider(),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18,
                              right: 18,
                            ),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Color(0xFF9B049B),
                              disabledColor: Color(0x909B049B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                      MediaQuery.of(context).size.width /
                                          1.3,
                                      minHeight: 45.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "COMPLETED",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          );
        });
  }





  _completeTask({data}) {
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            color: Colors.transparent,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  color: Colors.transparent,
                  height: 100,
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.cancel,
                        size: 40,
                        color: Color(0xFFC7C7C7),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 55),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    color: Color(0xFFFFBD00),
                  ),
                  child: Text(''),
                ),
                Container(
                    margin: EdgeInsets.only(top: 60),
                    height: MediaQuery.of(context).size.height * 0.50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                      color: Colors.white,
                    ),
                    child: Container(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18, top: 18),
                            child: Text(
                              data.jobDescription.toString().isEmpty
                                  ? 'No Description'
                                  : '${data.jobDescription}'
                                      .capitalizeFirstOfEach,
                              style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 18,
                            ),
                            child: Text(
                              '${DateFormat('dd').format(DateTime.parse(data.dateOpen))} ${DateFormat('MMMM').format(DateTime.parse(data.dateOpen))}, ${DateFormat('yyyy').format(DateTime.parse(data.dateOpen))}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 18, right: 18, top: 5),
                            child:Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: FlatButton(
                                    onPressed: () {
                                      FirebaseApi.addUserChat(
                                        token2: data.user.fcmToken,
                                        token: data.user.fcmToken,
                                        recieveruserId2: network.userId,
                                        recieveruserId: data.user.id,
                                        serviceId: data.user.serviceId,
                                        serviceId2: network.serviceId,
                                        urlAvatar2:
                                        'https://uploads.fixme.ng/thumbnails/${network.profilePicFileName}',
                                        name2: network.firstName,
                                        idArtisan: network.mobileDeviceToken,
                                        artisanMobile: network.phoneNum,
                                        userMobile: data.user.userMobile,
                                        idUser: data.user.idUser,
                                        urlAvatar:
                                        'https://uploads.fixme.ng/thumbnails/${data.user.urlAvatar}',
                                        name: data.user.name,
                                      );

                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return ChatPage(
                                                user:  data.user);
                                          },
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
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
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 120, minHeight: 35.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Message",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  height: 35,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFFE9E9E9), width: 1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: FlatButton(
                                    disabledColor: Color(0x909B049B),
                                    onPressed: () async {
                                      await UrlLauncher.launch("tel://${data.user.fullNumber}");
                                    },
                                    // full_number
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 100, minHeight: 35.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Call",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Divider(),
                          ),
                          Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 7,
                                margin: const EdgeInsets.only(
                                    left: 18, right: 18, top: 25),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(colors: [
                                      Color(0xFF6f6f6f),
                                      Color(0xFFC4C4C4)
                                    ])),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    left: 18, right: 18, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Tab(
                                        icon: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                color: Color(0xFF6F6F6F),
                                                shape: BoxShape.circle),
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            )),
                                        text: 'Pending'),
                                    Tab(
                                        icon: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFFBD00),
                                                shape: BoxShape.circle),
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            )),
                                        text: 'Started'),
                                    Tab(
                                        icon: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black26),
                                                shape: BoxShape.circle),
                                            child: Text('')),
                                        text: 'Complete'),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Divider(),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18,
                              right: 18,
                            ),
                            child: FlatButton(
                              onPressed: () {
                                network.loginSetState();
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                Navigator.pop(context);
                                setState(() {
                                  network.requestPayment(
                                      data.sn.toString(),
                                      data.projectBid.toString()).then((value){
                                        setState(() {
                                          undoneProject();
                                        });
                                  });
                                });
                              },
                              color: Color(0xFF9B049B),
                              disabledColor: Color(0x909B049B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width /
                                              1.3,
                                      minHeight: 45.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "TASK COMPLETED",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          );
        });
  }
}
