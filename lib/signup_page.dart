// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import 'package:kelpie/loginpage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';

class signupPage extends StatefulWidget {
  const signupPage({super.key});

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signInToFb() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const loginPage()),
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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                "SignUp",
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
                "Get Set Ready!",
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
                      Navigator.pop(
                        context,
                        PageTransition(
                          curve: Curves.linear,
                          type: PageTransitionType.leftToRight,
                          child: const loginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "LogIn",
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
                    return 'Please enter new gmail address';
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
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signInToFb();
                    }
                  },
                  child: const Text(
                    "SignUp",
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
