// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kelpie/loginPage.dart';
import 'package:firebase_database/firebase_database.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

var tempID = FirebaseAuth.instance.currentUser?.email;
var userID = tempID?.replaceAll('.', 'DOT');
var status = "Waiting for Response....";
var dVolt = 0;

final uploadRef = FirebaseDatabase.instance.ref(userID);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
      home: const loginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final readRef = FirebaseDatabase.instance.ref(userID! + "/LED_VALUE");
final readVoltRef = FirebaseDatabase.instance.ref(userID! + "/VOLTAGE_VALUE");
// ignore: non_constant_identifier_names

class _MyHomePageState extends State<MyHomePage> {
  dynamic voltageRead() {
    readVoltRef.onValue.listen((DatabaseEvent databaseEvent) {
      dynamic readVolt = databaseEvent.snapshot.value;
      if (readVolt == null) {
        dVolt = 0;
      } else {
        setState(() {
          dVolt = readVolt;
        });
      }
    });
  }

  ///////////////////////////////////////////////////////
  dynamic ledStatus() {
    readRef.onValue.listen((DatabaseEvent databaseEvent) {
      var statusLed = databaseEvent.snapshot.value;

      switch (statusLed) {
        case 0:
          setState(() {
            status = "Motor Turned OFF";
          });

          break;
        case 1:
          setState(() {
            status = "Motor Turned ON";
          });

          break;

        case 2:
          setState(() {
            status = "Wireless Connection Lost..!";
          });

          break;

        case 3:
          {
            setState(() {
              status = "LINE FAULT";
            });
          }

          break;
        default:
          setState(() {
            status = "Waiting for Response....";
          });
      }
    });
  }

  @override
  void initState() {
    ledStatus();
    voltageRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 25),
            child: const SizedBox(
              height: 200,
              width: 200,
              child: Image(
                image: AssetImage('assets/icon.png'),
              ),
            ),
          ),
          Container(
              alignment: Alignment.center,
              child: const Text(
                "Kelpie",
                style: TextStyle(
                    fontFamily: 'segoe',
                    fontWeight: FontWeight.w800,
                    color: Colors.black54,
                    fontSize: 65),
              )),
          Container(
              alignment: Alignment.center,
              child: const Text(
                "CONTROLS",
                style: TextStyle(
                    fontFamily: 'segoe',
                    fontWeight: FontWeight.w800,
                    color: Colors.black54,
                    fontSize: 32),
              )),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(20, 60, 0, 60),
              child: const Text(
                "MOTOR CONTROLS",
                style: TextStyle(
                    fontFamily: 'segoe',
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    fontSize: 25),
              )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green)),
                  onPressed: () {
                    uploadRef.update({'REQ_STATUS': 1});
                    ledStatus();
                  },
                  child: const Text(
                    "ON",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  )),
              ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red)),
                  onPressed: () {
                    uploadRef.update({'REQ_STATUS': 0});
                    ledStatus();
                  },
                  child: const Text("OFF",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700))),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 50),
            alignment: Alignment.center,
            child: Text(
              status,
              style: const TextStyle(
                  fontFamily: 'segoe',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black45),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 300,
                  child: SfLinearGauge(
                    minimum: 0,
                    maximum: 400,
                    markerPointers: [
                      LinearShapePointer(value: dVolt.toDouble())
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "$dVolt",
                    style: const TextStyle(
                        fontFamily: 'SevenSegment',
                        fontStyle: FontStyle.italic,
                        fontSize: 45,
                        fontWeight: FontWeight.w700),
                  ))
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    readRef.onValue.listen((DatabaseEvent databaseEvent) {
                      var statusLed = databaseEvent.snapshot.value;
                      if (statusLed == 0) {
                        signout();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const loginPage()));
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("WARNING !"),
                                content: const Text(
                                    "Please Turn OFF Motor,\n\nIf problem still exist there maybe problem connecting with device."),
                                actions: [
                                  TextButton(
                                      child: const Text("I understand"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      })
                                ],
                              );
                            });
                      }
                    });

                    // ignore: use_build_context_synchronously
                  },
                  child: const Text("LogOut"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

signout() async {
  await FirebaseAuth.instance.signOut();
}
