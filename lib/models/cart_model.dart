// To parse this JSON data, do
//
//     final CartModel = CartModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final favoriteModel = favoriteModelFromJson(jsonString);

import 'dart:convert';
// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    this.id,
    required this.userId,
    this.quantity = 1,
    required this.productId,
  });

  String? id;
  String userId;
  int quantity;
  String productId;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        userId: json["user_id"],
        quantity: json["_quantity"],
        productId: json["product_id"],
      );

  factory CartModel.fromFirebaseSnapshot(
          DocumentSnapshot<Map<String, dynamic>> json) =>
      CartModel(
        id: json.id,
        userId: json["user_id"],
        quantity: json["_quantity"],
        productId: json["product_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "_quantity": quantity,
        "product_id": productId,
      };
}

//
// CartModel CartModelFromJson(String str) => CartModel.fromJson(json.decode(str));
//
// String CartModelToJson(CartModel data) => json.encode(data.toJson());
//
// class CartModel {
//   CartModel({
//     required this.userId,
//     this.id,
//     required this.productId,
//   });
//
//   String? id;
//   String userId;
//   String productId;
//
//   factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
//         id: json["id"],
//         userId: json["user_id"],
//         productId: json["product_id"],
//       );
//   factory CartModel.fromFirebaseSnapshot(
//           DocumentSnapshot<Map<String, dynamic>> json) =>
//       CartModel(
//         id: json.id,
//         userId: json["user_id"],
//         productId: json["product_id"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "user_id": userId,
//         "id": id,
//         "product_id": productId,
//       };
// }
