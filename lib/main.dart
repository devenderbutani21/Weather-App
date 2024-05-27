import 'package:flutter/material.dart';
import 'package:weatherapp/screens/Home.dart';
import 'package:weatherapp/screens/Loading.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      routes: {
        "/": (context) => LoadingScreen(),
        "/home": (context) => HomeScreen(),
        "/loading": (context) => LoadingScreen(),
      },
    ),
  );
}
