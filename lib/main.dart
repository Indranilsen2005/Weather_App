import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:weather_app/screens/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        useMaterial3: true,
        cardTheme: const CardTheme(
          color: Color.fromARGB(255, 97, 107, 249),
          elevation: 1,
        ),
        textTheme: GoogleFonts.latoTextTheme().apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.9)),
      ),
      home: const WeatherScreen(),
    );
  }
}
