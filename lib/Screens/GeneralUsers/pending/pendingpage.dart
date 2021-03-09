import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
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
    return DefaultTabController(
      length: 4,
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
                Tab(text: "Bids"),
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
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Container(
                              margin:
                              EdgeInsets.symmetric(horizontal: 10),
                              height: 67,
                              width: MediaQuery.of(context).size.width *
                                  0.92,
                              child: Card(
                                color: Color(0xFF9B049B),
                                child: Center(
                                  child: FutureBuilder(
                                    future: network
                                        .getUserInfo(network.userId),
                                    builder: (context, snapshot) {
                                      return snapshot.data == null
                                          ? RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                'Wallet  Balance ',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color:
                                                    Colors.white)),
                                            TextSpan(
                                                text: '₦0',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontSize: 19,
                                                    color:
                                                    Colors.white)),
                                          ]))
                                          : RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                'Wallet  Balance ',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color:
                                                    Colors.white)),
                                            TextSpan(
                                                text:
                                                '₦${snapshot.data['balance']}',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontSize: 19,
                                                    color:
                                                    Colors.white)),
                                          ]));
                                    },
                                  ),
                                ),
                              ),
                            ),
                            GroupedListView<dynamic, String>(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                elements: snapshot.data,
                                groupBy: (element) => element['date_oppened'],
                                groupComparator: (value1, value2) =>
                                    value1.compareTo(value2),
                                floatingHeader: true,
                                order: GroupedListOrder.DESC,
                                useStickyGroupSeparators: true,
                                groupSeparatorBuilder: (String value) =>
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, bottom: 14),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            value.toString().substring(0,10),
                                            style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 13,),
                                          ),

                                          FutureBuilder(
                                            future: network
                                                .getUserInfo(network.userId),
                                            builder: (context, snapshot) {
                                              return snapshot.data == null
                                                  ? Text('BALANCE N0',
                                                  style: TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 13,
                                                  ))
                                                  : Text(
                                                  'BALANCE N ${snapshot.data['balance']}',
                                                  style: TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 13,
                                                  ));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                itemBuilder: (context, element) {
                                  return  Slidable(
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
                                                      color: Colors
                                                          .white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text('REJECTED',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .white,
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
                                                      color: Colors
                                                          .white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                              Text('COMPLETED',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold))
                                            ],
                                          ),
                                          onTap: () =>
                                              print('more'),
                                        ),
                                      ],
                                      actionPane:
                                      SlidableDrawerActionPane(),
                                      actionExtentRatio: 0.25,
                                      child: Padding(
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
                                                      '${element['job_title']}',
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
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        bottom:
                                                        4.0),
                                                    child: Text(
                                                        '${element['job_description']}'.isEmpty?'No Desription': '${element['job_description']}',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black)),
                                                  ),
                                                  Text(
                                                      '${element['status']}',
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
                                                text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: '- ',
                                                          style:
                                                          TextStyle(
                                                            color: Colors
                                                                .red,
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
                                                              fontSize:
                                                              20,
                                                              color: Colors
                                                                  .red)),
                                                    ])),
                                          ],
                                        ),
                                      ))
                                     ;
                                }),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 14),
                              child: Divider(),
                            )
                          ])
                          : Center(
                        child: Text(
                          'No Project Found',
                          style: TextStyle(
                              fontSize: 18, color: Colors.black38),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
                FutureBuilder(
                    future: network.getUndoneProject(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListView(shrinkWrap: true, children: [
                        Column(children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 20.0, bottom: 20.0),
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
                                      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 13,
                                      ),
                                    ),
                                    FutureBuilder(
                                      future: network
                                          .getUserInfo(network.userId),
                                      builder: (context, snapshot) {
                                        return snapshot.data == null
                                            ? Text('BALANCE N0',
                                            style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 13,
                                            ))
                                            : Text(
                                            'BALANCE N ${snapshot.data['balance']}',
                                            style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 13,
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.55,
                                child: ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return snapshot.data[index]
                                      ['status'] ==
                                          'started'
                                          ? Slidable(
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
                                                          color: Colors
                                                              .white,
                                                          fontSize:
                                                          11,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold)),
                                                  Text('REJECTED',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize:
                                                          11,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold))
                                                ],
                                              ),
                                              onTap: () =>
                                                  print('ddd'),
                                            ),
                                          ],
                                          secondaryActions: <Widget>[
                                            IconSlideAction(
                                              color:
                                              Color(0xFF27AE60),
                                              iconWidget: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Text('EXPENSES',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize:
                                                          11,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold)),
                                                  Text('COMPLETED',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize:
                                                          11,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold))
                                                ],
                                              ),
                                              onTap: () =>
                                                  print('more'),
                                            ),
                                          ],
                                          actionPane:
                                          SlidableDrawerActionPane(),
                                          actionExtentRatio: 0.25,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 14),
                                            child: Row(
                                              children: [
                                                Container(
                                                    height: 29,
                                                    child: Center(
                                                        child: Text(
                                                          '${snapshot.data[index]['job_title']}',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF9B049B),
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize:
                                                              11),
                                                          textAlign:
                                                          TextAlign
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
                                                            '${snapshot.data[index]['job_description']}',
                                                            style: TextStyle(
                                                                color:
                                                                Colors.black)),
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
                                                    text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text: '- ',
                                                              style:
                                                              TextStyle(
                                                                color: Colors
                                                                    .red,
                                                                fontSize:
                                                                20,
                                                              )),
                                                          TextSpan(
                                                              text:
                                                              'N2, 200',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  color: Colors
                                                                      .black87)),
                                                          TextSpan(
                                                              text: ' ↓',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  20,
                                                                  color: Colors
                                                                      .red)),
                                                        ])),
                                              ],
                                            ),
                                          ))
                                          : Container();
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
                          style: TextStyle(
                              fontSize: 18, color: Colors.black38),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
                FutureBuilder(
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
                                width: MediaQuery.of(context).size.width *
                                    0.92,
                                child: Card(
                                  color: Color(0xFF9B049B),
                                  child: Center(
                                    child: FutureBuilder(
                                      future: network
                                          .getUserInfo(network.userId),
                                      builder: (context, snapshot) {
                                        return snapshot.data == null
                                            ? RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                  'Wallet  Balance ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      color: Colors
                                                          .white)),
                                              TextSpan(
                                                  text: '₦0',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontSize: 19,
                                                      color: Colors
                                                          .white)),
                                            ]))
                                            : RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                  'Wallet  Balance ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      color: Colors
                                                          .white)),
                                              TextSpan(
                                                  text:
                                                  '₦${snapshot.data['balance']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontSize: 19,
                                                      color: Colors
                                                          .white)),
                                            ]));
                                      },
                                    ),
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
                                          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                          style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 13,
                                          ),
                                        ),
                                        FutureBuilder(
                                          future: network.getUserInfo(
                                              network.userId),
                                          builder: (context, snapshot) {
                                            return snapshot.data == null
                                                ? Text('BALANCE N0',
                                                style: TextStyle(
                                                  color:
                                                  Colors.black38,
                                                  fontSize: 13,
                                                ))
                                                : Text(
                                                'BALANCE N ${snapshot.data['balance']}',
                                                style: TextStyle(
                                                  color:
                                                  Colors.black38,
                                                  fontSize: 13,
                                                ));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context)
                                        .size
                                        .height *
                                        0.55,
                                    child: ListView.builder(
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return snapshot.data[index]
                                          ['status'] ==
                                              'completed'
                                              ? Slidable(
                                              actions: <Widget>[
                                                IconSlideAction(
                                                  color: Colors.red,
                                                  iconWidget:
                                                  Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Text(
                                                          'SERVICES',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                              11,
                                                              fontWeight:
                                                              FontWeight.bold)),
                                                      Text(
                                                          'REJECTED',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                              11,
                                                              fontWeight:
                                                              FontWeight.bold))
                                                    ],
                                                  ),
                                                  onTap: () =>
                                                      print('ddd'),
                                                ),
                                              ],
                                              secondaryActions: <
                                                  Widget>[
                                                IconSlideAction(
                                                  color: Color(
                                                      0xFF27AE60),
                                                  iconWidget:
                                                  Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Text(
                                                          'EXPENSES',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                              11,
                                                              fontWeight:
                                                              FontWeight.bold)),
                                                      Text(
                                                          'COMPLETED',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                              11,
                                                              fontWeight:
                                                              FontWeight.bold))
                                                    ],
                                                  ),
                                                  onTap: () =>
                                                      print('more'),
                                                ),
                                              ],
                                              actionPane:
                                              SlidableDrawerActionPane(),
                                              actionExtentRatio: 0.25,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 14),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        height: 29,
                                                        child: Center(
                                                            child:
                                                            Text(
                                                              '${snapshot.data[index]['job_title']}',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF9B049B),
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize:
                                                                  11),
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                            )),
                                                        width: 73,
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
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
                                                          left:
                                                          10.0),
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
                                                                '${snapshot.data[index]['job_description']}',
                                                                style:
                                                                TextStyle(color: Colors.black)),
                                                          ),
                                                          Text(
                                                              '${snapshot.data[index]['status']}',
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.black,
                                                                  fontSize: 13)),
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    RichText(
                                                        text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                  text:
                                                                  '- ',
                                                                  style:
                                                                  TextStyle(
                                                                    color:
                                                                    Colors.red,
                                                                    fontSize:
                                                                    20,
                                                                  )),
                                                              TextSpan(
                                                                  text:
                                                                  'N2, 200',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Colors.black87)),
                                                              TextSpan(
                                                                  text:
                                                                  ' ↓',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      20,
                                                                      color:
                                                                      Colors.red)),
                                                            ])),
                                                  ],
                                                ),
                                              ))
                                              : Container();
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
                          style: TextStyle(
                              fontSize: 18, color: Colors.black38),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
                Text('gdgdg'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
