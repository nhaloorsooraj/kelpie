import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kelpie/loginPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

var tempID = FirebaseAuth.instance.currentUser?.email;
var userID = tempID?.replaceAll('.', 'DOT');

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

class _MyHomePageState extends State<MyHomePage> {
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
              alignment: Alignment.centerLeft,
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
                  },
                  child: const Text("OFF",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700))),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 50),
            alignment: Alignment.centerLeft,
            child: const Text(
              "STATUS :",
              style: TextStyle(
                  fontFamily: 'segoe',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black45),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const loginPage()));
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
