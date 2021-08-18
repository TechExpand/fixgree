import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixme/Model/UserChat.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/icons.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Chat.dart';
import 'FindSearchChat.dart';
import 'callscreens/listen_incoming_call.dart';

class ListenIncoming extends StatefulWidget {
  @override
  _ListenIncomingState createState() => _ListenIncomingState();
}

class _ListenIncomingState extends State<ListenIncoming> {
  int index = 0;
  PageController _myPage;
  @override
  void initState() {
    super.initState();
    _myPage =
        PageController(initialPage: 0, viewportFraction: 1, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Utils>(context, listen: false);

    var network = Provider.of<WebServices>(context, listen: false);
    Widget buildText(String text) => Padding(
      padding: const EdgeInsets.all(100.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.black38), textAlign: TextAlign.center,
      ),
    );
    List<UserChat> user;
    Widget widget = Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9B049B),
        title: Text('CHATS',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return SearchChatPage();
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
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return SearchChatPage();
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
                  child: Icon(FontAwesomeIcons.penSquare)),
            ),
          )
        ],
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
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
                          size: 20,
                        ),
                      )),
                ],
              ),
            ),
          ),
          Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.black38,
              child: Text('')),
          AnimatedContainer(
            color: Color(0xFFF6F6F6),
            duration: Duration(milliseconds: 400),
            height: data.isExpanded
                ? 50:0,
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                InkWell(
                  onTap: () {
                    _myPage.jumpToPage(0);
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      height: 25,
                      width: 50,
                      decoration: BoxDecoration(
                          color: index==0?Color(0xFFA40C85):Color(0xFFC4C4C4),
                          borderRadius: BorderRadius.circular(14)),
                      child: Center(child: Text('All',  style: TextStyle(color: index==0?Colors.white:Colors.black,)))),
                ),
                InkWell(
                  onTap: () {
                    _myPage.jumpToPage(1);
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      height: 25,
                      width: 80,
                      decoration: BoxDecoration(
                          color: index==1?Color(0xFFA40C85):Color(0xFFC4C4C4),
                          borderRadius: BorderRadius.circular(14)),
                      child: Center(child: Text('Unread',  style: TextStyle(color: index==1?Colors.white:Colors.black,)))),
                ),
                InkWell(
                  onTap: () {
                    _myPage.jumpToPage(2);
                  },
                  child: Container(

                      margin: EdgeInsets.only(left: 5, right: 5),
                      height: 25,
                      width: 80,
                      decoration: BoxDecoration(
                          color: index==2?Color(0xFFA40C85):Color(0xFFC4C4C4),
                          borderRadius: BorderRadius.circular(14)),
                      child: Center(child: Text('Read',  style: TextStyle(color: index==2?Colors.white:Colors.black,)))),
                ),
                Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    height: 25,
                    width: 70,
                    decoration: BoxDecoration(
                        color: index==3?Color(0xFFA40C85):Color(0xFFC4C4C4),
                        borderRadius: BorderRadius.circular(14)),
                    child: Center(child: Text('InMail', style: TextStyle(color: index==3?Colors.white:Colors.black,),))),
              ]),
            ),
          )
              ,
          Container(
              height: 0.35,
              width: double.infinity,
              color: Colors.black38,
              child: Text('')),
          Container(
            height: MediaQuery.of(context).size.height,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (value){
                setState(() {
                  index = value;
                });

              },
              controller: _myPage,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    stream:
                    FirebaseApi.userChatStream(network.mobileDeviceToken),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        user = snapshot.data.docs
                            .map((doc) => UserChat.fromMap(doc.data(), doc.id))
                            .toList();
                        List<UserChat> chatData = [];
                        for (var v in user) {
                          chatData.add(v);
                        }
                        chatData
                          ..sort((b, a) =>
                              a.lastMessageTime.compareTo(b.lastMessageTime));
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(accentColor: Color(0xFF9B049B)),
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                     strokeWidth: 2,
                                              backgroundColor: Colors.white,
)),);
                          default:
                            if (snapshot.hasError) {
                              return buildText(
                                  'Something Went Wrong Try later');
                            } else {
                              final users = chatData;
                              if (users.isEmpty) {
                                return buildText('No Users Found');
                              } else
                                return Container(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var date = data.compareDate(
                                          users[index].lastMessageTime);

                                      return Container(
                                        height: 75,
                                        child: ListTile(
                                          onTap: ()async {
                                            // users[index].idUser
                                            FirebaseApi.updateUsertoRead(
                                                idUser: users[index].idUser,
                                                idArtisan:
                                                network.mobileDeviceToken);
                                            print(users[index].idUser);
                                            print(users[index].idUser);




                                            if(users[index].fcmToken.toString() != data.fcmToken){
                                              FirebaseApi.updateUserFCMToken(
                                                idUser: users[index].idUser,
                                                idArtisan: network.mobileDeviceToken,
                                                token: data.fcmToken,
                                              );
                                            }


                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) {
                                                return ChatPage(
                                                    user: users[index]);
                                              },
                                            ));
                                          },
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.white,
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                users[index].urlAvatar),
                                          ),
                                          title: Text(users[index].name,maxLines: 1,
                                            overflow: TextOverflow.ellipsis,),
                                          subtitle: Text(
                                              users[index]
                                                  .lastMessage
                                                  .toString()
                                                  .isEmpty ||
                                                  users[index]
                                                      .lastMessage ==
                                                      null
                                                  ? 'No Message Yet'
                                                  : users[index].lastMessage,
                                              style: TextStyle(
                                                  color: users[index].read
                                                      ? Colors.black54
                                                      : Colors.black,
                                                  fontWeight: users[index].read
                                                      ? null
                                                      : FontWeight.bold),
                                          maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: Text(date),
                                          //  subtitle:  Text(users[index].lastMessageTime),
                                        ),
                                      );
                                    },
                                    itemCount: users.length,
                                  ),
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
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    stream: FirebaseApi.userChatStreamUnread(
                        network.mobileDeviceToken),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        user = snapshot.data.docs
                            .map((doc) => UserChat.fromMap(doc.data(), doc.id))
                            .toList();
                        List<UserChat> chatData = [];
                        for (var v in user) {
                          chatData.add(v);
                        }
                        chatData
                          ..sort((b, a) =>
                              a.lastMessageTime.compareTo(b.lastMessageTime));
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(accentColor: Color(0xFF9B049B)),
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                     strokeWidth: 2,
                                              backgroundColor: Colors.white,
)),);
                          default:
                            if (snapshot.hasError) {
                              return buildText(
                                  'Something Went Wrong Try later');
                            } else {
                              final users = chatData;
                              if (users.isEmpty) {
                                return buildText('No Users Found');
                              } else
                                return Container(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var date = data.compareDate(
                                          users[index].lastMessageTime);
                                      return Container(
                                        height: 75,
                                        child: ListTile(
                                          onTap: () async{
                                            FirebaseApi.updateUsertoRead(
                                                idUser: users[index].idUser,
                                                idArtisan:
                                                network.mobileDeviceToken);

                                            String  token = await FirebaseMessaging.instance.getToken();


                                            if(users[index].fcmToken.toString() != token){
                                              FirebaseApi.updateUserFCMToken(
                                                idUser: users[index].idUser,
                                                idArtisan: network.mobileDeviceToken,
                                                token: token,
                                              );
                                            }
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) {
                                                return ChatPage(
                                                    user: users[index]);
                                              },
                                            ));
                                          },
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.white,
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                users[index].urlAvatar),
                                          ),
                                          title: Text(users[index].name, maxLines: 1,
                                            overflow: TextOverflow.ellipsis,),
                                          subtitle: Text(
                                              users[index]
                                                  .lastMessage
                                                  .toString()
                                                  .isEmpty ||
                                                  users[index]
                                                      .lastMessage ==
                                                      null
                                                  ? 'No Message Yet'
                                                  : users[index].lastMessage,
                                              style: TextStyle(
                                                  color: users[index].read
                                                      ? Colors.black54
                                                      : Colors.black,
                                                  fontWeight: users[index].read
                                                      ? null
                                                      : FontWeight.bold),maxLines: 1,
                                            overflow: TextOverflow.ellipsis,),
                                          trailing: Text(date),
                                          //  subtitle:  Text(users[index].lastMessageTime),
                                        ),
                                      );
                                    },
                                    itemCount: users.length,
                                  ),
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
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    stream: FirebaseApi.userChatStreamread(
                        network.mobileDeviceToken),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        user = snapshot.data.docs
                            .map((doc) => UserChat.fromMap(doc.data(), doc.id))
                            .toList();
                        List<UserChat> chatData = [];
                        for (var v in user) {
                          chatData.add(v);
                        }
                        chatData
                          ..sort((b, a) =>
                              a.lastMessageTime.compareTo(b.lastMessageTime));
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(accentColor: Color(0xFF9B049B)),
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                     strokeWidth: 2,
                                              backgroundColor: Colors.white,
)),);
                          default:
                            if (snapshot.hasError) {
                              return buildText(
                                  'Something Went Wrong Try later');
                            } else {
                              final users = chatData;
                              if (users.isEmpty) {
                                return buildText('No Users Found');
                              } else
                                return Container(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var date = data.compareDate(
                                          users[index].lastMessageTime);
                                      return Container(
                                        height: 75,
                                        child: ListTile(
                                          onTap: () async{
                                            FirebaseApi.updateUsertoRead(
                                                idUser: users[index].idUser,
                                                idArtisan:
                                                network.mobileDeviceToken);


                                            String  token = await FirebaseMessaging.instance.getToken();


                                            if(users[index].fcmToken.toString() != token){
                                              FirebaseApi.updateUserFCMToken(
                                                idUser: users[index].idUser,
                                                idArtisan: network.mobileDeviceToken,
                                                token: token,
                                              );
                                            }
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) {
                                                return ChatPage(
                                                    user: users[index]);
                                              },
                                            ));
                                          },
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.white,
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                users[index].urlAvatar),
                                          ),
                                          title: Text(users[index].name,maxLines: 1,
                                            overflow: TextOverflow.ellipsis,),
                                          subtitle: Text(
                                              users[index]
                                                  .lastMessage
                                                  .toString()
                                                  .isEmpty ||
                                                  users[index]
                                                      .lastMessage ==
                                                      null
                                                  ? 'No Message Yet'
                                                  : users[index].lastMessage,
                                              style: TextStyle(
                                                  color: users[index].read
                                                      ? Colors.black54
                                                      : Colors.black,
                                                  fontWeight: users[index].read
                                                      ? null
                                                      : FontWeight.bold),maxLines: 1,
                                            overflow: TextOverflow.ellipsis,),
                                          trailing: Text(date),
                                          //  subtitle:  Text(users[index].lastMessageTime),
                                        ),
                                      );
                                    },
                                    itemCount: users.length,
                                  ),
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
              ],
            ),
          )
        ],
      ),
    );

    return PickupLayout(scaffold: widget);
  }
}
