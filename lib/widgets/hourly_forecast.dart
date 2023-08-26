import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({
    super.key,
    required this.hour,
    required this.icon,
    required this.temperature,
  });

  final String hour;
  final IconData icon;
  final String temperature;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 110,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                hour,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(icon, size: 35),
              Text(
                temperature,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}