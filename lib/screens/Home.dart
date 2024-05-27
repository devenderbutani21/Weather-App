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
        Image.network(
          'http://openweathermap.org/img/wn/${weather!.icon}@2x.png',
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
            Expanded(
                child: weatherDetailColumn(
                    'Feels Like', '${weather!.feelsLike}°C')),
            Expanded(
                child:
                    weatherDetailColumn('Min Temp', '${weather!.tempMin}°C')),
            Expanded(
                child:
                    weatherDetailColumn('Max Temp', '${weather!.tempMax}°C')),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: weatherDetailColumn(
                    'Pressure', '${weather!.pressure} hPa')),
            Expanded(
                child:
                    weatherDetailColumn('Humidity', '${weather!.humidity}%')),
            Expanded(
                child: weatherDetailColumn(
                    'Wind Speed', '${weather!.windSpeed} m/s')),
            Expanded(
                child: weatherDetailColumn(
                    'Wind Direction', '${weather!.windDeg}°')),
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
              ), // Hint text color
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue[300]!,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue[300]!,
                ),
              ),
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
        color: Colors.blue[300],
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: weather == null
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : buildWeatherInfo(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSearchDialog,
        child: Icon(
          Icons.search_sharp,
          color: Colors.white,
          size: 32,
        ),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
