// VeggiesAI: Designed by Surajit Basak, coded with Grok (xAI), March 2025
// A Flutter app to suggest veggie setups based on location and weather
// Relplace 'YOUR_API_KEY_HERE' with your API key for weather update. I used OpenWeatherMap.

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Global storage for location + weather (persists across page visits)
String? storedLocation;
String? storedWeatherInfo;
IconData? storedWeatherIcon;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: LocationSelectionScreen(),
    );
  }
}

// Page 1: Where to Grow? (No Back Arrow)
class LocationSelectionScreen extends StatefulWidget {
  @override
  _LocationSelectionScreenState createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  List<String> selectedLocations = [];

  void _toggleSelection(String location) {
    setState(() {
      if (selectedLocations.contains(location)) selectedLocations.remove(location);
      else selectedLocations.add(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.brown[100]!, Colors.green[400]!])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Where will your veggie adventure begin?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              SizedBox(height: 10),
              Text("Tap all the spots you’re dreaming of!", style: TextStyle(fontSize: 16, color: Colors.white70)),
              SizedBox(height: 40),
              _buildOptionButton("Balcony"),
              SizedBox(height: 20),
              _buildOptionButton("Lawn/Backyard"),
              SizedBox(height: 20),
              _buildOptionButton("Rooftop"),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: selectedLocations.isEmpty ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlantingTypeScreen(selectedLocations: selectedLocations))),
                child: Text("Let’s Go!", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String title) {
    bool isSelected = selectedLocations.contains(title);
    return GestureDetector(
      onTap: () => _toggleSelection(title),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[700] : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))],
        ),
        child: Text(title, style: TextStyle(fontSize: 20, color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      ),
    );
  }
}

// Page 2: Planting Type Selection (With Back Arrow)
class PlantingTypeScreen extends StatefulWidget {
  final List<String> selectedLocations;

  PlantingTypeScreen({required this.selectedLocations});

  @override
  _PlantingTypeScreenState createState() => _PlantingTypeScreenState();
}

class _PlantingTypeScreenState extends State<PlantingTypeScreen> {
  List<String> selectedPlantingTypes = [];

  void _toggleSelection(String type) {
    setState(() {
      if (selectedPlantingTypes.contains(type)) selectedPlantingTypes.remove(type);
      else selectedPlantingTypes.add(type);
    });
  }

  void _showInfoDialog(String type) {
    String title, description;
    switch (type) {
      case "Soil-based":
        title = "Soil-based Planting";
        description = "The classic way to grow! Soil-based planting uses nutrient-rich earth to support your veggies. It’s simple, natural, and perfect for traditional gardening.";
        break;
      case "Hydroponic":
        title = "Hydroponic Planting";
        description = "Soil-less and water-smart! Hydroponics grows plants in nutrient-infused water, often indoors or in small spaces—ideal for urban setups.";
        break;
      case "Aquaponic":
        title = "Aquaponic Planting";
        description = "Fish and plants team up! Aquaponics combines hydroponics with fish farming—fish waste feeds the plants, and plants clean the water. Sustainable and cool!";
        break;
      default:
        title = "Info";
        description = "No details available.";
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(description, style: TextStyle(color: Colors.black87)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Got it!", style: TextStyle(color: Colors.green[700])))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.brown[100]!, Colors.green[400]!])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("How will you grow your green babies?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                  SizedBox(height: 10),
                  Text("Mix and match styles that spark joy!", style: TextStyle(fontSize: 16, color: Colors.white70)),
                  SizedBox(height: 40),
                  _buildOptionButton("Soil-based"),
                  SizedBox(height: 20),
                  _buildOptionButton("Hydroponic"),
                  SizedBox(height: 20),
                  _buildOptionButton("Aquaponic"),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: selectedPlantingTypes.isEmpty ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => WeatherScreen(selectedLocations: widget.selectedLocations, selectedPlantingTypes: selectedPlantingTypes))),
                    child: Text("Next Step!", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 28), onPressed: () => Navigator.pop(context), splashRadius: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String title) {
    bool isSelected = selectedPlantingTypes.contains(title);
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _toggleSelection(title),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green[700] : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))],
              ),
              child: Text(title, style: TextStyle(fontSize: 20, color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
          ),
        ),
        SizedBox(width: 10),
        IconButton(icon: Icon(Icons.info_outline, color: Colors.white), onPressed: () => _showInfoDialog(title)),
      ],
    );
  }
}

// Page 3: Location + Weather (Updated - Fetch on Button Click)
class WeatherScreen extends StatefulWidget {
  final List<String> selectedLocations;
  final List<String> selectedPlantingTypes;

  WeatherScreen({required this.selectedLocations, required this.selectedPlantingTypes});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String location = storedLocation ?? 'Where are you growing?';
  String weatherInfo = storedWeatherInfo ?? 'Weather unknown';
  IconData? weatherIcon = storedWeatherIcon;
  bool isFetching = false;
  bool isLocationUpdated = storedLocation != null;

  Future<void> _getLocation() async {
    setState(() => isFetching = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          location = 'Enable location services';
          weatherInfo = 'Weather unavailable';
          weatherIcon = FontAwesomeIcons.exclamationTriangle;
          isFetching = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            location = 'Location permission denied';
            weatherInfo = 'Weather unavailable';
            weatherIcon = FontAwesomeIcons.exclamationTriangle;
            isFetching = false;
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      await _getCityState(position.latitude, position.longitude);
      await _fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        location = 'Error: $e';
        weatherInfo = 'Weather unavailable';
        weatherIcon = FontAwesomeIcons.exclamationTriangle;
        isFetching = false;
      });
    }
  }

  Future<void> _getCityState(double lat, double lon) async {
    final apiKey = 'YOUR_API_KEY_HERE';
    final url = 'https://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&appid=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            location = "${data[0]['name']}, ${data[0]['state'] ?? data[0]['country']}";
            storedLocation = location; // Store globally
          });
        }
      }
    } catch (e) {
      setState(() {
        location = 'Unknown Location';
        storedLocation = location;
      });
    }
  }

  Future<void> _fetchWeather(double lat, double lon) async {
    final apiKey = '99ee85828c3a86340b25ec1be0a9cade';
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String condition = data['weather'][0]['main'].toLowerCase();
        setState(() {
          weatherInfo = "${data['main']['temp']}°C, ${data['weather'][0]['description']}";
          weatherIcon = _getWeatherIcon(condition);
          storedWeatherInfo = weatherInfo; // Store globally
          storedWeatherIcon = weatherIcon;
          isFetching = false;
          isLocationUpdated = true; // Enable "See my suggestions"
        });
      } else {
        setState(() {
          weatherInfo = "Weather unavailable";
          weatherIcon = null;
          storedWeatherInfo = weatherInfo;
          storedWeatherIcon = weatherIcon;
          isFetching = false;
        });
      }
    } catch (e) {
      setState(() {
        weatherInfo = "Error fetching weather";
        weatherIcon = null;
        storedWeatherInfo = weatherInfo;
        storedWeatherIcon = weatherIcon;
        isFetching = false;
      });
    }
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition) {
      case "clear":
        return FontAwesomeIcons.sun;
      case "clouds":
        return FontAwesomeIcons.cloud;
      case "rain":
        return FontAwesomeIcons.cloudRain;
      case "drizzle":
        return FontAwesomeIcons.cloudShowersHeavy;
      case "thunderstorm":
        return FontAwesomeIcons.bolt;
      case "snow":
        return FontAwesomeIcons.snowflake;
      case "mist":
      case "fog":
        return FontAwesomeIcons.smog;
      default:
        return FontAwesomeIcons.questionCircle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.brown[100]!, Colors.green[400]!])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
                  child: Text(
                    "Your location will unlock a world of perfect veggie picks just for you!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white, shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 1))]),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2, offset: Offset(2, 5))]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isFetching
                                    ? CircularProgressIndicator(color: Colors.green[700])
                                    : Text(location, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                                SizedBox(height: 20),
                                if (weatherIcon != null && !isFetching) Icon(weatherIcon, size: 80, color: Colors.blue[800]),
                                SizedBox(height: 15),
                                Text(weatherInfo, style: TextStyle(fontSize: 18, color: Colors.black87), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: isLocationUpdated ? null : () => _getLocation(),
                        child: Text("Update My Location", style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: isLocationUpdated ? 0 : 5,
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: isLocationUpdated
                            ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => SuggestionScreen(selectedLocations: widget.selectedLocations, selectedPlantingTypes: widget.selectedPlantingTypes, locationWeather: "$location, $weatherInfo")))
                            : null,
                        child: Text("See My Suggestions!", style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[600],
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 5,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Weather powered by OpenWeatherMap (CC BY-SA 4.0)", style: TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 28), onPressed: () => Navigator.pop(context), splashRadius: 24),
            ),
          ],
        ),
      ),
    );
  }
}

// Page 4: Suggestion Screen
class SuggestionScreen extends StatefulWidget {
  final List<String> selectedLocations;
  final List<String> selectedPlantingTypes;
  final String locationWeather;

  SuggestionScreen({required this.selectedLocations, required this.selectedPlantingTypes, required this.locationWeather});

  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final List<Map<String, String>> suggestionPool = [
    {"veggie": "Hanging Tomatoes", "method": "Soil-based", "location": "Balcony"},
    {"veggie": "Hydroponic Basil", "method": "Hydroponic", "location": "Lawn/Backyard"},
    {"veggie": "Soil Spinach", "method": "Soil-based", "location": "Balcony"},
    {"veggie": "Hydroponic Lettuce", "method": "Hydroponic", "location": "Lawn/Backyard"},
    {"veggie": "Soil Okra", "method": "Soil-based", "location": "Lawn/Backyard"},
  ];

  late List<Map<String, String>> filteredSuggestions;
  List<bool> selectedSuggestions = [];

  @override
  void initState() {
    super.initState();
    filteredSuggestions = suggestionPool.where((s) => widget.selectedLocations.contains(s["location"]) && widget.selectedPlantingTypes.contains(s["method"])).toList();
    selectedSuggestions = List.generate(filteredSuggestions.length, (_) => true);
  }

  void _showDetailsDialog(Map<String, String> suggestion) {
    String veggie = suggestion["veggie"]!;
    String method = suggestion["method"]!;
    List<String> steps = method == "Hydroponic"
        ? ["1. Grab a tray", "2. Mix in nutrient water", "3. Pop in $veggie", "4. Place under light"]
        : ["1. Pick some pots", "2. Fill with rich soil", "3. Plant $veggie", "4. Set in ${suggestion['location']}"];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("$veggie (${suggestion['location']})", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("$method photo here", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            ...steps.map((step) => Padding(padding: EdgeInsets.only(bottom: 5), child: Text(step, style: TextStyle(color: Colors.black87)))),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Sweet!", style: TextStyle(color: Colors.green[700])))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.brown[100]!, Colors.green[400]!])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  Text("Your veggie magic starts here!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 1))])),
                  SizedBox(height: 10),
                  Text("Check out these awesome picks—keep what you love!", style: TextStyle(fontSize: 16, color: Colors.white70)),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = filteredSuggestions[index];
                        return Card(
                          color: Colors.white.withOpacity(0.9),
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: CheckboxListTile(
                            title: Text("${suggestion['veggie']} (${suggestion['location']})", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                            subtitle: Text(suggestion['method']!, style: TextStyle(color: Colors.grey[700])),
                            value: selectedSuggestions[index],
                            onChanged: (value) => setState(() => selectedSuggestions[index] = value!),
                            secondary: IconButton(icon: Icon(Icons.info_outline, color: Colors.green[700]), onPressed: () => _showDetailsDialog(suggestion)),
                            activeColor: Colors.green[700],
                            checkColor: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedSuggestions.contains(true)
                        ? () {
                            List<Map<String, String>> chosen = [];
                            for (int i = 0; i < filteredSuggestions.length; i++) {
                              if (selectedSuggestions[i]) chosen.add(filteredSuggestions[i]);
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (_) => PlantingGuideScreen(chosenSuggestions: chosen)));
                          }
                        : null,
                    child: Text("Grow Time!", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("More goodies coming soon!"))),
                    child: Text("Want more ideas?", style: TextStyle(fontSize: 16, color: Colors.white70, decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 28), onPressed: () => Navigator.pop(context), splashRadius: 24),
            ),
          ],
        ),
      ),
    );
  }
}

// Page 5: Planting Guide Screen
class PlantingGuideScreen extends StatelessWidget {
  final List<Map<String, String>> chosenSuggestions;

  PlantingGuideScreen({required this.chosenSuggestions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.brown[100]!, Colors.green[400]!])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  SizedBox(height: 60),
                  Text("Your Green Game Plan!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 1))])),
                  SizedBox(height: 10),
                  Text("Here’s how to bring your veggies to life!", style: TextStyle(fontSize: 16, color: Colors.white70)),
                  SizedBox(height: 20),
                  ...chosenSuggestions.map((suggestion) {
                    String veggie = suggestion["veggie"]!;
                    String method = suggestion["method"]!;
                    List<String> steps = method == "Hydroponic"
                        ? ["1. Grab a tray", "2. Mix in nutrient water", "3. Pop in $veggie", "4. Place under light"]
                        : ["1. Pick some pots", "2. Fill with rich soil", "3. Plant $veggie", "4. Set in ${suggestion['location']}"];
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$veggie (${suggestion['location']})", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                          SizedBox(height: 5),
                          Text(method, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Text("$method photo here", style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 10),
                          ...steps.map((step) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                                    SizedBox(width: 10),
                                    Expanded(child: Text(step, style: TextStyle(fontSize: 16, color: Colors.black87))),
                                  ],
                                ),
                              )),
                          SizedBox(height: 10),
                          Text("Video here", style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 15),
                          Center(
                            child: ElevatedButton(
                              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gear up soon—kits on the way!"))),
                              child: Text("Grab a $method Kit!", style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 28), onPressed: () => Navigator.pop(context), splashRadius: 24),
            ),
          ],
        ),
      ),
    );
  }
}
