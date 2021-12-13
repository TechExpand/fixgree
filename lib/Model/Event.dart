import 'package:fixme/Model/User.dart';
import 'package:fixme/Model/UserSearch.dart';

class Event {
  String eventState;
  String managerRole;
  String eventEndDate;
  int eventDuration;
  String eventDescription;
  String eventStartTime;
  String eventEndTime;
  List  eventTicket;
  String venueAddress;
  String  eventStartDate;
  String  eventCity;
  int userId;
  String eventCountry;
  String eventName;
  List eventImages;
  int serviceId;
  UserSearch user;


  Event(
      {this.eventDuration,
        this.eventCity,
        this.eventState,
        this.eventCountry,
        this.eventDescription,
        this.eventName,
        this.eventEndDate,
        this.eventEndTime,
        this.eventImages,
        this.eventStartDate,
        this.eventStartTime,
        this.eventTicket,
        this.userId,
        this.user,
        this.venueAddress,
        this.serviceId,
        this.managerRole,
        });

  static Event fromJson(Map<String, dynamic> json) => Event(
    eventTicket: json['event_tickets'],
    eventStartTime: json['event_begin_time'],
    eventStartDate: json['event_begin_date'],
    eventImages: json['eventImages'],
    eventEndTime: json['event_end_time'],
    eventEndDate: json['event_end_date'],
    eventName: json['event_name'],
    eventCountry: json['event_country'],
    eventDescription: json['description'],
    eventState: json['event_state'],
    eventCity: json['event_city'],
    eventDuration: json['event_duration'],
    managerRole: json['manager_role'],
    venueAddress: json['venue_address'],
    user: json['user'] != null ?  UserSearch.fromJson(json['user']) : null,
    userId: json['user_id'],
    serviceId: json['sn'],
  );


}