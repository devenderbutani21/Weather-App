import 'package:flutter/material.dart';
import 'package:weatherapp/screens/Home.dart';
import 'package:weatherapp/screens/Loading.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[600],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.lightBlueAccent,
        ),
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
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      routes: {
        "/": (context) => const LoadingScreen(),
        "/home": (context) => const HomeScreen(),
        "/loading": (context) => const LoadingScreen(),
      },
    ),
  );
}
