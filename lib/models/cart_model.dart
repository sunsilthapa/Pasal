// To parse this JSON data, do
//
//     final CartModel = CartModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

CartModel CartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String CartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    required this.userId,
    this.id,
    required this.productId,
  });

  String? id;
  String userId;
  String productId;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
      );
  factory CartModel.fromFirebaseSnapshot(
          DocumentSnapshot<Map<String, dynamic>> json) =>
      CartModel(
        id: json.id,
        userId: json["user_id"],
        productId: json["product_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "id": id,
        "product_id": productId,
      };
}
