import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
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
    List<Notify> notify;
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: CustomScrollView(
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
                                transitionsBuilder:
                                    (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                            FirebaseApi.clearCheckNotify(
                              network.userId.toString(),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.chat,
                                  color: Color(0xFF9B049B),
                                  size: 25,
                                ),
                                StreamBuilder(
                                    stream: FirebaseApi.userCheckChatStream(
                                        network.userId.toString()),
                                    builder:
                                        (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        notify = snapshot.data.docs
                                            .map((doc) =>
                                            Notify.fromMap(doc.data(), doc.id))
                                            .toList();

                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return Positioned(
                                                left: 12,
                                                child: Container());
                                          default:
                                            if (snapshot.hasError) {
                                              return Positioned(
                                                  left: 12,
                                                  child: Container());
                                            } else {
                                              final users = notify;
                                              if (users.isEmpty || users == null) {
                                                return Positioned(
                                                    left: 12,
                                                    child: Container());
                                              } else {
                                                return   Positioned(
                                                    right: 14.4,
                                                    child: Icon(
                                                      Icons.circle,
                                                      color: Color(0xFF9B049B),
                                                      size: 12,
                                                    ));
                                              }
                                            }
                                        }
                                      } else {
                                        return Positioned(
                                            left: 12,
                                            child: Container());
                                      }
                                    }),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ])),
            backgroundColor: Colors.white,
            forceElevated: true,
            bottom: TabBar(
              unselectedLabelColor: Colors.black38,
              labelColor: Colors.black,
              indicatorColor: Color(0xFF9B049B),
              tabs: [
                Tab(
                  text: "Pending",
                ),
                Tab(text: "Started"),
                Tab(text: "Completed"),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              children: [
                FutureBuilder(
                    future: network.getUndoneProject(),
                    builder: (context, snapshot) {

                      return snapshot.hasData
                          ? ListView(
                          padding: EdgeInsets.only(top:2),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                        Column(children: [
                          Container(
                            height: 67,
                            width:
                            MediaQuery.of(context).size.width * 0.92,
                            child: Card(
                              color: Color(0xFF9B049B),
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
                                              text: '₦0',
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
                                              '₦${snapshot.data['balance']}',
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
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              padding: EdgeInsets.only(top:2),
                              itemBuilder: (context, index) {
                                return snapshot.data[index].status ==
                                    'pending'
                                    ? Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      bottom: 14),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 25,
                                          child: Center(
                                              child: Text(
                                                '${snapshot.data[index].jobTitle}',
                                                style: TextStyle(
                                                    color: Color(
                                                        0xFF9B049B),
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontSize: 9.5),
                                                textAlign: TextAlign
                                                    .center,
                                              )),
                                          width: 73,
                                          decoration:
                                          BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                30),
                                            color: Color(
                                                0xFFA40C85)
                                                .withOpacity(
                                                0.35),
                                          )),
                                      Padding(
                                        padding:
                                        const EdgeInsets
                                            .only(
                                            left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets
                                                  .only(
                                                  bottom:
                                                  4.0),
                                              child: Text(
                                                  '${snapshot.data[index].jobDescription}'.isEmpty?'No Desription': '${snapshot.data[index].jobDescription}',
                                                  style: TextStyle(
                                                      color:
                                                      Colors.black)),
                                            ),
                                            Text(
                                                '${snapshot.data[index].status}',
                                                style: TextStyle(
                                                    color: Colors
                                                        .black,
                                                    fontSize:
                                                    13)),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Column(
                                        children: [
                                          Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  bottom: 3.0),
                                              child: PopupMenuButton(
                                                  offset: const Offset(0, 1),
                                                  elevation: 5,
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    size: 22,
                                                  ),
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                        value: 1,
                                                        child: InkWell(
                                                          onTap: () {
//                                                                    network.requestPayment(network.user_id, bid_id);
//                                                                    Navigator.pop(context);
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8),
                                                            child: Text('Project Still Pending'),
                                                          ),
                                                        )),

                                                  ])
                                          ),
                                          Text(
                                            '${snapshot.data[index].dateOpen.toString().substring(0,10)}',
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                                    : Container();
                              }),
                        ]),
                      ])
                          : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Theme(
                                data: Theme.of(context).copyWith(
                                    accentColor: Color(0xFF9B049B)),
                                child: CircularProgressIndicator(
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
                      );
                    }),














                FutureBuilder(
                    future: network.getUndoneProject(),
                    builder: (context, snapshot) {

                      return snapshot.hasData
                          ? ListView(
                          padding: EdgeInsets.only(top:2),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Column(children: [
                              Container(
                                height: 67,
                                width:
                                MediaQuery.of(context).size.width * 0.92,
                                child: Card(
                                  color: Color(0xFF9B049B),
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
                                                  text: '₦0',
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
                                                  '₦${snapshot.data['balance']}',
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
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  padding: EdgeInsets.only(top:2),
                                  itemBuilder: (context, index) {
                                    return snapshot.data[index].status ==
                                        'ongoing'
                                        ? Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          bottom: 14),
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 25,
                                              child: Center(
                                                  child: Text(
                                                    '${snapshot.data[index].jobTitle}',
                                                    style: TextStyle(
                                                        color: Color(
                                                            0xFF9B049B),
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 9.5),
                                                    textAlign: TextAlign
                                                        .center,
                                                  )),
                                              width: 73,
                                              decoration:
                                              BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    30),
                                                color: Color(
                                                    0xFFA40C85)
                                                    .withOpacity(
                                                    0.35),
                                              )),
                                          Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                left: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      bottom:
                                                      4.0),
                                                  child: Text(
                                                      '${snapshot.data[index].jobDescription}'.isEmpty?'No Desription': '${snapshot.data[index].jobDescription}',
                                                      style: TextStyle(
                                                          color:
                                                          Colors.black)),
                                                ),
                                                Text(
                                                    '${snapshot.data[index].status}',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,
                                                        fontSize:
                                                        13)),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Column(
                                            children: [
                                              Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      bottom: 3.0),
                                                  child: PopupMenuButton(
                                                      offset: const Offset(0, 1),
                                                      elevation: 5,
                                                      icon: Icon(
                                                        Icons.more_vert,
                                                        size: 22,
                                                      ),
                                                      itemBuilder: (context) => [
                                                        PopupMenuItem(
                                                            value: 1,
                                                            child: InkWell(
                                                              onTap: () {
                                                                    network.requestPayment(network.userId, snapshot.data[index].sn);
                                                                    print(network.bearer);
                                                                    Navigator.pop(context);
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8),
                                                                child: Text('Request for payment'),
                                                              ),
                                                            )),

                                                      ])
                                              ),
                                          Text(
                                            '${snapshot.data[index].dateOpen.toString().substring(0,10)}',
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                        : Container();
                                  }),
                            ]),
                          ])
                          : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Theme(
                                data: Theme.of(context).copyWith(
                                    accentColor: Color(0xFF9B049B)),
                                child: CircularProgressIndicator(
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
                      );
                    }),













                FutureBuilder(
                    future: network.getUndoneProject(),
                    builder: (context, snapshot) {

                      return snapshot.hasData
                          ? ListView(
                          padding: EdgeInsets.only(top:2),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Column(children: [
                              Container(
                                height: 67,
                                width:
                                MediaQuery.of(context).size.width * 0.92,
                                child: Card(
                                  color: Color(0xFF9B049B),
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
                                                  text: '₦0',
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
                                                  '₦${snapshot.data['balance']}',
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
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  padding: EdgeInsets.only(top:2),
                                  itemBuilder: (context, index) {
                                    return snapshot.data[index].status ==
                                        'completed'
                                        ? Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          bottom: 14),
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 25,
                                              child: Center(
                                                  child: Text(
                                                    '${snapshot.data[index].jobTitle}',
                                                    style: TextStyle(
                                                        color: Color(
                                                            0xFF9B049B),
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 9.5),
                                                    textAlign: TextAlign
                                                        .center,
                                                  )),
                                              width: 73,
                                              decoration:
                                              BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    30),
                                                color: Color(
                                                    0xFFA40C85)
                                                    .withOpacity(
                                                    0.35),
                                              )),
                                          Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                left: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      bottom:
                                                      4.0),
                                                  child: Text(
                                                      '${snapshot.data[index].jobDescription}'.isEmpty?'No Desription': '${snapshot.data[index].jobDescription}',
                                                      style: TextStyle(
                                                          color:
                                                          Colors.black)),
                                                ),
                                                Text(
                                                    '${snapshot.data[index].status}',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,
                                                        fontSize:
                                                        13)),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Column(
                                            children: [
                                              Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      bottom: 3.0),
                                                  child: PopupMenuButton(
                                                      offset: const Offset(0, 1),
                                                      elevation: 5,
                                                      icon: Icon(
                                                        Icons.more_vert,
                                                        size: 22,
                                                      ),
                                                      itemBuilder: (context) => [
                                                        PopupMenuItem(
                                                            value: 1,
                                                            child: InkWell(
                                                              onTap: () {
//                                                                    network.requestPayment(network.user_id, bid_id);
//                                                                    Navigator.pop(context);
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8),
                                                                child: Text('Project Has Been Completed'),
                                                              ),
                                                            )),

                                                      ])
                                              ),
                                        Text(
                                            '${snapshot.data[index].dateOpen.toString().substring(0,10)}',
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                        : Container();
                                  }),
                            ]),
                          ])
                          : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Theme(
                                data: Theme.of(context).copyWith(
                                    accentColor: Color(0xFF9B049B)),
                                child: CircularProgressIndicator(
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
                      );
                    }),




              ],
            ),
          )
        ],
      ),
    );
  }
}
