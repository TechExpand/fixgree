
import 'package:fixme/Model/Message.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'message_widget.dart';

class MessagesWidget extends StatelessWidget {
  final String idUser;
final   user;
  const MessagesWidget({
    this.user,
    @required this.idUser,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    var network = Provider.of<WebServices>(context, listen:false);
   return Container(
      child: StreamBuilder<List<Message>>(
        stream: FirebaseApi.getMessages(idUser,  '${network.firstName}-${user.name}',  '${user.name}-${network.firstName}'),
        builder: (context, snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                 /*  List chat_data = [];
                        for (var v in snapshot.data) {
                          chat_data.add(v);
                        }
                        chat_data..sort((b, a) => a.createdAt.compareTo(b.createdAt)); */
                final messages = snapshot.data;

                return messages.isEmpty
                    ? buildText('Say Hi..')
                    : ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                     
                    final message = messages[index];
                    return MessageWidget(
                      message: message,
                      isMe: message.idUser == network.mobile_device_token,
                    );
                  },
                );
              }
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
