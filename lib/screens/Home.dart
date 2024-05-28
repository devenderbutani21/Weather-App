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
              borderRadius: BorderRadius.circular(24.0),
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
                const SizedBox(height: 20),
                const Text(
                  'My Location',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  weather!.cityName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10.0),
                Image.network(
                  'http://openweathermap.org/img/wn/${weather!.icon}@2x.png',
                  height: 100,
                  width: 100,
                ),
                Text(
                  '${weather!.temperature.round()}°C',
                  style: const TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'H:${weather!.tempMax.round()}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      'L:${weather!.tempMin.round()}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40.0),
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
          const SizedBox(height: 50.0),
          const Text(
            "Made By Devender",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget weatherDetailColumn(String iconPath, String label, String value) {
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
                  iconPath,
                  width: 28,
                  height: 28,
                ),
                const SizedBox(width: 10.0),
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
            const SizedBox(height: 10.0),
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
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
            height: MediaQuery.of(context).size.height * 0.25, // 25% of screen height
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter City Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      hintText: 'City Name',
                      hintStyle: TextStyle(color: Colors.black54),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
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
                        child: const Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
        elevation: 16.0,
        highlightElevation: 18.0,
      ),
    );
  }
}
