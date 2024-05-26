import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  Weather? weather;
  bool isLoading = false;
  String errorMessage = '';

  void fetchWeatherData(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final fetchedWeather = await apiService.fetchWeather(city);
      setState(() {
        weather = fetchedWeather;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData('Toronto'); // Fetch weather data for Toronto initially
  }

  Widget buildWeatherInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          weather!.cityName,
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          weather!.description.titleCase,
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          '${weather!.temperature}°C',
          style: TextStyle(
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: weatherDetailColumn('Feels Like', '${weather!.feelsLike}°C')),
            Expanded(child: weatherDetailColumn('Min Temp', '${weather!.tempMin}°C')),
            Expanded(child: weatherDetailColumn('Max Temp', '${weather!.tempMax}°C')),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: weatherDetailColumn('Pressure', '${weather!.pressure} hPa')),
            Expanded(child: weatherDetailColumn('Humidity', '${weather!.humidity}%')),
            Expanded(child: weatherDetailColumn('Wind Speed', '${weather!.windSpeed} m/s')),
            Expanded(child: weatherDetailColumn('Wind Direction', '${weather!.windDeg}°')),
          ],
        ),
      ],
    );
  }

  Widget weatherDetailColumn(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/weather_bg.jpg'), // Add a background image
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
              : errorMessage.isNotEmpty
              ? Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          )
              : weather != null
              ? buildWeatherInfo()
              : Text(
            'Enter a city',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchWeatherData('Toronto'); // Update this line to fetch weather for another city if needed
        },
        child: Icon(Icons.search),
        backgroundColor: Colors.blueGrey[900],
      ),
    );
  }
}
