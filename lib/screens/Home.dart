import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  Weather? weather;
  bool isLoading = false;
  String errorMessage = '';
  final TextEditingController _cityController = TextEditingController();

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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            height: 380,
            width: 380,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(
                24.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Text(
                  weather!.cityName,
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Image.network(
                  'http://openweathermap.org/img/wn/${weather!.icon}@2x.png',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 20.0),
                Text(
                  '${weather!.temperature.round()}°C',
                  style: const TextStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: weatherDetailColumn(
                  'assets/images/thermometer.png',
                  'Feels Like',
                  '${weather!.feelsLike.round()}°C',
                ),
              ),
              Expanded(
                child: weatherDetailColumn(
                  'assets/images/barometer.png',
                  'Pressure',
                  '${weather!.pressure} hPa',
                ),
              ),
            ],
          ),
          const SizedBox(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: weatherDetailColumn(
                  'assets/images/hygrometer.png',
                  'Humidity',
                  '${weather!.humidity}%',
                ),
              ),
              Expanded(
                child: weatherDetailColumn(
                  'assets/images/wind_gauge.png',
                  'Wind Speed',
                  '${weather!.windSpeed.round()} m/s',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget weatherDetailColumn(String location, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  location,
                  width: 28,
                  height: 28,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28.0,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Enter City Name',
            style: TextStyle(
              color: Colors.blue[300],
            ),
          ),
          content: TextField(
            controller: _cityController,
            decoration: InputDecoration(
              hintText: 'City Name',
              hintStyle: TextStyle(
                color: Colors.blue[300],
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue[300]!),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue[300]!),
              ),
            ),
            style: TextStyle(
              color: Colors.blue[300], // Text color
              fontWeight: FontWeight.bold, // Bold text
            ),
            cursorColor: Colors.blue[300], // Cursor color
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue[300],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_cityController.text.isNotEmpty) {
                  fetchWeatherData(_cityController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Search',
                style: TextStyle(
                  color: Colors.blue[300],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[200]!,
              Colors.blue[600]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: weather == null
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                )
              : buildWeatherInfo(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSearchDialog,
        child: const Icon(
          Icons.search_sharp,
          color: Colors.black,
          size: 38,
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}
