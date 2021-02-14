import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Model/Notify.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/Chats.dart';
import 'package:fixme/Screens/GeneralUsers/Home/Search.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  var scafold_key;

  NotificationPage(this.scafold_key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  var search;

  List<Notify> notify;

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Utils>(context, listen: false);
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
                        widget.scafold_key.currentState.openDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Stack(children: <Widget>[
                          CircleAvatar(
                            child: Text(''),
                            radius: 19,
                            backgroundImage: NetworkImage(
                              network.profile_pic_file_name ==
                                          'no_picture_upload' ||
                                      network.profile_pic_file_name == null
                                  ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                  : 'https://uploads.fixme.ng/originals/${network.profile_pic_file_name}',
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
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Align(alignment: Alignment.topLeft, child: Text('Recent')),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder(
                  stream: FirebaseApi.UserNotificatioStream(
                      network.user_id.toString()),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      notify = snapshot.data.docs
                          .map((doc) => Notify.fromMap(doc.data(), doc.id))
                          .toList();

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {
                            return buildText('Something Went Wrong Try later');
                          } else {
                            final users = notify;
                            if (users.isEmpty) {
                              return buildText('No Notification Found');
                            } else
                              return Container(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var date = data
                                        .compareDate(users[index].createdAt);
                                    return Material(
                                      color: Colors.white,
                                      elevation: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        padding:
                                            EdgeInsets.only(top: 9, left: 9),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 3.0),
                                              child: Icon(
                                                Icons.person_pin,
                                                size: 36,
                                              ),
                                            ),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RichText(
                                                        text:
                                                            TextSpan(children: [
                                                          TextSpan(
                                                            text: users[index]
                                                                .message,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          TextSpan(
                                                              text:
                                                                  ' ${users[index].name.toString() == 'null null' ? '' : 'by ${users[index].name}'} ',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black87)),
                                                        ]),
                                                      ),
                                                      users[index].type ==
                                                              'new_bid'
                                                          ? InkWell(
                                                              onTap: () {
                                                                FirebaseApi.updateNotification(
                                                                        users[index]
                                                                            .id,
                                                                        'bided')
                                                                    .then(
                                                                        (value) {
                                                                  network.bidProject(
                                                                      network
                                                                          .user_id,
                                                                      users[index]
                                                                          .jobid,
                                                                      widget
                                                                          .scafold_key);
                                                                });
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
                                                                        'BID THIS JOB',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                Color(0xFFA40C85),
                                                                            fontWeight: FontWeight.w500))),
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Color(
                                                                            0xFFA40C85)),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4)),
                                                              ),
                                                            )
                                                          : users[index].type ==
                                                                  'bided'
                                                              ? Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              15,
                                                                          bottom:
                                                                              12),
                                                                  width: 105,
                                                                  height: 28,
                                                                  child: Center(
                                                                      child: Text(
                                                                          'JOB BIDDED',
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              color: Color(0xFFA40C85),
                                                                              fontWeight: FontWeight.w500))),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: Color(
                                                                              0xFFA40C85)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4)),
                                                                )
                                                              : users[index]
                                                                          .type ==
                                                                      'confirm'
                                                                  ? Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              15,
                                                                          bottom:
                                                                              12),
                                                                      width:
                                                                          105,
                                                                      height:
                                                                          28,
                                                                      child: Center(
                                                                          child: Text(
                                                                              'CONFIRMED',
                                                                              style: TextStyle(fontSize: 13, color: Color(0xFFA40C85), fontWeight: FontWeight.w500))),
                                                                      decoration: BoxDecoration(
                                                                          border:
                                                                              Border.all(color: Color(0xFFA40C85)),
                                                                          borderRadius: BorderRadius.circular(4)),
                                                                    )
                                                                  : users[index]
                                                                              .type ==
                                                                          'bid_approval'
                                                                      ? Text('')
                                                                      : InkWell(
                                                                          onTap:
                                                                              () {
                                                                            FirebaseApi.updateNotification(users[index].id, 'confirm').then((value) {
                                                                              network.confirmBudget(users[index].bidderId, users[index].bidId, widget.scafold_key);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 15, bottom: 12),
                                                                            width:
                                                                                105,
                                                                            height:
                                                                                28,
                                                                            child:
                                                                                Center(child: Text('CONFIRM', style: TextStyle(fontSize: 13, color: Color(0xFFA40C85), fontWeight: FontWeight.w500))),
                                                                            decoration:
                                                                                BoxDecoration(border: Border.all(color: Color(0xFFA40C85)), borderRadius: BorderRadius.circular(4)),
                                                                          ),
                                                                        )
                                                    ])),
                                            Container(
                                              width: 60,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 6.0),
                                                    child: Icon(
                                                      Icons.more_vert,
                                                      color: Colors.black38,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${date}',
                                                    style: TextStyle(
                                                        color: Colors.black38),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    );

//                                      Container(
//                                      height: 75,
//                                      child: ListTile(
//                                        onTap: () {
//                                          // users[index].idUser
////                                          FirebaseApi.updateUsertoRead(
////                                              idUser:users[index].idUser,
////                                              idArtisan:network.mobile_device_token);
//                                          Navigator.of(context)
//                                              .push(MaterialPageRoute(
//                                            builder: (context) {
//                                            //  return ChatPage(user: users[index]);
//                                            },
//                                          ));
//                                        },
//                                        leading: CircleAvatar(
//                                          radius: 25,
//                                          backgroundImage:
//                                          NetworkImage('users[index].urlAvatar'),
//                                        ),
//                                        title: Text(users[index].message),
//
//                                        trailing: Text('${users[index].createdAt.hour}:${users[index].createdAt.minute}'),
//                                        //  subtitle:  Text(users[index].lastMessageTime),
//                                      ),
//                                    );
                                  },
                                  itemCount: users.length,
                                ),
                              );
                          }
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ]),
          ),
        )
      ],
    );
  }

  Widget buildText(String text) => Center(
        child: Text(text,
            style: TextStyle(
                // letterSpacing: 4,
                color: Color(0xFF333333),
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      );
}
