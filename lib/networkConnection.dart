// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:async';

import 'package:kelpie/loginPage.dart';

late StreamSubscription subscription;
bool isDeviceConnected = false;

class NetworkConnection extends StatefulWidget {
  const NetworkConnection({super.key});

  @override
  State<NetworkConnection> createState() => _NetworkConnectionState();
}

class _NetworkConnectionState extends State<NetworkConnection> {
  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (isDeviceConnected) {
            setState(() {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const loginPage()));
            });
          }
        },
      );

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Container(
            alignment: Alignment.center,
            child: const SizedBox(
                width: 300,
                height: 300,
                child: Image(image: AssetImage("assets/wifilost.png"))),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 30),
            child: const Text(
              "Oops...Network lost!",
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'segoe',
                  fontWeight: FontWeight.w200),
            ),
          )
        ]));
  }
}
