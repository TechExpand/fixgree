import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:fixme/Model/Message.dart';
import 'package:fixme/Model/call.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/callscreens/call_screen_audio.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/callscreens/call_screen_video.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Utils/utils.dart';

class CallApi with ChangeNotifier {
  static Stream getCAll() => FirebaseFirestore.instance
      .collection('call')
      .snapshots();

  Future uploadMessage(
      {String idUser,
      channelId,
      callerId,
      urlAvatar,
      urlAvatar2,
      username,
      context,
      calltype}) async {
    final refMessages = FirebaseFirestore.instance.collection('call');
    final newMessage = Message(
      callStatus: 'Connecting',
      idUser: idUser,
      urlAvatar: urlAvatar,
      username: username,
      callerId: callerId,
      message: channelId,
      createdAt: DateTime.now(),
      calltype: calltype,
    );

    await refMessages.doc(idUser).set(newMessage.toJson());
    await calltype == 'video'
        ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallVideoPage(
                idUser: idUser,
                channelName: channelId,
                role: ClientRole.Broadcaster,
              ),
            ),
          )
        : Navigator.push(
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

  Stream<QuerySnapshot> getCallLogs(String idUser) {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = FirebaseFirestore.instance
        .collection('call')
        .where('idUser', isEqualTo: idUser)
        .snapshots();
    return data;
  }

  Stream<QuerySnapshot> getCallStatus(String idUser, idArtisan) {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = FirebaseFirestore.instance
        .collection('call')
        .where('idUser', isEqualTo: idUser)
        .where('callerId', isEqualTo: idArtisan)
        .snapshots();
    print(data);
    return data;
  }

  Stream<List<Message>> updateCallStatus(String idUser, String callStatus) {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = FirebaseFirestore.instance
        .collection('call')
        .doc(idUser)
        .update({'callStatus': callStatus});
  }

  Future deleteCallLogs(String idUser) async {
    FirebaseFirestore.instance.collection('call').doc(idUser).delete();
    return 'true';
  }
}
