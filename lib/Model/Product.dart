import 'package:fixme/Model/UserSearch.dart';
import 'package:flutter/material.dart';


class Product {
  final  user_id;
  final List productImages;
  final  price;
  final String description;
  final String product_name;
  final UserSearch user;
  final network;


  const Product({
   this.productImages,
    this.user_id,
  this.price,
  this.description,
    this.product_name,
     this.user,
    this.network,
  });

  static Product fromJson(Map<String, dynamic> json) => Product(
    productImages : json['productImages'],
    user_id: json['user_id'],
    price: json['price'],
    user: json['user'] != null ?  UserSearch.fromJson(json['user']) : null,
    description: json['description'],
    product_name: json['product_name'],
  );

  Map<String, dynamic> toJson() => {
    'productImages': productImages,
    'user_id': user_id,
     if (this.user != null)
     'user' : this.user.toJson(),
    'price': price,
    'user': user,
    'description': description,
    'product_name': product_name,
  };
}



//
// class ProductImage {
//   final int productId;
//   final String imageFileName;
//   final int id;
//   final int userId;
//   final String status;
//   final String upload_date;
//
//
//   const ProductImage({
//     @required this.productId,
//     @required this.imageFileName,
//     @required this.id,
//     @required this.userId,
//     @required this.status,
//     @required this.upload_date,
//   });
//
//   static ProductImage fromJson(Map<String, dynamic> json) => ProductImage(
//     productId : json['productId'],
//     imageFileName: json['imageFileName'],
//     id: json['id'],
//     userId: json['userId'],
//     status: json['status'],
//     upload_date: json['upload_date'],
//   );
//
//   Map<String, dynamic> toJson() => {
//     'productId': productId,
//     'imageFileName': imageFileName,
//     'id': id,
//     'userId': userId,
//     'status': status,
//     'upload_date': upload_date,
//   };
// }