import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

// Parse the list of Stations
class Station {
  final String name;
  final String code;

  Station({required this.name, required this.code});

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      name: json['name'],
      code: json['code'],
    );
  }

  @override
  String toString() {
    return '$name ($code)';
  }
}

// Call the API to fetch the stations and merge Monument (if detected)
Future<List<Station>> fetchStations() async {
  final response = await http.get(Uri.parse('https://metro-rti.nexus.org.uk/api/stations/'));

  if (response.statusCode == 200) {
    try {
      Map<String, dynamic> data = jsonDecode(response.body);

      List<Station> stations = [];
      data.forEach((code, name) {
        stations.add(Station.fromJson({'code': code, 'name': name}));
      });

// Merge Monument stations
final mtsStation = stations.firstWhere((station) => station.code == 'MTS', orElse: () => Station(code: '', name: ''));
final mtwStation = stations.firstWhere((station) => station.code == 'MTW', orElse: () => Station(code: '', name: ''));

if (mtsStation.code.isNotEmpty && mtwStation.code.isNotEmpty) {
  stations.removeWhere((station) => station.code == 'MTS' || station.code == 'MTW');

  // Keep a single station listing for Monument, but store both codes
  stations.add(Station(code: 'MTS,MTW', name: 'Monument'));
}


      stations.sort((a, b) => a.name.compareTo(b.name)); 
      return stations;
    } catch (e) {
      print('Error parsing JSON: $e');
      return [];
    }
  } else {
    throw Exception('Failed to load stations: Status Code ${response.statusCode}');
    
  }
}

// Real time data
Future<List<TrainTime>> fetchRealTimeData(String stationCode, String platformNumber) async {
  List<String> stationCodes = stationCode.split(','); // Handle multiple station codes

  // Determine the correct station code based on the platform

  // Code to split Both Monument StationCodes into a their respective codes
  if (stationCodes.contains("MTS") && (platformNumber == "3" || platformNumber == "4")) {
    stationCode = "MTW";
  } else if (stationCodes.contains("MTW") && (platformNumber == "1" || platformNumber == "2")) {
    stationCode = "MTS";
  }

  final response = await http.get(Uri.parse('https://metro-rti.nexus.org.uk/api/times/$stationCode/$platformNumber'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => TrainTime.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load real-time data');
  }
}

// Parse the Returned Train Times
class TrainTime {
  final String trainNumber;
  final String destination;
  final String lastEvent;
  final String lastEventLocation;
  final DateTime lastEventTime;
  final String line;
  final int dueIn;

  TrainTime({
    required this.trainNumber,
    required this.lastEvent,
    required this.lastEventLocation,
    required this.lastEventTime,
    required this.dueIn,
    required this.destination,
    required this.line,
  });
  


  factory TrainTime.fromJson(Map<String, dynamic> json) {
    return TrainTime(
      trainNumber: json['trn'],
      destination: json['destination'],
      lastEvent: json['lastEvent'],
      lastEventLocation: json['lastEventLocation'],
      lastEventTime: DateTime.parse(json['lastEventTime']),
      dueIn: json['dueIn'], // Note: -1 = Arrived, 0 = Due
      line: json['line'],
    );
  }
}

// Update real time data
class RealTimeDataProvider {
  Timer? _timer;

  void startFetchingData(String stationCode, int platformNumber) {
    _timer = Timer.periodic(Duration(seconds: 15), (timer) { // Set Counter to intended update frequency (15 seconds)
      fetchRealTimeData(stationCode, platformNumber.toString()).then((data) {
        // Update your UI with the new data
      }).catchError((error) {
        // Handle errors
      });
    });
  }

  void stopFetchingData() {
    _timer?.cancel();
  }
}

Future<List<String>> fetchPlatforms(String stationCode) async {
  List<String> stationCodes = stationCode.split(','); // Handle multiple codes
  List<String> allPlatforms = [];

  for (String code in stationCodes) {
    final response = await http.get(Uri.parse('https://metro-rti.nexus.org.uk/api/stations/platforms'));

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey(code) && data[code] is List) {
          List<dynamic> platformData = data[code];

          for (var platform in platformData) {
            if (platform is Map<String, dynamic> && platform.containsKey('platformNumber')) {
              allPlatforms.add(platform['platformNumber'].toString());
            }
          }
        } else {
          print("No platforms found for station $code or incorrect JSON structure");
        }
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      throw Exception('Failed to load platforms: Status Code ${response.statusCode}');
    }
  }
  return allPlatforms;
}




