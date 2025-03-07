import 'package:flutter/material.dart';
import 'package:tynerail_tracker/rti_page.dart'; // Real-Time Info Page + Selection
import 'package:tynerail_tracker/theme.dart'; // File for where the colours and themes are specified
import 'package:tynerail_tracker/webpage.dart';
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
      darkTheme: darkAppTheme,
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
    Webpage(url: "https://metro-rti.nexus.org.uk/MapEmbedded",), // Load Live Map Webpage
    RealTimePage(), // Real Time Info Page
    Webpage(url: "https://www.nexus.org.uk/metro/app_menu/service-status",), // Loads Service Status Webpage
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
        title: const Text('Real Time Metro Data'),),

        // Hamburger Menu
        drawer: Drawer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                child: Center(child: Text("Tyne & Wear Metro Tracker", style: AppStyles.titleLarge,),),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.metroMaterial.shade800, AppColors.metroMaterial.shade300])
                ),
              ),

              ListTile(
                title: Text("About App"),
                leading: Icon(Icons.info_outline),

                onTap: () => showAboutDialog(
                  barrierDismissible: true,
                  context: context,
                  applicationName: "Metro Tracker",
                  applicationVersion: "v1.0.0",
                  children: [
                    // TODO - GitHub URL Opener
                    TextButton.icon(
                      icon: Icon(Icons.code),
                      label: Text("Useless Button"),
                      onPressed: null
                      )
                  ]
                ),

              )
            ],
          ),
        ),

        // Main Page Content
        body: _pages[_selectedIndex],

        // The Navigation at the bottom of the screen, what else did you expect?
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
              icon: Icon(Icons.notifications_none),
              activeIcon: Icon(Icons.notifications),
              label: "Service Status"
            ),

          ],
          onTap: _onNavBarTapped
          ),


    );
  }
}
