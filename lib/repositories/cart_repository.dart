import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:n_baz/models/favorite_model.dart';

import '../models/cart_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CartRepository {
  CollectionReference<CartModel> cartRef =
      FirebaseService.db.collection("carts").withConverter<CartModel>(
            fromFirestore: (snapshot, _) {
              return CartModel.fromFirebaseSnapshot(snapshot);
            },
            toFirestore: (model, _) => model.toJson(),
          );
  Future<List<QueryDocumentSnapshot<CartModel>>> getCarts(
      String productId, String userId) async {
    try {
      var data = await cartRef
          .where("user_id", isEqualTo: userId)
          .where("product_id", isEqualTo: productId)
          .get();
      var favorites = data.docs;
      return favorites;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<CartModel>>> getCartsUser(
      String userId) async {
    try {
      var data = await cartRef.where("user_id", isEqualTo: userId).get();
      var favorites = data.docs;
      return favorites;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<bool> cart(CartModel? isCart, String productId, String userId) async {
    try {
      if (isCart == null) {
        await cartRef.add(CartModel(userId: userId, productId: productId));
      } else {
        await cartRef.doc(isCart.id).delete();
      }
      return true;
    } catch (err) {
      rethrow;
    }
  }
}
