import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weatherapp/services/api_service.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final ApiService apiService = ApiService();

  void startApp() async {
    try {
      final weather = await apiService.fetchWeather('Toronto');
      Navigator.pushReplacementNamed(context, '/home', arguments: weather);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              'Failed to load weather data: $e',
              style: TextStyle(
                color: Colors.black87,
              ),
            )),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    startApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/logo.png", height: 240, width: 240),
            // Adjust path as needed
            Text(
              "Weather App",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Made By Devender",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            SpinKitThreeBounce(
              color: Colors.white,
              size: 50.0,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[300],
    );
  }
}
