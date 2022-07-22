import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_call_demo/platform_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String phoneNumber = 'No call';

  @override
  void initState() {
    super.initState();

    getPermission().then((value) {
      if (value) {
        PlatformChannel().callStream().listen((event) {
          phoneNumber = event;
          print("telefon: ${event}");
          setState(() {});
        });
      }
    });
  }

  Future<bool> getPermission() async {
    if (await Permission.contacts.status == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.contacts.request() == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Get Phone Number'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Incoming call number:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(phoneNumber, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
