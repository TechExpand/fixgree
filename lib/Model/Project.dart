import 'package:fixme/Model/UserSearch.dart';
import 'package:flutter/material.dart';


class Project {
  final int projectBid;
  final String jobDescription;
  final String serviceId;
  final String jobTitle;
  final UserSearch user;
  final String projectType;
  final String status;
  final UserSearch user2;
  final int jobId;
  final DateTime dateOpen;

  const Project({
    @required this.projectBid,
    @required this.jobId,
    @required this.projectType,
    @required this.jobDescription,
    @required this.dateOpen,
    @required this.user,
    @required this.user2,
    @required this.serviceId,
    @required this.jobTitle,
    @required this.status,
  });

  static Project fromJson(Map<String, dynamic> json) => Project(
    jobId : json['job_id'],
    projectBid: json['sn'],
    jobTitle: json['projectName'],
    dateOpen: DateTime.parse(json['date_bidded']),
    user: json['project_recipient_info'] != null ?  UserSearch.fromJson(json['project_recipient_info']) : null,
    user2: json['project_owner_info'] != null ?  UserSearch.fromJson(json['project_owner_info']) : null,
    //dateApprove: json['date_approved'],
    jobDescription: json['job_description'],
    status: json['status'],
    projectType: json['projectType'],
    serviceId: json['service_id'].toString(),
   // sn: json['sn'].toString(),
  );

  Map<String, dynamic> toJson() => {
    'sn': projectBid,
    'job_description': jobDescription,
    'status': status,
    'date_bidded': dateOpen,
    'projectType': projectType,
    'service_id': serviceId,
   // 'sn': sn,
    'job_id': jobId,
    if (this.user != null)
      'project_recipient_info' : this.user.toJson(),
    if (this.user2 != null)
      'project_owner_info' : this.user2.toJson(),
    'projectName': jobTitle,
  };
}