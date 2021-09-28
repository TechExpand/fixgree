import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fixme/Model/Message.dart';
import 'package:fixme/Model/User.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';

class FirebaseApi {
  static Stream getUsers() => FirebaseFirestore.instance
      .collection('users')
      .orderBy(UserField.lastMessageTime, descending: true)
      .snapshots();

  static Future uploadmessage(
      String idUser, String idArtisan, String message, context, chatId,{productImage}) async {
    var network = Provider.of<WebServices>(context, listen: false);
    final refMessages =
    FirebaseFirestore.instance.collection('chats/$idUser/messages').doc();
    final refMessages2 =
    FirebaseFirestore.instance.collection('chats/$idArtisan/messages').doc();


final newMessage = {
  'productImage': productImage,
  'chatId': chatId ?? '',
  'idUser': network.mobileDeviceToken ?? '',
  'urlAvatar':
  'https://uploads.fixme.ng/thumbnails/${network.profilePicFileName}' ?? '',
  'username': network.firstName ?? '',
  'message': message ?? '',
  'createdAt': FieldValue.serverTimestamp()
};

    await refMessages.set(newMessage);

    await refMessages2.set(newMessage);

    final refUsers =
    FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
    final refArtisan =
    FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
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
      String idUser, idArtisan, message, context, chatId, file) async {
    var network = Provider.of<WebServices>(context, listen: false);
    final refMessages =
    FirebaseFirestore.instance.collection('chats/$idUser/messages').doc();
    final refMessages2 =
    FirebaseFirestore.instance.collection('chats/$idArtisan/messages').doc();

    Reference storageReferenceImage = FirebaseStorage.instance
        .ref()
        .child('image/${Path.basename(file?message.paths[0]:message.path)}');

    UploadTask uploadtask =  storageReferenceImage.putFile(File(file?message.paths[0]:message.path));
    uploadtask.then((res){
     storageReferenceImage.getDownloadURL().then((imageurl) async {
       final newMessage = {
         'chatId': chatId ?? '',
         'idUser': network.mobileDeviceToken ?? '',
         'urlAvatar': 'https://uploads.fixme.ng/thumbnails/${network
             .profilePicFileName}' ?? '',
         'username': network.firstName ?? '',
         'message': imageurl ?? '',
         'createdAt': FieldValue.serverTimestamp(),
       };

       refMessages.set(newMessage);
       await refMessages2.set(newMessage);
     });
   });


    final refUsers =
    FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
    final refArtisan =
    FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
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
    FirebaseFirestore.instance.collection('chats/$idUser/messages').doc();
    final refMessages2 =
    FirebaseFirestore.instance.collection('chats/$idArtisan/messages').doc();

    Reference storageReferenceImage = FirebaseStorage.instance
        .ref()
        .child('image/${Path.basename(message.path)}');

    UploadTask uploadTask =  storageReferenceImage.putFile(File(message.path));
    uploadTask.then((res) {
      storageReferenceImage.getDownloadURL().then((imageurl) async {
        final newMessage = {
          'chatId': chatId ?? '',
          'idUser': network.mobileDeviceToken ?? '',
          'urlAvatar':'https://uploads.fixme.ng/thumbnails/${network.profilePicFileName}' ?? '',
          'username': network.firstName ?? '',
          'message': imageurl ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        };

        refMessages.set(newMessage);
        await refMessages2.set(newMessage);
      });
    });

    final refUsers =
    FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
    final refArtisan =
    FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
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

  static Stream<QuerySnapshot> getMessages(String idUser, chatId1, chatId2) =>
      FirebaseFirestore.instance
          .collection('chats/$idUser/messages')
          .where('chatId', whereIn: [chatId1, chatId2])
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots();
          // .transform(Utils.transformer(Message.fromJson));

  static clearMessage(String idUser, chatId1, chatId2) {
    var documentReference = FirebaseFirestore.instance
        .collection('chats/$idUser/messages')
        .where('chatId', whereIn: [chatId1, chatId2]);

    documentReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  static clearJobBids(String id) {
    var documentReference = FirebaseFirestore.instance
        .collection('JOB_BIDS')
        .where('project_owner_user_id', isEqualTo: id);

    documentReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.data().toString().contains('bidder_name'));
        if(doc.data().toString().contains('bidder_name') == true){
          doc.reference.delete();
        }
      });
    });
  }

  static clearSingleJobBids(String docid) {
    FirebaseFirestore.instance
        .collection('JOB_BIDS').doc(docid).delete();
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
    serviceId,
    serviceId2,
    recieveruserId2,
    recieveruserId,
    artisanMobile,
    token,
    token2,
  }) async {
    final refUsers =
    FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
    final refAritisan =
    FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
    await refUsers.doc(idUser).set({
//      'bid_id': bidData.bid_id ?? '',
//      'project_id': bidData.job_id ?? '',
//      'project_owner_user_id': bidData.project_owner_user_id ?? '',
//      'service_id': bidData.service_id ?? '',
      'chatid': idArtisan,
      'read': false,
      'idUser': idUser,
      'name': name,
       'token': token,
       'serviceId': serviceId ?? '',
       'recieveruserId': recieveruserId,
      'block': false,
      'userMobile': userMobile,
      'lastMessage': 'No Message yet',
      'urlAvatar': urlAvatar,
      'lastMessageTime': DateTime.now(),
    });
    await refAritisan.doc(idArtisan).set({
//      'bid_id': bidData.bid_id ?? '',
//      'project_id': bidData.job_id ?? '',
//      'project_owner_user_id': bidData.project_owner_user_id ?? '',
//      'service_id': bidData.service_id ?? '',
      'chatid': idUser,
      'read': false,
      'block': false,
      'idUser': idArtisan,
      'serviceId': serviceId2 ?? '',
      'lastMessage': 'No Message yet',
      'name': name2,
      'recieveruserId': recieveruserId2,
       'token': token2,
      'userMobile': artisanMobile,
      'urlAvatar': urlAvatar2,
      'lastMessageTime': DateTime.now(),
    });
  }




  static Future addUserBidChat({
    token,
    token2,
    bidData,
    idUser,
    name,
    urlAvatar,
    docid,
    recieveruserId2,
    recieveruserId,
    serviceId,
    serviceId2,
    idArtisan,
    name2,
    urlAvatar2,
    userMobile,
    artisanMobile,
  }) async {
    final refUsers =
    FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
    final refAritisan =
    FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
    await refUsers.doc(idUser).set({
      'bid_id': bidData.bid_id ?? '',
      'project_id': bidData.job_id ?? '',
      'project_owner_user_id': bidData.project_owner_user_id ?? '',
      'service_id': bidData.service_id ?? '',
      'chatid': idArtisan,
      'read': false,
      'idUser': idUser,
      'name': name,
      'serviceId': serviceId ?? '',
      'token': token,
      'recieveruserId':recieveruserId,
      'block': false,
      'userMobile': userMobile,
      'lastMessage': 'No Message yet',
      'urlAvatar': urlAvatar,
      'lastMessageTime': DateTime.now(),
    });
    await refAritisan.doc(idArtisan).set({
      'bid_id': bidData.bid_id ?? '',
      'project_id': bidData.job_id ?? '',
      'project_owner_user_id': bidData.project_owner_user_id ?? '',
      'service_id': bidData.service_id ?? '',
      'chatid': idUser,
      'read': false,
       'token': token2,
       'recieveruserId': recieveruserId2,
      'block': false,
      'serviceId': serviceId ?? '',
      'idUser': idArtisan,
      'lastMessage': 'No Message yet',
      'name': name2,
      'userMobile': artisanMobile,
      'urlAvatar': urlAvatar2,
      'lastMessageTime': DateTime.now(),
    });
  }



  static Stream<QuerySnapshot> userChatStream(chatid) {
    print(chatid);
    print(chatid);
    var data = FirebaseFirestore.instance
        .collection('UserChat/$chatid/individual')
        .where('chatid', isEqualTo: chatid);
    return data.snapshots();
  }

  static Stream<QuerySnapshot> userNotificatioStream(id) {
    var data = FirebaseFirestore.instance
        .collection('Notification')
        .where('userid', isEqualTo: id).orderBy('createdAt', descending: true);
    return data.snapshots();
  }

  static Stream<QuerySnapshot> userCheckNotifyStream(id) {
    var data = FirebaseFirestore.instance
        .collection('CheckNotify')
        .where('userid', isEqualTo: id);
    return data.snapshots();
  }


  static clearCheckNotify(String id) {
    var documentReference = FirebaseFirestore.instance
        .collection('CheckNotify')
        .where('userid' , isEqualTo: id);

    documentReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }



  static Stream<QuerySnapshot> userCheckChatStream(id) {
    var data = FirebaseFirestore.instance
        .collection('CheckChat')
        .where('userid', isEqualTo: id);
    return data.snapshots();
  }


  static clearCheckChat(String id) {
    var documentReference = FirebaseFirestore.instance
        .collection('CheckChat')
        .where('userid' , isEqualTo: id);

    documentReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }


  static Stream<QuerySnapshot> userBidStream(id) {
    var data = FirebaseFirestore.instance
        .collection('JOB_BIDS')
        .where('project_owner_user_id', isEqualTo: id);
    return data.snapshots();
  }


  static Future uploadCheckNotify(
      String id,) async {
    final refMessages = FirebaseFirestore.instance.collection('CheckNotify');

    await refMessages.doc().set({
      'userid': id,
      'createdAt': DateTime.now(),
    });
  }

  static Future uploadCheckChat(
      String id,) async {
    final refMessages = FirebaseFirestore.instance.collection('CheckChat');

    await refMessages.doc().set({
      'userid': id,
      'createdAt': DateTime.now(),
    });
  }



  static Future uploadNotification(
      String id, String message,
      type, name, jobId, bidId,
      bidderId, artisanId, budget,invoiceId, serviceId) async {
    final refMessages = FirebaseFirestore.instance.collection('Notification');

    await refMessages.doc().set({
      'userid': id,
      'message': message,
      'jobId': jobId,
      'type': type,
      'name': name,
      'artisanId': artisanId,
      'bidded': 'bid',
      'bidderId': bidderId ?? '',
      'bidId': bidId ?? '',
      'invoice_id': invoiceId??'',
      'servicerequestId':serviceId??'',
      'budget': budget??'',
      'createdAt': DateTime.now(),
    });
  }




  static Future sendJobCompleted({
      String jobid, String bidder_id,
    project_owner_user_id, bidid, serviceId, message}) async {
    final refMessages = FirebaseFirestore.instance.collection('JOB_BIDS');

    await refMessages.doc().set({
      'job_id': jobid,
      'project_owner_user_id': project_owner_user_id,
      'bidder_id': bidder_id,
      'bid_id': bidid,
      'service_id': serviceId,
      'message':message,
    });
  }




  static Future deleteNotification(String id) async {
    final refMessages = FirebaseFirestore.instance.collection('Notification');
    await refMessages.doc(id).delete();
  }

  static Future updateNotification(String id, message) async {
    final refMessages = FirebaseFirestore.instance.collection('Notification');

    await refMessages.doc(id).update({
      'type': message,
      'createdAt': DateTime.now(),
    });
  }




  static Future deleteNotificationBid(String bid_id,job_id) async {
    final refMessages = FirebaseFirestore.instance.collection('JOB_BIDS');

    await refMessages.where('job_id', isEqualTo: job_id.toString())
        .where('bid_id', isEqualTo: bid_id.toString()).snapshots().forEach((element) {
      print(
          element.docs.map((e) {
            refMessages.doc(e.id.toString()).delete();
          })
      );
    });
  }


  static Future deleteNotificationInvoice(String bid_id,invoice_id) async {
    final refMessages = FirebaseFirestore.instance.collection('JOB_BIDS');

    await refMessages.where('invoice_id', isEqualTo: invoice_id.toString())
        .where('bid_id', isEqualTo: bid_id.toString()).snapshots().forEach((element) {
      print(
          element.docs.map((e) {
            refMessages.doc(e.id.toString()).delete();
          })
      );
    });
  }



  static Future updateNotificationInvoice(String id,status, message) async {
    final refMessages = FirebaseFirestore.instance.collection('Notification');
    await refMessages.where('type', isEqualTo: status.toString())
        .where('invoice_id', isEqualTo: id.toString()).snapshots().forEach((element) {
          print(
              element.docs.map((e) {
           updateNotification(e.id.toString(), message);
           print(e.id +"llll");
           print(e.id +"llll");
          }));
    });
  }



  static Future updateNotificationBid(String id,status, message) async {
    final refMessages = FirebaseFirestore.instance.collection('Notification');
    await refMessages.where('type', isEqualTo: status.toString())
        .where('bidId', isEqualTo: id.toString()).snapshots().forEach((element) {
      print(
          element.docs.map((e) {
            updateNotification(e.id.toString(), message);
            print(e.id +"llll");
            print(e.id +"llll");
          }));
    });
  }

  static Stream<QuerySnapshot> userChatStreamUnread(chatid) {
    var data = FirebaseFirestore.instance
        .collection('UserChat/$chatid/individual')
        .where('chatid', isEqualTo: chatid)
        .where('read', isEqualTo: false);
    return data.snapshots();
  }

  static Stream<QuerySnapshot> userChatStreamread(chatid) {
    var data = FirebaseFirestore.instance
        .collection('UserChat/$chatid/individual')
        .where('chatid', isEqualTo: chatid)
        .where('read', isEqualTo: true);
    return data.snapshots();
  }

  static updateUsertoRead({
    String idUser,
    String idArtisan,
  }) async {
    final refUsers =
    FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
    await refUsers.doc(idUser).update({
      'read': true,
    });
  }

  static updateUserFCMToken({
    String idUser,
    String idArtisan,
    token
  }) async {
    final refUsers =
    FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
    await refUsers.doc(idArtisan).update({
      'token': token,
    });
  }

}
