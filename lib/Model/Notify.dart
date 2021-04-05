import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';


class MessageField {
  static final String createdAt = 'createdAt';
}

class Notify {
  final String id;
  final userid;
  final budget;
  final String message;
  final String bidderId;
  final String bidId;
  final String type;
  final String name;
  final String jobid;
  final String artisanId;
  final String bidded;
  final DateTime createdAt;

  const Notify({
    this.budget,
    this.id,
    this.message,
    this.jobid,
    this.userid,
    this.artisanId,
    this.bidded,
    this.bidderId,
    this.bidId,
    this.name,
    @required this.type,
    @required this.createdAt,
  });

  Notify.fromMap(Map snapshot,String id) :
        id = id ?? '',
        bidded = snapshot['bidded']??'',
        jobid = snapshot['jobId']??'',
        bidderId = snapshot['bidderId']??'',
        bidId = snapshot['bidId']??'',
        budget = snapshot['budget']??'',
        message = snapshot['message'] ?? '',
        name = snapshot['name'] ?? '',
        userid = snapshot['userid'] ?? '',
        artisanId = snapshot['artisanId'] ?? '',
        type = snapshot['type'] ?? '',
        createdAt =  Utils.toDateTime(snapshot['createdAt']);

  Map<String, dynamic> toJson() => {
    'type': type,
    'budget': budget,
    'message': message,
    'name': name,
    'bidded': bidded,
    'bidderId': bidderId,
    'artisanId': artisanId,
    'bidId': bidId,
    'jobid': jobid,
    'userid': userid,
    'createdAt': Utils.fromDateTimeToJson(createdAt),
  };
}






class Bidify {
  final String id;
  final String bid_id;
  final String bidder_id;
  final String bidder_name;
  final String service_id;
  final String job_id;
  final String user_rating;
  final String user_reviews;
  final String project_owner_user_id;
  final String service_area;


  const Bidify({
    this.id,
    this.service_id,
    this.bid_id,
    this.bidder_id,
    this.bidder_name,
    this.job_id,
    this.user_rating,
    this.service_area,
    @required this.user_reviews,
    @required this.project_owner_user_id,
  });

  Bidify.fromMap(Map snapshot,String id) :
        id = id ?? '',
        bid_id = snapshot['bid_id']??'',
        bidder_id = snapshot['bidder_id']??'',
        bidder_name = snapshot['bidder_name'] ?? '',
        job_id = snapshot['job_id'] ?? '',
        user_rating = snapshot['user_rating'] ?? '',
        service_area = snapshot['service_area'] ?? '',
        user_reviews =  snapshot['user_reviews'] ?? '',
        service_id = snapshot['service_id'] ?? '0',
        project_owner_user_id =  snapshot['project_owner_user_id'] ?? '';

  Map<String, dynamic> toJson() => {
    'bid_id': bid_id,
    'bidder_id': bidder_id,
    'bidder_name': bidder_name,
    'job_id': job_id,
    'user_rating': user_rating,
    'service_area': service_area,
    'user_reviews': user_reviews,
    'service_id': service_id,
    'project_owner_user_id': project_owner_user_id,
  };
}

