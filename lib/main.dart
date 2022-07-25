import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_call_demo/next_page.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/nextPage': (BuildContext context) => new NextPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String phoneNumber = 'No call';
  int? state;
  late Animation<Color?> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    getPermission().then((value) {
      if (value) {
        PlatformChannel().callStream().listen((event) {
          var arr = event.split("-");
          phoneNumber = arr[0];
          state = int.tryParse(arr[1]);
          print("telefon: ${event}");
          setState(() {});
        });
      }
    });

    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.linear);
    animation =
        ColorTween(begin: Colors.white, end: Colors.blue).animate(curve);
    // Keep the animation going forever once it is started
    animation.addStatusListener((status) {
      // Reverse the animation after it has been completed
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      setState(() {});
    });
    // Remove this line if you want to start the animation later
    controller.forward();
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> getPermission() async {
    if (await Permission.phone.status == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.phone.request() == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const SizedBox(height: 16),
            Visibility(
              visible: (state ?? 0) == 0 ? false : true,
              child: AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget? child) {
                  return Container(
                    color: animation.value,
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/nextPage");
                      },
                      child: Text(state == 1
                          ? "Çalıyor"
                          : state == 2
                              ? "Açıldı"
                              : ""),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
