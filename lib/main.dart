import 'package:flutter/material.dart';
import 'package:tynerail_tracker/rti_page.dart'; // Real-Time Info Page + Selection
import 'package:tynerail_tracker/service_status.dart';
import 'package:tynerail_tracker/live_map.dart';
import 'package:tynerail_tracker/theme.dart'; // File for where the colours and themes are specified
import 'dart:async';
import 'api_service.dart'; // Ensure this file contains your API functions and Station class

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Station? selectedStation; // Store the selected Station object
  String? selectedPlatform;
  List<Station> stations = []; // stations is a List of Station objects
  List<String> platforms = [];
  List<dynamic> trainData = [];
  Timer? timer;
  int _selectedIndex = 1; // Defaults to Real Time info Page

    // List of pages
  final List<Widget> _pages = [
    LiveMapPage(),
    RealTimePage(), // Real Time Info Page (rti_page.dart)
    ServiceStatusPage(), // Service Status Page (service_status.dart)
  ];

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Time Metro Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.question_mark, semanticLabel: "About",),
            color: Colors.white,
            onPressed: null,
          ),
        ],
        ),

        body: _pages[_selectedIndex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: "Live Map"
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.subway_outlined),
              activeIcon: Icon(Icons.subway),
              label: "Tracking",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              activeIcon: Icon(Icons.info),
              label: "Service Status"
            ),

          ],
          onTap: _onNavBarTapped
          ),


    );
  }
}
