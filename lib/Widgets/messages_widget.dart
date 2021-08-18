import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Model/Message.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'message_widget.dart';


class MessagesWidget extends StatefulWidget {
  final String idUser;
  final user;

  const MessagesWidget({
    this.user,
    @required this.idUser,
    Key key,
  }) : super(key: key);


  @override
  _MessagesWidgetState createState() => _MessagesWidgetState();
}




class _MessagesWidgetState extends State<MessagesWidget> {
  var chats;
  @override
  void initState(){
    var network = Provider.of<WebServices>(context, listen: false);
    super.initState();
    chats = FirebaseApi.getMessages(widget.idUser, '${network.userId}-${widget.user.id}',
        '${widget.user.id}-${network.userId}');
  }


  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    return Container(
      child: StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Message> messageData;
          if (snapshot.hasData) {
            messageData = snapshot.data.docs
                .map((doc) => Message.fromMap(doc.data(), doc.id))
                .toList();
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: Theme(
                      data: Theme.of(context)
                          .copyWith(accentColor: Color(0xFF9B049B)),
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                        strokeWidth: 2,
                        backgroundColor: Colors.white,
                      )),
                );
              default:
                if (snapshot.hasError) {
                  return buildText('Something Went Wrong Try later');
                } else {
                  final messages = messageData;
                  if (messages.isEmpty) {
                    return buildText('Say Hi!');
                  } else
                    return  ListView.builder(
                      reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      //final message = messages;
                      return MessageWidget(
                        message: messages[index],
                        isMe: messages[index].idUser == network.mobileDeviceToken,
                      );
                    },
                    // optional
                    // floatingHeader: true, // optional
                  );

          // GroupedListView<dynamic, String>(
                    //   order: GroupedListOrder.ASC,
                    //   reverse: true,
                    //   elements: messages,
                    //   groupBy: (element) =>
                    //       Utils().formatYear(element.createdAt),
                    //   groupSeparatorBuilder: (String groupByValue) {
                    //     var date = new DateTime.now().toUtc();
                    //     var yesterday = Utils().formatYear(
                    //         DateTime(date.year, date.month, date.day - 1));
                    //     var today = Utils().formatYear(DateTime.now());
                    //     return Padding(
                    //       padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    //       child: Center(
                    //           child: Container(
                    //               height: 30,
                    //               width: double.infinity,
                    //               color: Color(0xFFEBEBEB),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.only(top: 6.0),
                    //                 child: Text(
                    //                   groupByValue == today
                    //                       ? 'TODAY'
                    //                       : groupByValue == yesterday
                    //                       ? 'YESTERDAY'
                    //                       : groupByValue,
                    //                   textAlign: TextAlign.center,
                    //                 ),
                    //               ))),
                    //     );
                    //   },
                    //   addAutomaticKeepAlives: true,
                    //
                    //   itemBuilder: (context, element) {
                    //     final message = element;
                    //     return MessageWidget(
                    //       message: message,
                    //       isMe: message.idUser == network.mobileDeviceToken,
                    //     );
                    //   },
                    //   // optional
                    //   floatingHeader: true, // optional
                    // );
                    //





                }
            }
          } else {
            return Center(
              child: Theme(
                  data: Theme.of(context)
                      .copyWith(accentColor: Color(0xFF9B049B)),
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                    strokeWidth: 2,
                    backgroundColor: Colors.white,
                  )),
            );
          }
        },
      ),
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
