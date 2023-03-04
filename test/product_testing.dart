// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:n_baz/models/product_model.dart';
// import 'package:n_baz/repositories/product_repositories.dart';
// import 'package:n_baz/services/firebase_service.dart';
//
// void main() async {
//   FirebaseService.db = FakeFirebaseFirestore();
//   final ProductRepository productRepository = ProductRepository();
//
//   test("Create a product", () async {
//     var response = await productRepository.addProducts(ProductModel(
//         productName: "Test name",
//         productPrice: 123,
//         imageUrl: "test image",
//         imagePath: "test path"));
//     expect(response, true);
//   });
//
//   test("Get product shapshot", () async {
//     var data = productRepository.getData();
//     expect(data.runtimeType, Stream<QuerySnapshot<ProductModel>>);
//   });
// }

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:n_baz/models/product_model.dart';
import 'package:n_baz/repositories/product_repositories.dart';
import 'package:n_baz/repositories/product_repositories.dart';

//
// void main() {
//   late ProductRepository productService;
//   late MockProductRef mockProductRef;
//
//   setUp(() {
//     mockProductRef = MockProductRef();
//     productService = ProductRepository(productRef: mockProductRef);
//   });
//
//   group('removeProduct', () {
//     test('should return false if userId does not match', () async {
//       final productId = '1';
//       final userId = '2';
//       final productData = {'userId': '3'};
//
//       when(mockProductRef.doc(productId).get())
//           .thenAnswer((_) async => DocumentSnapshotMock(productData));
//
//       final result = await productService.removeProduct(productId, userId);
//
//       expect(result, false);
//       verify(mockProductRef.doc(productId).get()).called(1);
//       verifyNever(mockProductRef.doc(productId).delete());
//     });
//
//     test('should delete product if userId matches', () async {
//       final productId = '1';
//       final userId = '2';
//       final productData = {'userId': '2'};
//
//       when(mockProductRef.doc(productId).get())
//           .thenAnswer((_) async => DocumentSnapshotMock(productData));
//
//       final result = await productService.removeProduct(productId, userId);
//
//       expect(result, true);
//       verify(mockProductRef.doc(productId).get()).called(1);
//       verify(mockProductRef.doc(productId).delete()).called(1);
//     });
//
//     test('should rethrow error', () async {
//       final productId = '1';
//       final userId = '2';
//
//       when(mockProductRef.doc(productId).get()).thenThrow(Exception());
//
//       expect(() => productService.removeProduct(productId, userId),
//           throwsA(isInstanceOf<Exception>()));
//     });
//   });
//
//   group('getOneProduct', () {
//     test('should return product if it exists', () async {
//       final productId = '1';
//       final productData = {'name': 'Product 1'};
//
//       when(mockProductRef.doc(productId).get())
//           .thenAnswer((_) async => DocumentSnapshotMock(productData));
//
//       final result = await productService.getOneProduct(productId);
//
//       expect(result.data(), ProductModel.fromJson(productData));
//       verify(mockProductRef.doc(productId).get()).called(1);
//     });
//
//     test('should throw exception if product does not exist', () async {
//       final productId = '1';
//
//       when(mockProductRef.doc(productId).get())
//           .thenAnswer((_) async => DocumentSnapshotMock(null));
//
//       expect(() => productService.getOneProduct(productId),
//           throwsA(isInstanceOf<Exception>()));
//     });
//
//     test('should rethrow error', () async {
//       final productId = '1';
//
//       when(mockProductRef.doc(productId).get()).thenThrow(Exception());
//
//       expect(() => productService.getOneProduct(productId),
//           throwsA(isInstanceOf<Exception>()));
//     });
//   });
//
//   group('addProducts', () {
//     test('should add product successfully', () async {
//       final product = ProductModel(name: 'Product 1');
//
//       when(mockProductRef.add(product)).thenAnswer((_) async => null);
//
//       final result = await productService.addProducts(product: product);
//
//       expect(result, true);
//       verify(mockProductRef.add(product)).called(1);
//     });
//
//     test('should return false on error', () async {
//       final product = ProductModel(name: 'Product 1');
//
//       when(mockProductRef.add(product)).thenThrow(Exception());
//
//       final result = await productService.addProducts(product: product);
//
//       expect(result, false);
//     });
//   });
//
//
