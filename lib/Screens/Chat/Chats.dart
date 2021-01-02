import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Model/User.dart';
import 'package:fixme/Model/UserChat.dart';
import 'package:fixme/Screens/Chat/Chat.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'FindSearchChat.dart';
import 'callscreens/listen_incoming_call.dart';

class ListenIncoming extends StatefulWidget {
  @override
  _ListenIncomingState createState() => _ListenIncomingState();
}

class _ListenIncomingState extends State<ListenIncoming> {
  PageController _myPage;
  @override
  void initState() {
    super.initState();
    _myPage = PageController(initialPage: 0, viewportFraction: 1, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Utils>(context, listen:false);
    var network = Provider.of<WebServices>(context, listen:false);
    Widget buildText(String text) => Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        );
List<UserChat> user;
    Widget widget = Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA40C85),
        title: Text('CHATS'),
        actions: [
          InkWell(
            onTap: (){
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
                  onTap: (){
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
            onTap:(){
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

              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 8),
                  Icon(Icons.search),
                  SizedBox(width: 8),
                  Text('Search messages'),
                  Spacer(),
                  InkWell(
                      onTap:data.isExpanded?(){
                        setState(() {data.onExpansionChanged(false);});
                      }:(){
                        setState(() {data.onExpansionChanged(true);});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left:10.0, right:10,top:5,
                        bottom:5
                        ),
                        child: Icon(FontAwesomeIcons.slidersH, size: 20,),
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
          data.isExpanded?Container(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                InkWell(
                  onTap:(){
                    _myPage.jumpToPage(0);
            },
                  child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      height: 25,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Color(0xFFEE5E5E5),
                          borderRadius: BorderRadius.circular(14)),
                      child: Center(child: Text('All'))),
                ),
                InkWell(
                  onTap:(){
                    _myPage.jumpToPage(1);
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      height: 25,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Color(0xFFEE5E5E5),
                          borderRadius: BorderRadius.circular(14)),
                      child: Center(child: Text('Unread'))),
                ),
                InkWell(
                  onTap:(){
                    _myPage.jumpToPage(2);
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      height: 25,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Color(0xFFEE5E5E5),
                          borderRadius: BorderRadius.circular(14)),
                      child: Center(child: Text('Read'))),
                ),
                Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    height: 25,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Color(0xFFEE5E5E5),
                        borderRadius: BorderRadius.circular(14)),
                    child: Center(child: Text('InMail'))),
              ]),
            ),
          ):Container(),
          Container(
              height: 0.35,
              width: double.infinity,
              color: Colors.black38,
              child: Text('')),
          Container(
            height: MediaQuery.of(context).size.height,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _myPage,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    stream: FirebaseApi.UserChatStream(network.mobile_device_token),
                    builder: (context, AsyncSnapshot<QuerySnapshot>  snapshot) {
                      if(snapshot.hasData) {
                        user = snapshot.data.docs
                                .map((doc) =>
                                    UserChat.fromMap(doc.data(), doc.id))
                                .toList();
                         List<UserChat> chat_data = [];
                        for (var v in user) {
                          chat_data.add(v);
                        }
                        chat_data..sort((b, a) => a.lastMessageTime.compareTo(b.lastMessageTime));
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                          
                              return buildText('Something Went Wrong Try later');
                            } else {
                              final users = chat_data;
                              if (users.isEmpty) {
                                return buildText('No Users Found');
                              } else
                                return Container(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var date = data
                                          .compareDate(users[index].lastMessageTime);
                                      return Container(
                                        height: 75,
                                        child: ListTile(
                                          onTap: () {
                                           // users[index].idUser
                                            FirebaseApi.updateUsertoRead(
                                              idUser:users[index].idUser,
                                             idArtisan:network.mobile_device_token);
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) {
                                                return ChatPage(user: users[index]);
                                              },
                                            ));
                                          },
                                          leading: CircleAvatar(
                                            radius: 25,
                                            backgroundImage:
                                            NetworkImage(users[index].urlAvatar),
                                          ),
                                          title: Text(users[index].name),
                                          subtitle: Text(
                                              users[index].lastMessage
                                                  .toString()
                                                  .isEmpty ||
                                                  users[index].lastMessage == null
                                                  ? 'No Message Yet'
                                                  : users[index].lastMessage, style:TextStyle(
                                                    color:  users[index].read?Colors.black54:Colors.black,
                                                    fontWeight: users[index].read?null:FontWeight.bold)),
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
                      }else{
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    stream:  FirebaseApi.UserChatStreamUnread(network.mobile_device_token),
                    builder: (context,  AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(snapshot.hasData) {
                               user = snapshot.data.docs
                                .map((doc) =>
                                    UserChat.fromMap(doc.data(), doc.id))
                                .toList();
                         List<UserChat> chat_data = [];
                        for (var v in user) {
                          chat_data.add(v);
                        }
                        chat_data..sort((b, a) => a.lastMessageTime.compareTo(b.lastMessageTime));
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return buildText('Something Went Wrong Try later');
                            } else {
                              final users = chat_data;
                              if (users.isEmpty) {
                                return buildText('No Users Found');
                              } else
                                return Container(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var date = data
                                          .compareDate(users[index].lastMessageTime);
                                      return Container(
                                        height: 75,
                                        child: ListTile(
                                          onTap: () {
                                             FirebaseApi.updateUsertoRead(
                                              idUser:users[index].idUser,
                                             idArtisan:network.mobile_device_token);
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) {
                                                return ChatPage(user: users[index]);
                                              },
                                            ));
                                          },
                                          leading: CircleAvatar(
                                            radius: 25,
                                            backgroundImage:
                                            NetworkImage(users[index].urlAvatar),
                                          ),
                                          title: Text(users[index].name),
                                          subtitle: Text(
                                              users[index].lastMessage
                                                  .toString()
                                                  .isEmpty ||
                                                  users[index].lastMessage == null
                                                  ? 'No Message Yet'
                                                  : users[index].lastMessage, style: TextStyle(
                                                    color:  users[index].read?Colors.black54:Colors.black,
                                                    fontWeight: users[index].read?null:FontWeight.bold)),
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
                      }else{
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    stream: FirebaseApi.UserChatStreamread(network.mobile_device_token),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(snapshot.hasData) {
                         user = snapshot.data.docs
                                .map((doc) =>
                                    UserChat.fromMap(doc.data(), doc.id))
                                .toList();
                        List<UserChat> chat_data = [];
                        for (var v in user) {
                          chat_data.add(v);
                        }
                        chat_data..sort((b, a) => a.lastMessageTime.compareTo(b.lastMessageTime));
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return buildText('Something Went Wrong Try later');
                            } else {
                              final users = chat_data;
                              if (users.isEmpty) {
                                return buildText('No Users Found');
                              } else
                                return Container(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var date = data
                                          .compareDate(users[index].lastMessageTime);
                                      return Container(
                                        height: 75,
                                        child: ListTile(
                                          onTap: () {
                                              FirebaseApi.updateUsertoRead(
                                              idUser:users[index].idUser,
                                             idArtisan:network.mobile_device_token);
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) {
                                                return ChatPage(user: users[index]);
                                              },
                                            ));
                                          },
                                          leading: CircleAvatar(
                                            radius: 25,
                                            backgroundImage:
                                            NetworkImage(users[index].urlAvatar),
                                          ),
                                          title: Text(users[index].name),
                                          subtitle: Text(
                                              users[index].lastMessage
                                                  .toString()
                                                  .isEmpty ||
                                                  users[index].lastMessage == null
                                                  ? 'No Message Yet'
                                                  : users[index].lastMessage,
                                                  
                                                  style: TextStyle(
                                                    color:  users[index].read?Colors.black54:Colors.black,
                                                    fontWeight: users[index].read?null:FontWeight.bold)),
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
                      }else{
                        return Center(child: CircularProgressIndicator());
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





