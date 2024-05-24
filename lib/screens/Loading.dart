import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/home",
              );
            },
            icon: Icon(Icons.add_to_home_screen),
            label: Text("Go to Home Screen"),
          )
        ],
      ),
    );
  }
}
