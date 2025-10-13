import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';



class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? weatherData;
  bool loading = false;

  //  Access Api Key https://home.openweathermap.org/api_keys
  final String apiKey = "b1b15e88fa797225412429c1c50c122a1"; // <--- Replace this

  Future<void> _fetchWeatherByCity(String city) async {
    setState(() => loading = true);
    try {
      final url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");
      final res = await http.get(url);
      if (res.statusCode == 200) {
        setState(() => weatherData = jsonDecode(res.body));
      } else {
        _showSnack("City not found!");
      }
    } catch (e) {
      _showSnack("Error fetching weather: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _fetchWeatherByLocation() async {
    setState(() => loading = true);
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        setState(() => weatherData = jsonDecode(res.body));
      } else {
        _showSnack("Unable to get location weather!");
      }
    } catch (e) {
      _showSnack("Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  String _getAnimation(String condition) {
    if (condition.contains("rain")) return "assets/rain.json";
    if (condition.contains("cloud")) return "assets/cloud.json";
    if (condition.contains("sun") || condition.contains("clear")) {
      return "assets/sun.json";
    }
    if (condition.contains("snow")) return "assets/snow.json";
    return "assets/wind.json";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🌤️ AI Weather App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter city name",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _fetchWeatherByCity(_controller.text.trim());
                    }
                  },
                ),
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _fetchWeatherByLocation,
              icon: const Icon(Icons.my_location),
              label: const Text("Get Current Location Weather"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, minimumSize: const Size.fromHeight(50)),
            ),
            const SizedBox(height: 20),
            if (loading)
              const Center(child: CircularProgressIndicator())
            else if (weatherData != null)
              Expanded(
                child: _buildWeatherCard(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    final condition = weatherData!["weather"][0]["main"].toString().toLowerCase();
    final city = weatherData!["name"];
    final temp = weatherData!["main"]["temp"].toString();
    final humidity = weatherData!["main"]["humidity"].toString();
    final wind = weatherData!["wind"]["speed"].toString();

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(city,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            Lottie.asset(_getAnimation(condition),
                height: 150, fit: BoxFit.cover),
            Text("$temp°C",
                style: const TextStyle(
                    fontSize: 40, fontWeight: FontWeight.w600)),
            Text(condition.toUpperCase(),
                style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoTile(Icons.water_drop, "Humidity", "$humidity%"),
                _infoTile(Icons.air, "Wind", "$wind km/h"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 30),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}