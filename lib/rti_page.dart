import 'package:flutter/material.dart';
import 'package:tynerail_tracker/theme.dart';
import 'dart:async';
import 'api_service.dart'; // Ensure this file contains your API functions and Station class

class RealTimePage extends StatefulWidget {
  const RealTimePage({super.key});

  @override
  _RealTimePageState createState() => _RealTimePageState();
  
}

class _RealTimePageState extends State<RealTimePage> {
  Station? selectedStation; // Store the selected Station object
  String? selectedPlatform;
  List<Station> stations = []; // stations is a List of Station objects
  List<String> platforms = [];
  List<dynamic> trainData = [];
  Timer? timer;
  
  @override
  void initState() {
    super.initState();
    _fetchStations();
  }

// Create function to prompt user to retry
  void _showLoadError(String errorMessage, String stationCode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.warning),
        title: Text("Something went wrong"),
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        contentTextStyle: Theme.of(context).textTheme.bodyLarge,
        content: Text(errorMessage),
        actions: [
          TextButton.icon(
            label: Text("Retry"),
            icon: Icon(Icons.refresh),

            onPressed: () {
              // Check if error was station or platforms and retry accordingly.
              if (errorMessage.toLowerCase().contains("station")) {
                _fetchStations();
              } else if (stationCode.isEmpty) {
                AlertDialog(
                title: Text("Something went wrong."),
                );
              } else {
                _fetchPlatforms(stationCode);
              }
              Navigator.pop(context);
            },
          ),
        ],
      )
    );
  }

  Future<void> _fetchStations() async {
    try {
      List<Station> fetchedStations = (await fetchStations()).cast<Station>();
      setState(() {
        stations = fetchedStations;
      });
    } catch (e) {
      debugPrint('Error fetching stations: $e');
      _showLoadError("Failed to Load Stations\nCheck your network connection.", "");

    }
  }

  Future<void> _fetchPlatforms(String stationCode) async { // Takes station *code*
    try {
      List<String> fetchedPlatforms = (await fetchPlatforms(stationCode)).cast<String>();
      setState(() {
        platforms = fetchedPlatforms;
        selectedPlatform = null;
      });
    } catch (e) {
      debugPrint('Error fetching platforms: $e');
      _showLoadError("Failed to Load Stations\nCheck your network connection.", stationCode);
    }
  }

  Future<void> _fetchTrainData() async {
    if (selectedStation != null && selectedPlatform != null) {
      try {
        List<dynamic> data = await fetchRealTimeData(selectedStation!.code, selectedPlatform!); // Use station code
        setState(() {
          trainData = data;
        });
      } catch (e) {
        debugPrint('Error fetching train data: $e');
      }
    }
  }

  void _startAutoRefresh() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _fetchTrainData();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Add Disclaimer to ensure users know I'm not affiliated with Nexus.
            ListTile(
              title: Text("This app is not affiliated with Nexus or any official transport authority.", textAlign: TextAlign.center,),
              titleAlignment: ListTileTitleAlignment.center,
            ),
            
            DropdownButton<Station>( // Dropdown for Station objects
              style: Theme.of(context).textTheme.labelMedium,
              value: selectedStation,
              hint: const Text(
                'Select a station',
                style: AppStyles.labelMedium,
              ),
              items: stations.map((station) {
                return DropdownMenuItem<Station>(
                  value: station,
                  child: Text( // Station name text
                    station.name,
                    style: Theme.of(context).textTheme.labelMedium, // Get formatting from the label medium formatting
                  ), // Display station name
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStation = value;
                  selectedPlatform = null;
                  platforms = [];
                  trainData = [];
                });
                if (value != null) _fetchPlatforms(value.code); // Pass station code
              },
            ),
            if (platforms.isNotEmpty)
              DropdownButton<String>(
                value: selectedPlatform,
                hint: const Text(
                  'Select a platform',
                  style: AppStyles.labelMedium,
                  ),
                items: platforms.map((platform) {
                  return DropdownMenuItem<String>(
                    value: platform,
                    child: Text(
                      "Platform $platform",
                      style: AppStyles.labelMedium,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPlatform = value;
                    trainData = [];
                  });
                  if (value != null) {
                    _fetchTrainData();
                    _startAutoRefresh();
                  }
                },
              ),
            SizedBox(
              height: 2,
              child: Container(color: AppColors.dropdownToLists,),
            ),
            Expanded(
  child: stations.isEmpty 
    ? Center(
        child: CircularProgressIndicator(),
      )
    : selectedPlatform == null || selectedStation == null
      ? Center(
          child: Text(
          'Select a Station & Platform to Continue',
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
          )
        )
    : selectedPlatform != null && selectedStation != null && trainData.isEmpty
      ? Center(
          child: Text(
          'No data available!\nTry Another Platform\nor Check Service Status',
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
          )
        )
      : ListView.builder(
          itemCount: trainData.length,
          itemBuilder: (context, index) {
            final train = trainData[index];

            return ListTile(
              title: Text(
                train.destination, // Use train.destination
                style: Theme.of(context).textTheme.titleLarge, // Use headline style
                ),
              subtitle: Text(
                cleanLastEvent(train.lastEvent, train.lastEventLocation, train.lastEventTime),
                style: Theme.of(context).textTheme.bodyLarge, // Use normal text style
                ),
                trailing: Text(
                  checkArrived(train.dueIn), // Call function to show cleaner text
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: train.dueIn < 2 ? ColorScheme.of(context).onSecondary : null,
                  ),
                  textAlign: TextAlign.center, // Align Due text to Centre
                ),
                tileColor: train.dueIn < 2 ? ColorScheme.of(context).primary : null,
                titleAlignment: ListTileTitleAlignment.center,
                isThreeLine: true,

              minVerticalPadding: 5,
              leading: Container(
                alignment: Alignment.centerLeft,
                width: 8,
                margin: EdgeInsets.symmetric(horizontal: 0),
                padding: EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  color: checkLineColor(train.line),
                  shape: BoxShape.rectangle,
                ),
              ),
              minLeadingWidth: 1,
              
            );
          },
        ),
),
          ],
        ),
      );

}

// Some Boring Functions to just re-format the API data into something readable

// Check line colours and return appropriate material colour
Color checkLineColor(String line) {
  if (line == "YELLOW") {
    return AppColors.yellowLine;
  } else if (line == "GREEN") {
    return AppColors.greenLine;
  } else {
    return AppColors.defaultLine;
  }
}

// Check if minute remaing is accurate to avoid displaying "-1 mins" to the user
String checkArrived(dueIn) {
  if (dueIn == 0) {
    // When theres a minute before the arrival, mark the train as due.
    return "Due";

  } else if (dueIn == -1) {
    // If due in = -1, assume it has arrived.
    return "Arrived";
  } else {
    // If nothing of the above applies, show the minute counter.
    return "Due In:\n$dueIn mins";
  }
}

// Process the lastEvent items into something easier to read
String cleanLastEvent(String lastEvent, String lastEventLocation, DateTime lastEventTime) {
  // Regular expression to match "Platform X" at the end of the string
  final platformRegex = RegExp(r'Platform \d+$');

  // Remove "Platform X" if it exists and trim extra spaces
  String cleanLocation = lastEventLocation.replaceAll(platformRegex, '').trim();

  // Format time properly
  String formattedTime = "(${lastEventTime.toLocal().hour.toString().padLeft(2, '0')}:${lastEventTime.minute.toString().padLeft(2, '0')})";

  if (lastEvent == "READY_TO_START") {
    return "Ready to Start:\n$cleanLocation $formattedTime";
  } else if (lastEvent == "ARRIVED") {
    return "Arrived At:\n$cleanLocation $formattedTime";
  } else if (lastEvent == "DEPARTED") {
    return "Departed:\n$cleanLocation $formattedTime";
  } else if (lastEvent == "APPROACHING") {
    return "Approaching:\n$cleanLocation $formattedTime";
  } else {
    return "Status Unknown";
  }
}

}