import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:fixme/Model/Message.dart';
import 'package:fixme/Model/call.dart';
import 'package:fixme/Screens/Chat/callscreens/call_screen_audio.dart';
import 'package:fixme/Screens/Chat/callscreens/call_screen_video.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CallApi with ChangeNotifier {
  static Stream<List<Call>> getCAll() => FirebaseFirestore.instance
      .collection('call')
      .snapshots()
      .transform(Utils.transformer(Call.fromJson));

  Future uploadMessage(
      {String idUser, channelId, urlAvatar,urlAvatar2, username, context,calltype}) async {
  
    final refMessages =
        FirebaseFirestore.instance.collection('call');
    final newMessage = Message(
      idUser: idUser,
      urlAvatar: urlAvatar,
      username: username,
      message: channelId,
      createdAt: DateTime.now(),
      calltype: calltype,
    );
   
    await refMessages.doc(idUser).set(newMessage.toJson());
    await calltype=='video'?Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallVideoPage(
          idUser: idUser,
          channelName: channelId,
          role: ClientRole.Broadcaster,
        ),
      ),
    ):Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallAudioPage(
           urlAvatar: urlAvatar2,
          idUser: idUser,
          channelName: channelId,
          role: ClientRole.Broadcaster,
        ),
      ),
    );
  }

  Stream<List<Message>> getCallLogs(String idUser) {
   // SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = FirebaseFirestore.instance
        .collection('call').where('idUser', isEqualTo: idUser)
        .snapshots()
        .transform(Utils.transformer(Message.fromJson));
    return data;
  }

  Future deleteCallLogs(String idUser) async {
    FirebaseFirestore.instance
        .collection('call').doc(idUser).delete();
    return 'true';
  }
}
