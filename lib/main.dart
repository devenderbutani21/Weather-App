import 'package:flutter/material.dart';
import 'package:weatherapp/screens/Home.dart';
import 'package:weatherapp/screens/Loading.dart';
import 'package:weatherapp/screens/Choose Location.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => LoadingScreen(),
        "/home": (context) => Home(),
        "/loading": (context) => LoadingScreen(),
        "/location": (context) => ChooseLocation(),
      },
    ),
  );
}
