import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search",
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                performSearch();
              },
            ),
          ),
        ),
      ),
      body: Container(),
    );
  }

  void performSearch() {
    String searchTerm = _searchController.text;

    FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: searchTerm)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("Found user with name: ${doc.data()["name"]}");
      });
    }).catchError((error) {
      print("Error searching in Firestore: $error");
    });
  }
}
