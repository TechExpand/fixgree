import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fixme/Model/Message.dart';
import 'package:fixme/Model/User.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';


class FirebaseApi {
  static Stream<List<User>> getUsers() => FirebaseFirestore.instance
      .collection('users')
      .orderBy(UserField.lastMessageTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(User.fromJson));

  static Future uploadmessage(
      String idUser, String idArtisan, String message, context, chatId) async {
    var network = Provider.of<WebServices>(context, listen: false);
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$idUser/messages');
    final refMessages2 =
        FirebaseFirestore.instance.collection('chats/$idArtisan/messages');

    final newMessage = Message(
      chatId: chatId ?? '',
      idUser: network.mobile_device_token ?? '',
      urlAvatar:
          'https://uploads.fixme.ng/originals/${network.profile_pic_file_name}' ??
              '',
      username: network.firstName ?? '',
      message: message ?? '',
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());
    await refMessages2.add(newMessage.toJson());

    final refUsers = FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
    final refArtisan = FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
    await refArtisan.doc(idUser).update({
      UserField.lastMessageTime: DateTime.now(),
      'lastMessage': '$message',
      'read': false,
    });

    await refUsers.doc(idArtisan).update({
      UserField.lastMessageTime: DateTime.now(),
      'lastMessage': '$message',
      'read': false,
    });
  }

  static Future uploadImage(
      String idUser, idArtisan, message, context, chatId) async {
    var network = Provider.of<WebServices>(context, listen: false);
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$idUser/messages');
    final refMessages2 =
        FirebaseFirestore.instance.collection('chats/$idArtisan/messages');

    Reference storageReferenceImage = FirebaseStorage.instance
        .ref()
        .child('image/${Path.basename(message.path)}');

    UploadTask uploadTask = storageReferenceImage.putFile(File(message.path));
    uploadTask.then((res) {
      storageReferenceImage.getDownloadURL().then((imageurl) async {
        final newMessage = Message(
          chatId: chatId ?? '',
          idUser: network.mobile_device_token ?? '',
          urlAvatar: network.profile_pic_file_name ?? '',
          username: network.firstName ?? '',
          message: imageurl ?? '',
          createdAt: DateTime.now(),
        );

        refMessages.add(newMessage.toJson());
        await refMessages2.add(newMessage.toJson());
      });
    });

     Navigator.pop(context);

    final refUsers = FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
 final refArtisan = FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
    await refArtisan.doc(idUser).update({
      UserField.lastMessageTime: DateTime.now(),
      'lastMessage': 'A File',
      'read': false,
    });

    await refUsers.doc(idArtisan).update({
      UserField.lastMessageTime: DateTime.now(),
      'lastMessage': 'A File',
      'read': false,
    });
  }





  static Future uploadRecord(
      String idUser, idArtisan, message, context, chatId) async {
    var network = Provider.of<WebServices>(context, listen: false);
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$idUser/messages');
    final refMessages2 =
        FirebaseFirestore.instance.collection('chats/$idArtisan/messages');

    Reference storageReferenceImage = FirebaseStorage.instance
        .ref()
        .child('image/${Path.basename(message.path)}');

    UploadTask uploadTask = storageReferenceImage.putFile(File(message.path));
    uploadTask.then((res) {
      storageReferenceImage.getDownloadURL().then((imageurl) async {
        final newMessage = Message(
          chatId: chatId ?? '',
          idUser: network.mobile_device_token ?? '',
          urlAvatar: network.profile_pic_file_name ?? '',
          username: network.firstName ?? '',
          message: imageurl ?? '',
          createdAt: DateTime.now(),
        );

        refMessages.add(newMessage.toJson());
        await refMessages2.add(newMessage.toJson());
      });
    });
    final refUsers = FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
 final refArtisan = FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
    await refArtisan.doc(idUser).update({
      UserField.lastMessageTime: DateTime.now(),
      'lastMessage': 'A File',
      'read': false,
    });

    await refUsers.doc(idArtisan).update({
      UserField.lastMessageTime: DateTime.now(),
      'lastMessage': 'A File',
      'read': false,
    });
  }


  static Stream<List<Message>> getMessages(String idUser, chatId1, chatId2) =>
      FirebaseFirestore.instance
          .collection('chats/$idUser/messages')
          .where('chatId', whereIn: [chatId1,chatId2])
         .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));



static clearMessage(String idUser, chatId1, chatId2){
var documentReference = FirebaseFirestore.instance
          .collection('chats/$idUser/messages')
          .where('chatId', whereIn: [chatId1,chatId2]);

          documentReference .get().then((querySnapshot) {
  querySnapshot.docs.forEach((doc) {
 doc.reference.delete();
  });
});
}



  static Future addUserChat({
    idUser,
    name,
    urlAvatar,
    docid,
    idArtisan,
    name2,
    urlAvatar2,
    userMobile,
    artisanMobile,
  }) async {
    final refUsers = FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
   final refAritisan = FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
    await refUsers.doc(idUser).set({
      'chatid': idArtisan,
      'read': false,
      'idUser': idUser,
      'name': name,
      'block': false,
      'userMobile': userMobile ,
      'lastMessage': 'No Message yet',
      'urlAvatar': urlAvatar,
      'lastMessageTime': DateTime.now(),
    });
    await refAritisan.doc(idArtisan).set({
      'chatid': idUser,
      'read': false,
      'block': false,
      'idUser': idArtisan,
      'lastMessage': 'No Message yet',
      'name': name2,
      'userMobile': artisanMobile,
      'urlAvatar': urlAvatar2,
      'lastMessageTime': DateTime.now(),
    });
  }



 /*  static Stream<List<User>> SearchUserChatStream(chatid) => FirebaseFirestore.instance
      .collection('UserChat/$chatid/individual')
      .where('chatid', isEqualTo: chatid).where('')
      .snapshots()
      .transform(Utils.transformer(User.fromJson)); */




  static Stream<QuerySnapshot> UserChatStream(chatid) { 
    print(chatid);
    print(chatid);
    var data = FirebaseFirestore.instance
      .collection('UserChat/$chatid/individual')
      .where('chatid', isEqualTo: chatid);
      return data.snapshots();
  }


  static Stream<QuerySnapshot> UserChatStreamUnread(chatid){
    var data =  FirebaseFirestore.instance
          .collection('UserChat/$chatid/individual')
          .where('chatid', isEqualTo: chatid)
          .where('read', isEqualTo: false);
           return data.snapshots();
  }



  static Stream<QuerySnapshot> UserChatStreamread(chatid){
    var data =   FirebaseFirestore.instance
          .collection('UserChat/$chatid/individual')
          .where('chatid', isEqualTo: chatid)
          .where('read', isEqualTo: true);
           return data.snapshots();
  }



  static updateUsertoRead({
    String idUser,
    String idArtisan,
  }) async {
  
    final refUsers = FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
    await refUsers.doc(idUser).update({
      'read': true,
    });
  }

//  static Future uploadInMail(String idUser, String message, context) async {
//    var network = Provider.of<WebServices>(context, listen: false);
//    final refMessages =
//        FirebaseFirestore.instance.collection('inmail/$idUser/messages');
//
//    final newMessage = Message(
//      idUser: network.mobile_device_token ?? '',
//      urlAvatar: network.profile_pic_file_name ?? '',
//      username: network.firstName ?? '',
//      message: message ?? '',
//      createdAt: DateTime.now(),
//    );
//    await refMessages.add(newMessage.toJson());
//
//    final refUsers = FirebaseFirestore.instance.collection('UserChat');
//    await refUsers.doc(idUser).update(
//        {UserField.lastMessageTime: DateTime.now(), 'lastMessage': '$message'});
//  }
//
//  static Stream<List<Message>> getInMails(String idUser) =>
//      FirebaseFirestore.instance
//          .collection('inmails/$idUser/messages')
//          .orderBy(MessageField.createdAt, descending: true)
//          .snapshots()
//          .transform(Utils.transformer(Message.fromJson));
}
