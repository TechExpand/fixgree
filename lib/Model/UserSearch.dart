class UserSearch {
  String userEmail;
  int agentId;
  bool block;
  int distance;
  String userLastName;
  List subServices; 
  String userRegDate;
  String  bio;
  String verification;
  String  businessName;
  String  businessAddress;
  var latitude;
  String userAddress;
  String fullNumber;
  String userRole;
  String name;
  int serviceRequests;
  int reviews;
  int profileViews;
  String userMobile;
  int serviceId;
  String idUser;
  String urlAvatar;
  String locationTimeUpdated;
  String serviceArea;
  int id;
  String status;
  String fcmToken;
  var longitude;
  int userRating;
  var servicePictures;

  UserSearch(
      {this.userEmail,
      this.agentId,
      this.distance,
      this.subServices,
      this.userLastName,
      this.verification,
      this.idUser,
      this.locationTimeUpdated,
        this.fcmToken,
      this.userRegDate,
      this.latitude,
      this.block,
      this.userAddress,
      this.bio,
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
        block: json['block'],
        userLastName: json['user_last_name'],
        userRegDate: json['user_reg_date'],
        latitude: json['latitude'],
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
//    if (json['servicePictures'] != null) {
//      servicePictures = new List<Null>();
//      json['servicePictures'].forEach((v) {
//        servicePictures.add(v);
//      });
//    }
      );

  Map<String, dynamic> toJson() => {
        'user_email': userEmail,
        'agentId': agentId,
        'distance': distance,
        'user_last_name': userLastName,
        'user_reg_date': userRegDate,
    'mobile_device_token':fcmToken,
        "latitude": latitude,
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
//    if (servicePictures != null) {
//      "servicePictures" =
//          servicePictures.map((v) => v);
//    }
//    return data;
      };
}
