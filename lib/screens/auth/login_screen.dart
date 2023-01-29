import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/local_notification_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void login() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }
    _ui.loadState(true);
    try {
      final user = await _authViewModel
          .login(_emailController.text, _passwordController.text)
          .then((value) {
        NotificationService.display(
          title: "Welcome back",
          body:
              "Hello ${_authViewModel.loggedInUser?.name},\n Hope you are having a wonderful day.",
        );

        Navigator.of(context).pushReplacementNamed('/dashboard');
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.deepOrangeAccent,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(50),
          elevation: 20,
        ));
      });
      print(user.toString());
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        backgroundColor: Colors.deepOrangeAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 20,
      ));
    }
    _ui.loadState(false);
  }

  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  @override
  void initState() {
    _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
    _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/HamroPasal.png",
                        height: _height * 0.26, width: _width),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      autofocus: true,
                      cursorColor: Colors.deepOrangeAccent,
                      cursorHeight: 20,
                      keyboardType: TextInputType.emailAddress,
                      validator: ValidateLogin.emailValidate,
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
                      controller: _passwordController,
                      obscureText: isVisible,
                      validator: ValidateLogin.password,
                      autofocus: true,
                      cursorColor: Colors.deepOrangeAccent,
                      cursorHeight: 20,
                      keyboardType: TextInputType.text,
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
                          prefixIcon: Icon(
                            Icons.lock_clock_rounded,
                            color: Colors.deepOrangeAccent,
                            size: 23,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            child: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 21.0,
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                          hintText: "Enter password",
                          hintStyle: TextStyle(fontSize: 17.0)),
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed("/forget-password");
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: _width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.deepOrangeAccent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                          color: Colors.orangeAccent))),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(vertical: 20)),
                        ),
                        onPressed: () {
                          login();
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Are you new? Create an account",
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("/register");
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      child: Container(
                          width: _width * 0.6,
                          height: _height * 0.07,
                          margin: EdgeInsets.only(top: 25),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.transparent),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/google.webp'),
                                      fit: BoxFit.cover),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                'Sign in with Google',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ))),
                      // onTap: ()
                      // async{
                      //   hp                      signInWithGoogle(model)
                      //       .then((FirebaseUser user){
                      //     model.clearAllModels();
                      //     Navigator.of(context).pushNamedAndRemoveUntil
                      //       (RouteName.Home, (Route<dynamic> route) => false
                      //     );}
                      //   ).catchError((e) => print(e));
                      // },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isVisible = true;
}

class ValidateLogin {
  static String? emailValidate(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    return null;
  }
}
