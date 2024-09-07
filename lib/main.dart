import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:workmanager/workmanager.dart';

const task = "call_listener";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    return Future.value(true);
  });
}

main() {
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    "1",
    task,
    frequency: const Duration(minutes: 15),
  );

  runApp(
    const MaterialApp(
      home: Example(),
    ),
  );
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  PhoneState status = PhoneState.nothing();
  bool granted = false;
  DateTime? callStartTime;

  // Function to request permission for phone access
  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();

    // Handling different permission states
    return switch (status) {
      PermissionStatus.denied ||
      PermissionStatus.restricted ||
      PermissionStatus.limited ||
      PermissionStatus.permanentlyDenied =>
        false,
      PermissionStatus.provisional || PermissionStatus.granted => true,
    };
  }

  @override
  void initState() {
    super.initState();
    requestPermission().then((isGranted) {
      if (isGranted) {
        setStream();
      }
    });
  }

  // Function to listen to the phone state stream
  void setStream() {
    PhoneState.stream.listen((event) {
      setState(() {
        status = event;
        if (status.status == PhoneStateStatus.CALL_STARTED) {
          callStartTime = DateTime.now();
          Timer.periodic(const Duration(seconds: 1), (Timer t) {
            setState(() {});
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone State'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (status.status == PhoneStateStatus.CALL_STARTED)
              const Text(
                'Ongoing call',
                style: TextStyle(fontSize: 24),
              ),
            if (status.status == PhoneStateStatus.CALL_STARTED)
              Text(
                "Call Duration: ${formatDuration()}",
                style: const TextStyle(fontSize: 24),
              )
            else
              const Text(
                "Listening for calls...",
                style: TextStyle(fontSize: 24),
              ),
          ],
        ),
      ),
    );
  }

  // Function to format the call duration to seconds
  String formatDuration() {
    final duration = DateTime.now().difference(callStartTime!);

    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return "$minutes:$seconds";
  }
}
