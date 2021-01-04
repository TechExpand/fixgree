import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:fixme/Model/Message.dart';
import 'package:fixme/Screens/Chat/callscreens/call_screen_video.dart';
import 'package:fixme/Services/call_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'call_screen_audio.dart';

class PickupScreen extends StatefulWidget {
  final Message message;

  PickupScreen({
    @required this.message,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {

 @override
  void initState() {
    super.initState();
     FlutterRingtonePlayer.play(
  android: AndroidSounds.ringtone ,
  ios: IosSounds.glass,
  looping: true, // Android only - API >= 28
  volume: 1.0, // Android only - API >= 28
  asAlarm: false, // Android only - all APIs
);

  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen:false);
     var datas = Provider.of<CallApi>(context, listen: false);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 50),
            Image.network(
              widget.message.urlAvatar,
              width: 140,
              height: 140,
            ),
            SizedBox(height: 12),
            Text(
              widget.message.username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                   
                   
                    datas.deleteCallLogs(widget.message.idUser);
                   
                    FlutterRingtonePlayer.stop();
                    //  await callMethods.endCall(call: widget.call);  please edit this code to delete the document of the user
                  },
                  child: CircleAvatar(
                    backgroundColor:Colors.redAccent,
                    radius: 25,
                    child: Icon(Icons.call_end,
                      color: Colors.white,

                    ),
                  ),
                ),
                SizedBox(width: 40),
                InkWell(
                    onTap: () async {
                      FlutterRingtonePlayer.stop();
                      print(widget.message.idUser);
                       print(widget.message.idUser);
                        print(widget.message.idUser);
                       datas.updateCallStatus(widget.message.idUser, 'Connected');
                      widget.message.calltype == 'video'
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CallVideoPage(
                              role: ClientRole.Broadcaster,
                              channelName: widget.message.message,
                              idUser: widget.message.idUser,
                            ),
                          ))
                          : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CallAudioPage( 
                              urlAvatar: widget.message.urlAvatar,
                              role: ClientRole.Broadcaster,
                              channelName: widget.message.message,
                              idUser: widget.message.idUser,
                            ),
                          ));
                    },
                  child: CircleAvatar(
                    backgroundColor:Colors.green,
                    radius: 25,
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                     )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
