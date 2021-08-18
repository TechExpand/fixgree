import 'package:bubble/bubble.dart';
import 'package:fixme/Model/Message.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Widgets/photoView.dart';
import 'package:fixme/Widgets/recordPlayer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageWidget({
    @required this.message,
    @required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment
                .start,
            children: <Widget>[
            if (!isMe)
        Padding(
        padding: const EdgeInsets.all(8.0), child: CircleAvatar(
    backgroundColor: Colors.white70,
    radius: 16, backgroundImage: NetworkImage(
    message.
    urlAvatar=='no_picture_upload'
    ?'https://uploads.fixme.ng/originals/no_picture_upload':
    message.urlAvatar
    )),
    ),
    !isMe
    ?
    Container(
      width: MediaQuery.of(context).size.width*0.7,
      child: Bubble(
          nip: BubbleNip.leftTop,
          color: Color(0xFF9B049B),
          child: buildMessageReceiver(context)),
    ):
    Container(
      width: MediaQuery.of(context).size.width*0.7,
      child: Bubble(
          nip: BubbleNip.rightTop,
          color: Color(0xFFEBEBEB),
          child: buildMessageSender(context)),
    )
    ,
    if(isMe)
    Padding(
    padding: const
    EdgeInsets.all(8.0),
    child: CircleAvatar
    (
    backgroundColor: Colors.white70,
    radius: 16
    , backgroundImage: NetworkImage(message.urlAvatar=='no_picture_upload'
    ?'https://uploads.fixme.ng/originals/no_picture_upload':
    message.urlAvatar
    )
    )
    ,
    )
    ,
    ]
    ,
    )
    ,
    );
  }


  Widget buildMessageReceiver(context) {
    var data = Provider.of<Utils>(context, listen: false);
    var datas = Provider.of<DataProvider>(context, listen: false);
//    var date = data
//        .formatTime(message.createdAt);
    var date =  data.compareDateChat(message.createdAt);
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        message.message.contains('https://') ||
            message.message.contains('http://')

            ? datas.categorizeUrl(message.message) == 'image'
            ? Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Hero(
            tag: message.message,
            child: GestureDetector(
              onTap: () {
                return Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return PhotoView(
                        message.message,
                        message.message,
                      );
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation,
                        child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child:Container(
                height: 170,
                width: 250,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Image.network(
                      message.message,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
            : datas.categorizeUrl(message.message) == 'audio'
            ? GestureDetector(
          onTap: () {
            return Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return AudioApp(kUrl: message.message, tag: message.message);
                },
                transitionsBuilder: (context, animation, secondaryAnimation,
                    child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Row(
            children: [
              Hero(
                  tag: message.message,
                  child: Icon(Icons.play_circle_filled, size: 35, color: Colors.white,)),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white,
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 5.0,
                  thumbShape:
                  RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Color(0xFFEBCDEB),
                  overlayColor: Colors.white,
                  overlayShape:
                  RoundSliderOverlayShape(overlayRadius: 15.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.white,
                  inactiveTickMarkColor: Colors.white,
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Color(0xFFEBCDEB),
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  value: 0,
                  onChanged: (double value) {

                  },
                  min: 0.0,
                  max: 10.0,
                ),
              ),
            ],
          ),

        )  :
        datas.categorizeUrl(message.message) == 'doc'
            ? InkWell(
               onTap: () {
                data.opeLink(message.message);
                          },
              child: Tab(
                text: 'Open this Document/Download',
                icon: Icon(FontAwesomeIcons.file , size: 40),
              )) : datas.categorizeUrl(message.message) == 'link'?
             Container(
          width: MediaQuery
              .of(context)
              .size
              .width / 1.3,
          child: InkWell(
             onTap: () {
                data.opeLink(message.message);
                          },
                      child: Text(
              message.message,
              style: TextStyle(
                  fontSize: 16,
                  color: isMe ? Colors.blue : Colors.blue),
              textAlign: isMe ? TextAlign.end : TextAlign.start,
            ),
          ),
        ) :Container():
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width / 1.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              message.productImage==null|| message.productImage.isEmpty?Container():Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Hero(
                  tag: message.message,
                  child: GestureDetector(
                    onTap: () {
                      return Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return PhotoView(
                              message.productImage,
                              message.productImage,
                            );
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation,
                              child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child:Container(
                      height: 170,
                      width: 250,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.network(
                            message.productImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                message.message,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    color: isMe ? Colors.white : Colors.white),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),

        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              height: 3,
              width: 3,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
              ),
            ),
            // Text(message.username),
            Text(date,style: TextStyle(color: Colors.white),),
          ],
        ),
      ],
    );
  }


  Widget buildMessageSender(context) {
    var data = Provider.of<Utils>(context, listen: false);
    var datas = Provider.of<DataProvider>(context, listen: false);
//    var date = data
//        .formatTime(message.createdAt);
    var date =  data.compareDateChat(message.createdAt);
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        message.message.contains('https://') ||
            message.message.contains('http://')

            ? datas.categorizeUrl(message.message) == 'image'
            ? Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Hero(
            tag: message.message,
            child: GestureDetector(
              onTap: () {
                return Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return PhotoView(
                        message.message,
                        message.message,
                      );
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation,
                        child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Container(
                height: 170,
                width: 250,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Image.network(
                      message.message,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
            : datas.categorizeUrl(message.message) == 'audio'
            ? GestureDetector(
          onTap: () {
            return Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return AudioApp(kUrl: message.message, tag: message.message);
                },
                transitionsBuilder: (context, animation, secondaryAnimation,
                    child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Row(
            children: [
              Hero(
                  tag: message.message,
                  child: Icon(Icons.play_circle_filled, size: 35,)),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color(0xFF9B049B),
                  inactiveTrackColor: Color(0xFF9B049B),
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 5.0,
                  thumbShape:
                  RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Color(0xFFEBCDEB),
                  overlayColor: Color(0xFF9B049B),
                  overlayShape:
                  RoundSliderOverlayShape(overlayRadius: 15.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Color(0xFF9B049B),
                  inactiveTickMarkColor: Color(0xFF9B049B),
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Color(0xFFEBCDEB),
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  value: 0,
                  onChanged: (double value) {

                  },
                  min: 0.0,
                  max: 10.0,
                ),
              ),
            ],
          ),

        ) :
        datas.categorizeUrl(message.message) == 'doc'
            ? InkWell(
               onTap: () {
                data.opeLink(message.message);
                          },
              child: Tab(
                text: 'Open this Document/Download',
                icon: Icon(FontAwesomeIcons.file , size: 40),
              )) : datas.categorizeUrl(message.message) == 'link'? Container(
          width: MediaQuery
              .of(context)
              .size
              .width / 1.3,
          child: InkWell(
             onTap: () {
                data.opeLink(message.message);
                          },
                      child: Text(
              message.message,
              style: TextStyle(
                  fontSize: 16,
                  color: isMe ? Colors.blue : Colors.blue),
              textAlign: isMe ? TextAlign.end : TextAlign.start,
            ),
          ),
        ) :Container(): Container(
          width: MediaQuery
              .of(context)
              .size
              .width / 1.3,
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              message.productImage==null|| message.productImage.isEmpty?Container():Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Hero(
                  tag: message.message,
                  child: GestureDetector(
                    onTap: () {
                      return Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return PhotoView(
                              message.productImage,
                              message.productImage,
                            );
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation,
                              child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child:Container(
                      height: 170,
                      width: 250,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.network(
                            message.productImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                message.message,
                style: TextStyle(
                  fontSize: 16,
                    fontFamily: 'Roboto',
                    color: isMe ? Colors.black87 : Colors.black87),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              height: 3,
              width: 3,
              decoration: BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle
              ),
            ),
            // Text(message.username),
            Text(date,style: TextStyle(color: Colors.black87), textAlign: TextAlign.end,),
          ],
        ),
      ],
    );
  }
}

