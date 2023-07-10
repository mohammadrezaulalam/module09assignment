import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String _lastUpdated = '';

  String _temperature = '';
  String _minTemp = "";
  String _maxTemp = "";
  String _description = '';
  String _iconUrl = '';
  String currentLocation = 'dhaka';
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    const apiKey = '75c0ad7c3f31401c0a629526e66cd13a';

    String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$currentLocation&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final weatherData = jsonDecode(response.body);
        setState(() {
          _temperature =
              (weatherData['main']['temp'] - 273.15).toStringAsFixed(0);
          _iconUrl = weatherData['weather'][0]['icon'];
          _minTemp =
              (weatherData['main']['temp_min'] - 273.15).toStringAsFixed(0);
          _maxTemp =
              (weatherData['main']['temp_max'] - 273.15).toStringAsFixed(0);
          _description = weatherData['weather'][0]['description'];
          _isLoading = false;

          _lastUpdated = DateFormat('hh:mm a').format(DateTime.now());
        });
      } else {
        /**/
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App', style: GoogleFonts.exo2(
            textStyle:
            Theme.of(context).textTheme.displayLarge,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Colors.blue,
                // Colors.lightBlueAccent,
                Colors.deepPurple.shade500,
                Colors.purple
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(
              color: Colors.white,
            )
                : _hasError
                ? const Text(
              'Error fetching weather data.',
              style: TextStyle(color: Colors.white),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentLocation.capitalize(),
                  style: GoogleFonts.exo2(
                    textStyle:
                    Theme.of(context).textTheme.displayLarge,
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Updated: $_lastUpdated',
                  style: GoogleFonts.exo2(
                    textStyle:
                    Theme.of(context).textTheme.displayLarge,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://openweathermap.org/img/w/$_iconUrl.png',
                      width: 100,
                      height: 120,
                    ),
                    Text(
                      '$_temperature°',
                      style: GoogleFonts.exo2(
                        textStyle:
                        Theme.of(context).textTheme.displayLarge,
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          'Max: $_maxTemp°',
                          style: GoogleFonts.exo2(
                            textStyle:
                            Theme.of(context).textTheme.displayLarge,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Min: $_minTemp°',
                          style: GoogleFonts.exo2(
                            textStyle:
                            Theme.of(context).textTheme.displayLarge,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  _description.capitalize(),
                  style: GoogleFonts.exo2(
                    textStyle:
                    Theme.of(context).textTheme.displayLarge,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension MyExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
