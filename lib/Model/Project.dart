import 'package:flutter/material.dart';


class Project {
  final int projectBid;
  final String jobDescription;
  final String serviceId;
  final String jobTitle;
  final String dateApprove;
  final String status;
  final String sn;
  final int jobId;
  final String dateOpen;

  const Project({
    @required this.projectBid,
    @required this.jobId,
    @required this.jobDescription,
    @required this.dateOpen,
    @required this.serviceId,
    @required this.jobTitle,
    @required this.sn,
    @required this.dateApprove,
    @required this.status,
  });

  static Project fromJson(Map<String, dynamic> json) => Project(
    jobId : json['job_id'],
    projectBid: json['projectBid_id'],
    jobTitle: json['job_title'],
    dateOpen: json['date_oppened'],
    dateApprove: json['date_approved'],
    jobDescription: json['job_description'],
    status: json['status'],
    serviceId: json['service_id'].toString(),
    sn: json['sn'].toString(),
  );

  Map<String, dynamic> toJson() => {
    'projectBid': projectBid,
    'job_description': jobDescription,
    'status': status,
    'date_oppened': dateOpen,
    'service_id': serviceId,
    'sn': sn,
    'job_id': jobId,
    'job_title': jobTitle,
  };
}