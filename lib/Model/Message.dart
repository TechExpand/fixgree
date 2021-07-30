import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';


class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final id;
  final String callerId;
  final String callStatus;
  final String idUser;
  final String urlAvatar;
  final String username;
  final String message;
  final String productImage;
  final String calltype;
  final chatId;
  final DateTime createdAt;

  const Message({
    this.id,
    this.callerId,
    this.productImage,
    this.calltype,
    @required this.idUser,
    this.chatId,
    this.callStatus,
    @required this.urlAvatar,
    @required this.username,
    @required this.message,
    @required this.createdAt,
  });

  Message.fromMap(Map snapshot,String id) :
        id = id ?? '',
        chatId = snapshot['chatId']??'',
        message = snapshot['message'] ?? '',
        calltype = snapshot['calltype']??'',
        productImage = snapshot['productImage']??'',
        callerId = snapshot['callerId']??'',
        idUser = snapshot['idUser']??'',
        urlAvatar = snapshot['urlAvatar']??'',
        callStatus = snapshot['callStatus'] ?? '',
        username = snapshot['username'] ?? '',
        createdAt =  Utils.toDateTime(snapshot['createdAt']);


  Map<String, dynamic> toJson() => {
    'calltype': calltype,
    'idUser': idUser,
    'callerId': callerId,
    'chatId': chatId,
    'urlAvatar': urlAvatar,
    'productImage':productImage,
    'callStatus': callStatus,
    'username': username,
    'message': message,
    'createdAt': Utils.fromDateTimeToJson(createdAt),
  };
}
