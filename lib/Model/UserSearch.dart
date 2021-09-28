class UserSearch {
  String userEmail;
  var agentId;
  bool block;
  dynamic distance;
  String userLastName;
  List subServices; 
  String userRegDate;
  String  bio;
  String project_owner_user_id;
  String verification;
  String  businessName;
  String  businessAddress;
  var latitude;
  String userAddress;
  String fullNumber;
  String userRole;
  String name;
  var serviceRequests;
  var reviews;
  var profileViews;
  String userMobile;
  var serviceId;
  String idUser;
  String urlAvatar;
  String locationTimeUpdated;
  String serviceArea;
  var id;
  String status;
  String fcmToken;
  var longitude;
  var job_id;
  var bid_id;
  var service_id;
  var userRating;
  var servicePictures;

  UserSearch(
      {this.userEmail,
      this.agentId,
        this.job_id,
      this.distance,
      this.subServices,
      this.userLastName,
      this.verification,
        this.project_owner_user_id,
      this.idUser,
        this.bid_id,
      this.locationTimeUpdated,
        this.fcmToken,
      this.userRegDate,
      this.latitude,
      this.block,
      this.userAddress,
      this.bio,
        this.service_id,
      this.businessAddress,
      this.businessName,
      this.fullNumber,
      this.userRole,
      this.name,
      this.serviceRequests,
      this.reviews,
      this.profileViews,
      this.userMobile,
      this.serviceId,
      this.urlAvatar,
      this.serviceArea,
      this.id,
      this.status,
      this.longitude,
      this.userRating,
      this.servicePictures});

  static UserSearch fromJson(Map<String, dynamic> json) => UserSearch(
        userEmail: json['user_email'],
        agentId: json['agentId'],
        distance: json['distance'],
        job_id: null,
        bid_id: null,
    service_id: null,
        block: json['block'],
        userLastName: json['user_last_name'],
        userRegDate: json['user_reg_date'],
        latitude: json['latitude'],
    project_owner_user_id: json['project_owner_user_id'],
        subServices: json['subServices'],
         bio: json['bio'],
          businessName: json['business_name'],
           businessAddress: json['business_address'],
        userAddress: json['user_address'],
        fullNumber: json['full_number'],
        idUser: json['firebase_id'],
        fcmToken: json['mobile_device_token'],
        locationTimeUpdated: json['locationTimeUpdated'],
        userRole: json['user_role'],
        name: json['user_first_name'],
        serviceRequests: json['service_requests'],
        reviews: json['reviews'],
        profileViews: json['profile_views'],
        userMobile: json['user_mobile'],
        serviceId: json['service_id'],
        urlAvatar: json['profile_pic_file_name'],
        serviceArea: json['service_area'],
        id: json['id'],
        verification: json['identification_status'],
        servicePictures: json['servicePictures'],
        status: json['status'],
        longitude: json['longitude'],
        userRating: json['user_rating'],
      );

  Map<String, dynamic> toJson() => {
        'user_email': userEmail,
        'agentId': agentId,
    'project_owner_user_id': project_owner_user_id,
        'distance': distance,
        'user_last_name': userLastName,
        'user_reg_date': userRegDate,
    'mobile_device_token':fcmToken,
        "latitude": latitude,
    //  'job_id': job_id,
        "user_address": userAddress,
        'full_number': fullNumber,
        'user_role': userRole,
        'bool block': block,
        'user_first_name': name,
        "service_requests": serviceRequests,
        "reviews": reviews,
        "profile_views": profileViews,
        "user_mobile": userMobile,
        "service_id": this.serviceId,
        "profile_pic_file_name": urlAvatar,
        "service_area": serviceArea,
        "id": id,
        "status": status,
        "longitude": longitude,
        "user_rating": userRating,

      };
}
