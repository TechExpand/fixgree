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


