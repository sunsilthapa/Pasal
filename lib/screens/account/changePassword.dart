import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_field_validator/password_field_validator.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/firebase_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreen();
}

class _ChangePasswordScreen extends State<ChangePasswordScreen> {
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    });
    super.initState();
  }

  void editPassword() async {
    _ui.loadState(true);
    try {
      _authViewModel.user?.updatePassword(latest_passwordController.text);
      FirebaseService.db
          .collection("users")
          .where("user_id", isEqualTo: _authViewModel.user?.uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.set({
            "password": latest_passwordController.text,
          }, SetOptions(merge: true));
        });
      }).catchError((error) {
        print("Error updating password : $error");
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Password updated")));
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

  TextEditingController prev_passwordController = TextEditingController();
  TextEditingController latest_passwordController = TextEditingController();
  TextEditingController confirm_passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Change your Password'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        color: Color(0xFFD6D6D6),
        child: ListView(
          children: [
            colorTiles(),
          ],
        ),
      ),
      bottomNavigationBar: SubmitButtons(),
    );
  }

  Widget colorTiles() {
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
                    "Previous Password:",
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
                        controller: prev_passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value != null || value!.isEmpty) {
                            final bool isValid = PasswordFieldValidator(
                                minLength: 6,
                                uppercaseCharCount: 1,
                                lowercaseCharCount: 1,
                                numericCharCount: 1,
                                specialCharCount: 1,
                                defaultColor: Colors.black54,
                                successColor: Colors.blue,
                                failureColor: Colors.red,
                                controller: latest_passwordController) as bool;
                            // .validate(passwordController.text.trim());
                            if (!isValid) {
                              return "Invalid Password";
                            }
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.deepOrange,
                        cursorHeight: 25,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[350],
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.deepOrange,
                            size: 25,
                          ),
                          hintText: "Enter your previous Password...",
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
                    "New Password:",
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
                        controller: latest_passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value != null || value!.isEmpty) {
                            final bool isValid = PasswordFieldValidator(
                                minLength: 6,
                                uppercaseCharCount: 1,
                                lowercaseCharCount: 1,
                                numericCharCount: 1,
                                specialCharCount: 1,
                                defaultColor: Colors.black54,
                                successColor: Colors.blue,
                                failureColor: Colors.red,
                                controller: latest_passwordController) as bool;
                            // .validate(passwordController.text.trim());
                            if (!isValid) {
                              return "Invalid Password";
                            }
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.deepOrange,
                        cursorHeight: 25,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[350],
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.deepOrange,
                            size: 25,
                          ),
                          hintText: "Enter your new Password",
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
                    "Confirm-Password:",
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
                        controller: confirm_passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value != null || value!.isEmpty) {
                            final bool isValid = PasswordFieldValidator(
                                minLength: 6,
                                uppercaseCharCount: 1,
                                lowercaseCharCount: 1,
                                numericCharCount: 1,
                                specialCharCount: 1,
                                defaultColor: Colors.black54,
                                successColor: Colors.blue,
                                failureColor: Colors.red,
                                controller: confirm_passwordController) as bool;
                            // .validate(passwordController.text.trim());
                            if (!isValid) {
                              return "Invalid Password";
                            }
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.deepOrange,
                        cursorHeight: 25,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[350],
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.deepOrange,
                            size: 25,
                          ),
                          hintText: "Verify your Password",
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
            )
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
            editPassword();
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

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class ChangePasswordScreen extends StatefulWidget {
//   const ChangePasswordScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// }
//
// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   TextEditingController currentPassword = new TextEditingController();
//   TextEditingController newPassword = new TextEditingController();
//   TextEditingController confirmPassword = new TextEditingController();
//   bool showPassword = false;
//   bool checkedValue = true;
//   @override
//   Widget build(BuildContext context) {
//     // var _isVisible = false;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Change password"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(10, 35, 10, 35),
//           child: Column(
//             children: [
//               Text(
//                 'Current Password',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 35),
//                 child: Container(
//                   margin: EdgeInsets.all(10),
//                   child: TextFormField(
//                     controller: currentPassword,
//                     validator: (String? value) {
//                       if (value == null || value.isEmpty) {
//                         return "current password is required";
//                       } else if (value != "currentPassword") {
//                         return "your current password did not match";
//                       }
//                       return null;
//                     },
//                     decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[350],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                         prefixIcon: Icon(Icons.lock),
//                         hintText: "Enter your current password"),
//                   ),
//                 ),
//               ),
//               Text(
//                 'New Password',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 35.0),
//                 child: Container(
//                   margin: EdgeInsets.all(10),
//                   child: TextFormField(
//                     controller: newPassword,
//                     validator: (String? value) {
//                       if (value == null || value.isEmpty) {
//                         return "new password is required";
//                         // } else if (value != "email") {
//                         //   return "Invalid email";
//                       }
//                       return null;
//                     },
//                     decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[350],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                         prefixIcon: Icon(Icons.lock),
//                         hintText: "Enter your new password"),
//                   ),
//                 ),
//               ),
//               Text(
//                 'Confirm Password',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 35.0),
//                 child: Container(
//                   margin: EdgeInsets.all(10),
//                   child: TextFormField(
//                     controller: confirmPassword,
//                     validator: (String? value) {
//                       if (value == null || value.isEmpty) {
//                         return "confirm password is required";
//                       } else if (value != "createPassword") {
//                         return "confirm password did not match with the created password";
//                       }
//                       return null;
//                     },
//                     decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[350],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                         prefixIcon: Icon(Icons.lock),
//                         hintText: "confirm your password"),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Text("");
//                       // Navigator.of(context).push(
//                       //   MaterialPageRoute(
//                       //     builder: (BuildContext context) => ProfileScreen(),
//                       //   ),
//                       // );
//                     },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.lightBlue,
//                         fixedSize: const Size(150, 50),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(50))),
//                     child: Text(
//                       "Submit",
//                       style: TextStyle(
//                         // fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
