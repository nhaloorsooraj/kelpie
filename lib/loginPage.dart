// ignore_for_file: file_names, camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kelpie/main.dart';
import 'package:kelpie/signupPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';

import 'dart:async';

// If you need to use FirebaseAuth directly, make sure to hide EmailAuthProvider:
// import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
/////////////////////////////

///////////////////////////

  Future<FirebaseApp> setinitializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
      );
    }
    return firebaseApp;
  }

  final _formKey = GlobalKey<FormState>();
  var email = "";
  var password = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void logInToFb() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setinitializeFirebase();

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(children: [
            Container(
              alignment: Alignment.topCenter,
              child: const Image(
                image: AssetImage('assets/signinbitmap.png'),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(15, 50, 0, 0),
              child: const Text(
                "LogIn",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 55,
                    fontFamily: 'segoe'),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: const Text(
                "For better future",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w100,
                    fontSize: 18,
                    fontFamily: 'segoe'),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          curve: Curves.linear,
                          type: PageTransitionType.rightToLeft,
                          child: const signupPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontFamily: 'segoe',
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ))),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(vertical: 3.0),
              child: TextFormField(
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  label: Text(
                    "Email",
                  ),
                  labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontFamily: 'segoe',
                      fontWeight: FontWeight.bold),
                ),
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This is Required';
                  } else if (!value.contains("@gmail.com")) {
                    return 'Please enter valid gmail address';
                  }
                  return null;
                },
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(vertical: 3.0),
              child: TextFormField(
                autofocus: false,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text(
                    "Password",
                  ),
                  labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontFamily: 'segoe',
                      fontWeight: FontWeight.bold),
                ),
                controller: passwordController,
              ),
            ),
            Container(
              alignment: (Alignment.bottomLeft),
              padding: const EdgeInsets.all(5),
              child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailController.text);
                    }
                  },
                  child: const Text(
                    "ForgotPassword?",
                    style: TextStyle(
                        fontFamily: 'segoe',
                        fontWeight: FontWeight.normal,
                        color: Colors.red),
                  )),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      logInToFb();
                    }
                  },
                  child: const Text(
                    "LogIn",
                    style: TextStyle(
                        fontFamily: 'segoe', fontWeight: FontWeight.bold),
                  )),
            )
          ]),
        ),
      ),
    );
  }
}
