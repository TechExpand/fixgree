class Info {
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
  var longitude;
  int userRating;
  var servicePictures;

  Info(
      {this.userEmail,
        this.agentId,
        this.distance,
        this.subServices,
        this.userLastName,
        this.verification,
        this.idUser,
        this.locationTimeUpdated,
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

  static Info fromJson(Map<String, dynamic> json) => Info(
    userEmail: json['email'],
    userLastName: json['lastName'],
    userRegDate: json['regDate'],
    subServices: json['subServices'],
    bio: json['bio'],
    businessName: json['businessName'],
    businessAddress: json['businessAddress'],
    userAddress: json['address'],
    fullNumber: json['fullNumber'],
    idUser: json['firebase_id'],
    userRole: json['role'],
    name: json['firstName'],
    reviews: json['reviews'],
    userMobile: json['phoneNumber'],
    serviceId: json['service_id'],
    urlAvatar: json['profile_pic_file_name'],
    serviceArea: json['serviceArea'],
    id: json['id'],
    verification: json['identificationStatus'],
    userRating: json['user_rating'],
  );


}