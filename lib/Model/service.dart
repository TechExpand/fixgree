import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';


class Services {
  final String addedBy;
  final String service;
  final String sn;
  final String dateAdded;

  const Services({
    @required this.dateAdded,
    @required this.addedBy,
    @required this.service,
    @required this.sn,
  });

  static Services fromJson(Map<String, dynamic> json) => Services(
    dateAdded: json['dateAdded'],
    addedBy: json['addedBy'],
    service: json['service'],
    sn: json['sn'].toString(),
  );

  Map<String, dynamic> toJson() => {
    'dateAdded': dateAdded,
    'addedBy': addedBy,
    'service': service,
    'sn': sn,
  };
}
