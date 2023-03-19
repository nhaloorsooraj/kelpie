import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

var status = "Check Internet Connection";

var tempID = FirebaseAuth.instance.currentUser?.email;
var userID = tempID?.replaceAll('.', 'DOT');
final uploadRef = FirebaseDatabase.instance.ref(userID);
final readRef = FirebaseDatabase.instance.ref('${userID!}/DEVICE_VALUE');
final readVoltRef = FirebaseDatabase.instance.ref('${userID!}/VOLTAGE_STATUS');
var dVolt = 0;

class MotorControls extends StatefulWidget {
  const MotorControls({super.key});

  @override
  State<MotorControls> createState() => _MotorControlsState();
}

class _MotorControlsState extends State<MotorControls> {
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
      var statusLed = databaseEvent.snapshot.value;

      switch (statusLed) {
        case 0:
          setState(() {
            status = "Motor Turned OFF";
          });
          dismissNotification();

          break;
        case 1:
          setState(() {
            status = "Motor Turned ON";
          });
          showNotification();

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
              height: 100,
              width: 100,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    "VOLTAGE",
                    style: TextStyle(
                      fontFamily: "segoe",
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  )),
              SizedBox(
                  width: 300,
                  child: SfLinearGauge(
                    minimum: 100,
                    maximum: 300,
                    ranges: const [
                      LinearGaugeRange(
                        startValue: 0,
                        endValue: 200,
                        color: Colors.orange,
                      ),
                      LinearGaugeRange(
                          startValue: 200, endValue: 250, color: Colors.green),
                      LinearGaugeRange(
                          startValue: 250, endValue: 400, color: Colors.red)
                    ],
                    markerPointers: [
                      LinearShapePointer(value: dVolt.toDouble())
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.all(10),
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
      //simgple notification
      id: 123,
      channelKey: 'basic', //set configuration wuth key "basic"
      title: 'Kelpie : MOTOR IS RUNNING',
      body: 'This is to notify you that motor is running !',
      autoDismissible: true,
      locked: true,
    ));
  }
}

void dismissNotification() async {
  if (await AwesomeNotifications().isNotificationAllowed()) {
    AwesomeNotifications().dismissAllNotifications();
  }
}
