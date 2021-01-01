import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';


class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final String idUser;
  final String urlAvatar;
  final String username;
  final String message;
  final String calltype;
  final chatId;
  final DateTime createdAt;

  const Message({
    this.calltype,
    @required this.idUser,
    this.chatId,
    @required this.urlAvatar,
    @required this.username,
    @required this.message,
    @required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
    chatId: json['chatId'],
    calltype: json['calltype'],
    idUser: json['idUser'],
    urlAvatar: json['urlAvatar'],
    username: json['username'],
    message: json['message'],
    createdAt: Utils.toDateTime(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'calltype': calltype,
    'idUser': idUser,
    'chatId': chatId,
    'urlAvatar': urlAvatar,
    'username': username,
    'message': message,
    'createdAt': Utils.fromDateTimeToJson(createdAt),
  };
}
