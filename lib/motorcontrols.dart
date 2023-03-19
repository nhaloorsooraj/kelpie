import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

var status = "Check Internet Connection";

var tempID = FirebaseAuth.instance.currentUser?.email;
var userID = tempID?.replaceAll('.', 'DOT');
final uploadRef = FirebaseDatabase.instance.ref(userID);
final readRef = FirebaseDatabase.instance.ref('${userID!}/DEVICE_VALUE');
final readVoltRef = FirebaseDatabase.instance.ref('${userID!}/VOLTAGE_STATUS');
final readCurrRef = FirebaseDatabase.instance.ref('${userID!}/CURRENT_STATUS');

var dVolt = 0;
var dCurr = 0;

class MotorControls extends StatefulWidget {
  const MotorControls({super.key});

  @override
  State<MotorControls> createState() => _MotorControlsState();
}

class _MotorControlsState extends State<MotorControls> {
//////////////////////////////////////////////////////////////////

  dynamic currentRead() {
    readCurrRef.onValue.listen((DatabaseEvent databaseEvent) {
      dynamic readCurr = databaseEvent.snapshot.value;
      if (readCurr == null) {
        dCurr = 0;
      } else {
        setState(() {
          dCurr = readCurr;
        });
      }
    });
  }

  //////////////////////////////////READ VOLTAGE///////////////////////////////////////////////////////////
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

  //////////////////////////////////// SERVER RESPONSE /////////////////////////////////////////////////////////
  motorStatus() {
    readRef.onValue.listen((DatabaseEvent databaseEvent) {
      var motorstatus = databaseEvent.snapshot.value;
      bool ismounted = false;

      switch (motorstatus) {
        case 0:
          setState(() {
            status = "Motor Turned OFF";
          });
          AwesomeNotifications()
              .dismissNotificationsByChannelKey("motor_notifications");
          ismounted = false;
          break;
        case 1:
          setState(() {
            status = "Motor Turned ON";
            if (ismounted == false) {
              showNotification();
              ismounted = true;
            }
          });

          break;

        case 2:
          setState(() {
            status = "DRY RUN ! ";
          });
          if (ScaffoldMessenger.of(context).mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("WARNING : DRY RUN DETECTED ! "),
              ),
            );
          }

          break;

        case 3:
          {
            setState(() {
              status = "Connection Lost";
            });
          }

          break;
        default:
          setState(() {
            status = "Waiting for Response....";
          });
          break;
      }
    });
  }
  //////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    motorStatus();
    voltageRead();
    currentRead();
    super.initState();
  }

  @override
  void dispose();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "MOTOR CONTROLS",
          )),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(50),
            child: Image.asset(
              "assets/motor_ico.png",
              height: 90,
              width: 90,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green)),
                  onPressed: () {
                    uploadRef.update({'REQ_STATUS': 1});
                    motorStatus();
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
                    motorStatus();
                  },
                  child: const Text("OFF",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700))),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 30),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 10,
                color: Colors.blueGrey,
                child: SizedBox(
                  width: 200,
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            "🔋Main Grid ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "segoe",
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          )),
                      Row(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: const Text(
                                "VOLTAGE : ",
                                style: TextStyle(
                                  fontFamily: "segoe",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              )),
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "$dVolt",
                                style: const TextStyle(
                                    fontFamily: 'SevenSegment',
                                    fontStyle: FontStyle.italic,
                                    fontSize: 35,
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.w800),
                              )),
                          Container(
                              alignment: Alignment.bottomRight,
                              child: const Text(
                                "V",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: const Text(
                                "CURRENT : ",
                                style: TextStyle(
                                  fontFamily: "segoe",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              )),
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "$dCurr",
                                style: const TextStyle(
                                    fontFamily: 'SevenSegment',
                                    fontStyle: FontStyle.italic,
                                    color: Colors.yellow,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w800),
                              )),
                          Container(
                              alignment: Alignment.bottomRight,
                              child: const Text(
                                "A",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: const Text(
                                "POWER : ",
                                style: TextStyle(
                                  fontFamily: "segoe",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              )),
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "${dVolt * dCurr}",
                                style: const TextStyle(
                                    fontFamily: 'SevenSegment',
                                    fontStyle: FontStyle.italic,
                                    fontSize: 35,
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.w800),
                              )),
                          Container(
                              alignment: Alignment.bottomRight,
                              child: const Text(
                                "W",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 10,
                color: Colors.blueGrey,
                child: SizedBox(
                  width: 150,
                  height: 200,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Water Usage💧",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                          child: Text(
                            "$dVolt",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 45,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            "Ltr",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.amberAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Card(
            elevation: 15,
            color: Colors.blueGrey,
            child: SizedBox(
              height: 250,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Timer 🔔",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Set Interval ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Switch(
                        value: false,
                        onChanged: ((value) {}),
                        activeTrackColor: Colors.green,
                        activeColor: Colors.lightGreenAccent,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "Set Time : ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: TextButton(
                            onPressed: () {
                              showTimePicker(
                                builder: (context, child) => MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: true),
                                  child: child ?? Container(),
                                ),
                                context: context,
                                initialTime: TimeOfDay.now(),
                                initialEntryMode: TimePickerEntryMode.inputOnly,
                              );
                            },
                            child: const Text(
                              "00:00",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "Remaing : ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "00:00 ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 238, 113, 74),
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 10,
            color: Colors.blueGrey,
            child: SizedBox(
              height: 250,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Clock ⏰",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Set Clock    ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Switch(
                        value: false,
                        onChanged: ((value) {}),
                        activeTrackColor: Colors.green,
                        activeColor: Colors.lightGreenAccent,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "Start Time : ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextButton(
                          onPressed: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                          },
                          child: const Text(
                            "00:00 ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "End Time : ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextButton(
                          onPressed: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                          },
                          child: const Text(
                            "00:00 ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

void showNotification() async {
  bool isallowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isallowed) {
    //no permission of local notification
    AwesomeNotifications().requestPermissionToSendNotifications();
  } else {
    //show notification
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 1,
      channelKey: 'motor_notifications',
      title: 'Kelpie : MOTOR IS RUNNING',
      body: 'This is to notify you that motor is running !',
      autoDismissible: false,
      locked: true,
    ));
  }
}
