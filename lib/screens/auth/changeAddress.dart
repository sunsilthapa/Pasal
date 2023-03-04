import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:n_baz/models/user_model.dart';
import 'package:n_baz/models/user_model.dart';
import 'package:provider/provider.dart';

import '../../services/firebase_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class ChangeAddress extends StatefulWidget {
  const ChangeAddress({Key? key}) : super(key: key);

  @override
  State<ChangeAddress> createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  String? userId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      // final args = ModalRoute.of(context)!.settings.arguments;
      // print(args);
      // FirebaseFirestore db = FirebaseFirestore.instance;
      // db.collection("users").doc(args.toString()).get().then((data) {
      //   prev_addressController.text = data["address"];
      // });
    });
    super.initState();
  }
  // Future<void> addProduct() async {
  //   FirebaseFirestore db = FirebaseFirestore.instance;
  //   final data = {
  //     "address": new_addressController.text,
  //   };
  //   final args = ModalRoute.of(context)!.settings.arguments;
  //   db.collection("users").doc(args.toString()).set(data).then(
  //         (value) => ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Address Updated"),
  //       ),
  //     ),
  //   );
  // }

  void editAddress() async {
    _ui.loadState(true);
    try {
      // _authViewModel.user?.updatePhoneNumber(new_addressController.text);
      FirebaseService.db
          .collection("users")
          .where("user_id", isEqualTo: _authViewModel.user?.uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.set({
            "address": new_addressController.text,
          }, SetOptions(merge: true));
        });
      }).catchError((error) {
        print("Error updating address : $error");
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("address updated")));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error")));
    }
    _ui.loadState(false);
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.all(0.5),
      child: Divider(
        thickness: 1.5,
      ),
    );
  }

  TextEditingController prev_addressController = TextEditingController();
  TextEditingController new_addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(builder: (context, authVM, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Change your Address'),
          backgroundColor: Colors.deepOrange,
        ),
        body: Container(
          color: Color(0xFFD6D6D6),
          child: ListView(
            children: [
              colorTiles(authVM),
            ],
          ),
        ),
        bottomNavigationBar: SubmitButtons(),
      );
    });
  }

  Widget colorTiles(AuthViewModel authVM) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  Text(
                    "Previous Address: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 30),
                    child: TextFormField(
                        controller: prev_addressController,
                        validator: (value) {
                          if (value != null || value!.isEmpty) {
                            return "Invalid address";
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.deepOrange,
                        cursorHeight: 25,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[350],
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            color: Colors.deepOrange,
                            size: 25,
                          ),
                          hintText: "Previous address",
                          // hintText: "${authVM.loggedInUser?.email.toString()}",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.black38)),
                        )),
                  ),
                ],
              ),
            ),
            divider(),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    "New Address:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 30),
                    child: TextFormField(
                        controller: new_addressController,
                        validator: (value) {
                          if (value != null || value!.isEmpty) {
                            return "Invalid address";
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.deepOrange,
                        cursorHeight: 25,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[350],
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            color: Colors.deepOrange,
                            size: 25,
                          ),
                          hintText: "Enter your new address",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.black38)),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget SubmitButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: ElevatedButton(
          onPressed: () {
            editAddress();
            // Add your code for logging out here
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: const Text(
            "Submit",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
