import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository {
  CollectionReference<CategoryModel> categoryRef =
      FirebaseService.db.collection("categories").withConverter<CategoryModel>(
            fromFirestore: (snapshot, _) {
              return CategoryModel.fromFirebaseSnapshot(snapshot);
            },
            toFirestore: (model, _) => model.toJson(),
          );
  Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if (!hasData) {
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>> getCategory(String categoryId) async {
    try {
      print(categoryId);
      final response = await categoryRef.doc(categoryId).get();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  List<CategoryModel> makeCategory() {
    return [
      CategoryModel(
          categoryName: "Hoodies",
          status: "active",
          imageUrl:
              "https://res.cloudinary.com/dyfwfkx4t/image/upload/v1671627438/H46b617ddfc9c4eb08e32913e023a52a2T.jpg_300x300_tn7apg.jpg"),
      CategoryModel(
          categoryName: "Shoes",
          status: "active",
          imageUrl:
              "https://assets.reebok.com/images/w_600,f_auto,q_auto/284a6dbadf75425fa1dbacfd00767fdd_9366/Nano_X1_Lux_Shoes_White_FZ1418_02_standard.jpg"),
      CategoryModel(
          categoryName: "Pants",
          status: "active",
          imageUrl:
              "https://res.cloudinary.com/dyfwfkx4t/image/upload/v1671270096/H7546d87686ce43f2ae0b0f8435e0c1afH.jpg_720x720q50_frarka.jpg"),
      CategoryModel(
          categoryName: "Shirts",
          status: "active",
          imageUrl:
              "https://res.cloudinary.com/dyfwfkx4t/image/upload/v1671268443/H5c766c4219e24e4bb8008c5b4f12946bs.jpg_720x720q50_uumizh.jpg"),
      CategoryModel(
          categoryName: "Bags",
          status: "active",
          imageUrl:
              "https://assets.reebok.com/images/w_600,f_auto,q_auto/eb31ff6778fa42e89e57ac480039b8fd_9366/Classics_Archive_Backpack_Small_Black_GN7640.jpg"),
    ];
  }
}
