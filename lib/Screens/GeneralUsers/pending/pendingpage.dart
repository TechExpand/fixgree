import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class PendingScreen extends StatefulWidget {
  final scafoldKey;

  PendingScreen(this.scafoldKey);

  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  var search;

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    return CustomScrollView(
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          elevation: 2.5,
          shadowColor: Color(0xFFF1F1FD).withOpacity(0.5),
          title: Container(
              color: Colors.white,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        widget.scafoldKey.currentState.openDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Stack(children: <Widget>[
                          CircleAvatar(
                            child: Text(''),
                            radius: 19,
                            backgroundImage: NetworkImage(
                              network.profilePicFileName ==
                                          'no_picture_upload' ||
                                      network.profilePicFileName == null
                                  ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                  : 'https://uploads.fixme.ng/originals/${network.profilePicFileName}',
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white,
                          ),
                          Positioned(
                            left: 25,
                            top: 24,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFFDB5B04),
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 9, left: 1),
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 35,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return SearchPage();
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
                        },
                        child: TextFormField(
                            obscureText: true,
                            enabled: false,
                            style: TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              labelStyle: TextStyle(color: Colors.black38),
                              labelText: 'What are you looking for?',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black38, width: 0.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black38, width: 0.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black38, width: 0.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                            )),
                      ),
                    ),
                    InkWell(
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
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 8, right: 13),
                        child: Icon(
                          Icons.chat,
                          color: Color(0xFF9B049B),
                          size: 25,
                        ),
                      ),
                    ),
                  ])),
          backgroundColor: Colors.white,
          forceElevated: true,
        ),
        SliverFillRemaining(
          child: FutureBuilder(
              future: network.getUndoneProject(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                            Column(children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 20.0, bottom: 20.0),
                                height: 67,
                                width: MediaQuery.of(context).size.width * 0.92,
                                child: Card(
                                  color: Color(0xFF9B049B),
                                  child: Center(
                                    child: RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: 'Wallet  Balance ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      TextSpan(
                                          text: '₦19, 750',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19,
                                              color: Colors.white)),
                                    ])),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 14),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '22 july 2018',
                                          style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text('BALANCE N19, 750',
                                            style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 13,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    child: ListView.builder(
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return Slidable(
                                              actions: <Widget>[
                                                IconSlideAction(
                                                  color: Colors.red,
                                                  iconWidget: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('SERVICES',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text('REJECTED',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ],
                                                  ),
                                                  onTap: () => print('ddd'),
                                                ),
                                              ],
                                              secondaryActions: <Widget>[
                                                IconSlideAction(
                                                  color: Color(0xFF27AE60),
                                                  iconWidget: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('EXPENSES',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text('COMPLETED',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ],
                                                  ),
                                                  onTap: () => print('more'),
                                                ),
                                              ],
                                              actionPane:
                                                  SlidableDrawerActionPane(),
                                              actionExtentRatio: 0.25,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 14),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        height: 26,
                                                        child: Center(
                                                            child: Text(
                                                          '${snapshot.data[index]['job_title']}',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF9B049B),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 11),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                        width: 73,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color:
                                                              Color(0xFFA40C85)
                                                                  .withOpacity(
                                                                      0.35),
                                                        )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        4.0),
                                                            child: Text(
                                                                '${snapshot.data[index]['job_description']}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                          Text(
                                                              '${snapshot.data[index]['status']}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      13)),
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      TextSpan(
                                                          text: '- ',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 20,
                                                          )),
                                                      TextSpan(
                                                          text: 'N2, 200',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black87)),
                                                      TextSpan(
                                                          text: ' ↓',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.red)),
                                                    ])),
                                                  ],
                                                ),
                                              ));
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 14),
                                    child: Divider(),
                                  )
                                ],
                              ),
                            ]),
                          ])
                    : Center(
                        child: Text(
                          'No Project Found',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      );
              }),
        )
      ],
    );
  }
}
