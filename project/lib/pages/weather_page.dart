import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project/model/weather_model.dart';
import 'package:project/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  final weatherService = WeatherService('6ce62dbd27a5b9197fa572b4c71a920d');
  Weather? _weather;

  fetchWeather() async {
    String cityName = await weatherService.getCurrentCity();

    try {
      final weather = await weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (error) {
      print(error);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainny.json';
      case 'thunderstorm':
        return 'assets/stormy.json';
      case 'clear':
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();

    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(125.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.location_on, color: Colors.grey),
              Text(
                _weather?.cityName.toUpperCase() ?? "Loading city ...",
                style: const TextStyle(color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ]),
            Lottie.asset(getWeatherAnimation(
                getWeatherAnimation(_weather?.mainCondition))),
            Text(
              '${_weather?.temperature.round()}℃',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            )
          ],
        ),
      )),
    );
  }
}
