// ignore_for_file: prefer_interpolation_to_compose_strings, depend_on_referenced_packages

//import 'package:kelpie/networkconnection.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:kelpie/loginpage.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';

bool isDeviceConnected = false;
bool isInitialized = false;
late StreamSubscription subscription;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AnimatedSplashScreen(
            splash: Image.asset('assets/splash_ico.png'),
            splashIconSize: 450,
            backgroundColor: const Color.fromARGB(255, 250, 250, 250),
            duration: 3000,
            pageTransitionType: PageTransitionType.topToBottom,
            nextScreen: const loginPage()));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// ignore: non_constant_identifier_names
class _MyHomePageState extends State<MyHomePage> {
  //////////////////////////// CONNECTIVITY ////////////////////////////////////////////////////////////////
  /* getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected) {
          setState(() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const NetworkConnection()));
          });
        }
      },
    );
  }

  Future<void> _initializeAsyncDependencies() async {
    getConnectivity();
    setState(() {
      isInitialized = true;
    });
  }
*/
  @override
  void initState() {
    // _initializeAsyncDependencies();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
