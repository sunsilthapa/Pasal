import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';

class ProfileInfo extends StatefulWidget {
  ProfileInfo({Key? key}) : super(key: key);

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
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
          appBar: AppBar(
            backgroundColor: Colors.deepOrangeAccent,
            centerTitle: true,
            title: Text("Profile Information"),
          ),
          body: Column(
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
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  elevation: 3,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        autofocus: true,
                        cursorColor: Colors.deepOrangeAccent,
                        cursorHeight: 20,
                        keyboardType: TextInputType.emailAddress,
                        // validator: ValidateLogin.emailValidate,
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.deepOrangeAccent),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            prefixIcon: const Icon(
                              Icons.email_rounded,
                              color: Colors.deepOrangeAccent,
                              size: 20,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(fontSize: 17.0)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _userController,
                        autofocus: true,
                        cursorColor: Colors.deepOrangeAccent,
                        cursorHeight: 20,
                        keyboardType: TextInputType.emailAddress,
                        // validator: ValidateLogin.emailValidate,
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.deepOrangeAccent),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.deepOrangeAccent,
                              size: 20,
                            ),
                            hintText: "Username",
                            hintStyle: TextStyle(fontSize: 17.0)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ));
    });
  }
}
