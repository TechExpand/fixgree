import 'UserSearch.dart';

class GeneralSearch {
  String resultType;
  String product_name;
  int id;
  String userEmail;
  String userMobile;
  String full_number;
  String productImages;
  final UserSearch user;
  int  distance;
  var user_rating;
  int reviews;
  var  price;
  String  itemOwnerName;
  String urlAvatar;
  String user_country;
  String user_state;
  String user_city;
  String user_address;
  String business_address;
  var userRating;
  var userLastName;
  var subServices;
  var userRole;
  var fullNumber;
  var fcmToken;
  var name;
  var userAddress;
  var longitude;
  var latitude;
  var serviceArea;
  var businessAddress;
  String bio;
  String description;
  int serviceId;
  String verification;


  GeneralSearch(
      {this.resultType,
        this.id,
        this.user_address,
        this.user_city,
        this.user_country,
        this.userRole,
        this.userAddress,
        this.fcmToken,
        this.user_rating,
        this.user_state,
        this.userEmail,
        this.fullNumber,
        this.business_address,
        this.verification,
        this.full_number,
        this.subServices,
        this.userLastName,
        this.urlAvatar,
        this.productImages,
        this.name,
        this.serviceArea,
        this.product_name,
        this.bio,
        this.itemOwnerName,
        this.distance,
        this.price,
        this.user,
        this.userRating,
        this.serviceId,
        this.description,
        this.businessAddress,
        this.latitude,
        this.longitude,
        this.userMobile,
        this.reviews,
       });

  static GeneralSearch fromJson(Map<String, dynamic> json) => GeneralSearch(
    userEmail: json['userEmail'],
    user_state: json['user_state'],
    userRating: json['user_rating'],
    user_city: json['user_city'],
    user_country: json['user_country'],
    user_address: json['user_address'],
    userLastName: json['lastName'],
    subServices: json['subServices'],
    id: json['userId'],
    userRole: json['userRole'],
    user: json['user'] != null ?  UserSearch.fromJson(json['user']) : null,
    urlAvatar: json['itemOwnerProfilePicture'],
    fullNumber: json['full_number'],
    fcmToken: json['mobile_device_token'],
    businessAddress: json['business_address'],
    name: json['firstName'],
    userAddress: json['user_address'],
    longitude: json['longitude'],
    latitude: json['latitude'],
    verification: json['verification'],
    bio: json['bio'],
    serviceId: json['service_id'],
    userMobile: json['userMobile'],
    resultType: json['resultType'],
    itemOwnerName: json['itemOwnerName'],
    product_name: json['itemName'],
    description: json['itemDescription'],
    productImages: json['itemImage'],
    serviceArea: json['service_area'],
    price: json['priceOfItem'],
    distance: json['distance'],
    reviews: json['reviews'],

  );

  Map<String, dynamic> toJson() => {
    'userEmail': userEmail,
    'userId': id,
    'user_address': user_address,
    'user_country': user_country,
    'user_city': user_city,
    'verification': verification,
    'itemDescription': description,
    'user_rating': user_rating,
    'mobile_device_token':userMobile,
    "resultType": resultType,
    "reviews": reviews,
     "user_rating":  userRating,
    'full_number': fullNumber,
    'user_role': userRole,
    'lastName': userLastName,
    "subServices": subServices,
    'mobile_device_token': fcmToken,
    'latitude': latitude,
    'longitude': longitude,
    'firstName': name,
    'business_address': businessAddress,
    'user_address': userAddress,
    'itemImage': productImages,
    'bio': bio,
    if (this.user != null)
      'user' : this.user.toJson(),
    'itemName': product_name,
    'itemOwnerProfilePicture': urlAvatar,
    "service_id": serviceId,
    "service_area": serviceArea,
    "priceOfItem": price,
    "userMobile": userMobile,
    "distance": distance,
    "full_number": full_number,
    "user_state": user_state,
    'itemOwnerName': itemOwnerName,
  };
}
