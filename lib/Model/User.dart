import 'package:fixme/Utils/utils.dart';
import 'package:meta/meta.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String idUser;
  final String name;
  final bool read;
  final bool block;
  final bool status;
  final String urlAvatar;
  final String docid;
  final DateTime lastMessageTime;
  final String lastMessage;
  final String userMobile;

  const User({
    this.idUser,
    this.read,
    this.userMobile,
    this.block,
    this.docid,
    this.status,
    @required this.name,
    @required this.lastMessage,
    @required this.urlAvatar,
    @required this.lastMessageTime,
  });

  User copyWith({
    String idUser,
    String docid,
    String userMobile,
    String name,
    bool block,
    bool read,
    bool status,
    String urlAvatar,
    String lastMessage,
    String lastMessageTime,
  }) =>
      User(
        idUser: idUser ?? this.idUser,
        name: name ?? this.name,
        docid: docid ?? this.docid,
        block: block?? this.block,
        read: read ?? this.read,
        userMobile: userMobile?? this.userMobile,
        status: status ?? this.status,
        lastMessage: lastMessage ?? this.lastMessage,
        urlAvatar: urlAvatar ?? this.urlAvatar,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );

  static User fromJson([Map<String, dynamic> json, id]) => User(
        idUser: json['idUser'],
        read: json['read'],
        name: json['name'],
        block: json['block'],
        status: json['[status'],
    userMobile: json['userMobile'],
        docid: id ?? '',
        lastMessage: json['lastMessage'],
        urlAvatar: json['urlAvatar'],
        lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
      );


       
  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'read': read,
        'docid': docid,
    'userMobile': userMobile,
        'name': name,
        'status': status,
         'block': block,
        'lastMessage': lastMessage,
        'urlAvatar': urlAvatar,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
      };
}
