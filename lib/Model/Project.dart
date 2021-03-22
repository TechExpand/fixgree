import 'package:flutter/material.dart';


class Project {
  final String projectBid;
  final String jobDescription;
  final String serviceId;
  final String jobTitle;
  final String status;
  final String sn;
  final String dateOpen;

  const Project({
    @required this.projectBid,
    @required this.jobDescription,
    @required this.dateOpen,
    @required this.serviceId,
    @required this.jobTitle,
    @required this.sn,
    @required this.status,
  });

  static Project fromJson(Map<String, dynamic> json) => Project(
    projectBid: json['projectBid'],
    jobTitle: json['job_title'],
    dateOpen: json['date_oppened'],
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
    'job_title': jobTitle,
  };
}