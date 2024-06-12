import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mobile/screens/devices_screen.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/widgets/ble_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  List<Widget> body = const [
    HomeScreen(),
    DevicesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.off) {
        showDialog(
            context: context,
            builder: (context) {
              return const BleDialog();
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: "NotoSansMono",
            scaffoldBackgroundColor: Colors.black,
            textTheme:
                const TextTheme(bodyMedium: TextStyle(color: Colors.white))),
        home: Scaffold(
          appBar: AppBar(
              title: const Text("ISP",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green)),
              centerTitle: true,
              backgroundColor: Colors.black),
          body: body[_currentIndex],
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.green,
              tabBackgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                if (mounted) {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: "HOME",
                ),
                GButton(
                  icon: Icons.devices_rounded,
                  text: "DEVICES",
                )
              ],
              gap: 8,
            ),
          ),
        ));
  }
}
