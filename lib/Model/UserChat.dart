import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/Utils/utils.dart';




class UserChat {
  String id;
  final String idUser;
  final String name;
   var read;
   var block;
   var status;
  final String urlAvatar;
  final String docid;
   var lastMessageTime;
  final String lastMessage;
  final String userMobile;



  UserChat({
    this.id,
   this.name,
   this.idUser,
    this.block,
     this.read,
      this.status,
       this.urlAvatar,
       this.docid,
       this.lastMessage,
       this.userMobile,
       this.lastMessageTime,
       });

  UserChat.fromMap(Map snapshot,String id) :
        id = id ?? '',
        name = snapshot['name'] ?? '',
        read = snapshot['read'] ?? '',
        lastMessage = snapshot['lastMessage']?? '',
        lastMessageTime =  Utils.toDateTime(snapshot['lastMessageTime']),
        block = snapshot['block']?? '',
        idUser = snapshot['idUser']?? '',
        docid = snapshot['docid']?? '',
        urlAvatar = snapshot['urlAvatar']?? '',
        userMobile = snapshot['userMobile']??'',
        status =snapshot['status']??'';
        

  toJson() {
    return {
      "name": name,
      "read": read,
      'id': id,
      'lastMessage': lastMessage,
       'lastMessageTime': Utils.toDateTime(lastMessageTime),
       'block':block,
       'idUser':idUser,
       'docid':docid,
       'urlAvatar':urlAvatar,
        'userMobile':userMobile,
         'status':status,
    };
  }
}




