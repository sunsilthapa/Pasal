import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';

class Project extends StatefulWidget {
  Project({Key? key}) : super(key: key);

  @override
  _ProjectState createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  late AuthViewModel _authViewModel;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    });
    super.initState();
  }

  File? _image;
  Future<void> getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return;
    }
    final imageTemporary = File(image.path);

    setState(() {
      this._image = imageTemporary;
    });
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _userController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(builder: (context, authVM, chid) {
      return Scaffold(
          body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                "https://imgs.search.brave.com/VfOlmssamn3NTAP14DFpqr1z9pxdR7P4czo10TKxRuk/rs:fit:860:681:1/g:ce/aHR0cHM6Ly93d3cu/cG5naXRlbS5jb20v/cGltZ3MvbS8xNDYt/MTQ2ODQ3OV9teS1w/cm9maWxlLWljb24t/YmxhbmstcHJvZmls/ZS1waWN0dXJlLWNp/cmNsZS1oZC5wbmc",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      top: 125,
                      left: 100,
                      width: 90,
                      height: 30,
                      child: ActionChip(
                        label: Text("Change"),
                        onPressed: () => getImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(40),
              ),
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  TextFormField(
                    controller: _userController,
                    autofocus: true,
                    cursorColor: Colors.green,
                    cursorHeight: 20,
                    keyboardType: TextInputType.emailAddress,
                    // validator: ValidateLogin.emailValidate,
                    style: const TextStyle(fontSize: 16.0, color: Colors.green),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.green,
                          size: 20,
                        ),
                        hintText: "Username",
                        hintStyle: TextStyle(fontSize: 17.0)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _emailController,
                    autofocus: true,
                    cursorColor: Colors.green,
                    cursorHeight: 20,
                    keyboardType: TextInputType.emailAddress,
                    // validator: ValidateLogin.emailValidate,
                    style: const TextStyle(fontSize: 16.0, color: Colors.green),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        prefixIcon: const Icon(
                          Icons.email_rounded,
                          color: Colors.green,
                          size: 20,
                        ),
                        hintText: "Email Address",
                        hintStyle: TextStyle(fontSize: 17.0)),
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.green))),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 20)),
                ),
                onPressed: () {
                  // login();
                },
                child: Text(
                  "Update",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 300,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.green))),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 20)),
                ),
                onPressed: () {
                  // login();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ));
    });
  }
}
