import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/widgets/additional_information.dart';
import 'package:weather_app/widgets/hourly_forecast.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 235,
              width: double.infinity,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '27° C',
                          style: TextStyle(fontSize: 45),
                        ),
                        Icon(Icons.cloud, size: 70),
                        Text(
                          'Rain',
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Weather Forecast',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyForecast(
                      hour: '03:00', icon: Icons.cloud, temperature: '25 C'),
                  HourlyForecast(
                      hour: '03:00', icon: Icons.cloud, temperature: '25 C'),
                  HourlyForecast(
                      hour: '03:00', icon: Icons.cloud, temperature: '25 C'),
                  HourlyForecast(
                      hour: '03:00', icon: Icons.cloud, temperature: '25 C'),
                  HourlyForecast(
                      hour: '03:00', icon: Icons.cloud, temperature: '25 C'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Additional Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AdditionalInformation(
                    icon: Icons.water_drop, title: 'Humadity', value: '82%'),
                AdditionalInformation(
                    icon: Icons.air, title: 'Wind Speed', value: '123.56'),
                AdditionalInformation(
                    icon: Icons.sunny, title: 'UV Index', value: '123.56'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
