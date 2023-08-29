import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:weather_app/icons/weather_icons.dart';
import 'package:weather_app/widgets/additional_information.dart';
import 'package:weather_app/widgets/hourly_forecast.dart';
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=London,uk&units=metric&APPID=$apiKey',
        ),
      );
      final responseData = jsonDecode(response.body);
      if (responseData['cod'] != '200') {
        throw 'An unexpected error occured!!!';
      }

      return responseData;
    } catch (e) {
      throw 'An unexpected error occured!!!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 120, 140, 251),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 120, 140, 251),
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.square(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 1,
              horizontal: 15,
            ),
            child: ListTile(
              title: const Text(
                'London',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
              leading: const Icon(Icons.search),
              trailing: const Icon(Icons.location_city),
              tileColor: Colors.white,
              onTap: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final currentWeatherData = snapshot.data!['list'][0];
          final currentTemperature = currentWeatherData['main']['temp'];
          final currentFeelsLikeTemperature =
              currentWeatherData['main']['feels_like'];
          final currentWeatherDescription =
              currentWeatherData['weather'][0]['description'];
          final currentSky = currentWeatherData['weather'][0]['icon'];

          final sunriseTimeData = DateTime.fromMillisecondsSinceEpoch(
            snapshot.data!['city']['sunrise'] * 1000,
            isUtc: true,
          );
          final sunsetTimeData = DateTime.fromMillisecondsSinceEpoch(
            snapshot.data!['city']['sunset'] * 1000,
            isUtc: true,
          );

          final sunrise = DateFormat.jm().format(sunriseTimeData);
          final sunset = DateFormat.jm().format(sunsetTimeData);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 205,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${currentTemperature.toInt()}°',
                              style: const TextStyle(
                                fontSize: 110,
                                fontFamily: 'Times new roman',
                              ),
                            ),
                            Text(
                              '\t\t\tFeels like ${currentFeelsLikeTemperature.toInt()}°',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            SizedBox(
                              height: 180,
                              width: 180,
                              child: Image.network(
                                'https://openweathermap.org/img/wn/$currentSky@2x.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text(
                              '$currentWeatherDescription',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Hourly Forecast',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        final hourlyWeatherData =
                            snapshot.data!['list'][index + 1];
                        final hourlyTemperature =
                            hourlyWeatherData['main']['temp'].toInt();
                        final time =
                            DateTime.parse(hourlyWeatherData['dt_txt']);
                        final hourlySkyIconId =
                            hourlyWeatherData['weather'][0]['icon'];

                        return HourlyForecast(
                            hour: DateFormat.j().format(time),
                            iconId: hourlySkyIconId,
                            temperature: '$hourlyTemperature° C');
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Additional Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AdditionalInformation(
                          icon: Icons.water_drop,
                          title: 'Humidity',
                          iconColor: Colors.blue[200],
                          value: '${currentWeatherData['main']['humidity']}%'),
                      AdditionalInformation(
                          icon: Icons.speed,
                          title: 'Wind Speed',
                          iconColor: Colors.red[500],
                          value:
                              '${currentWeatherData['wind']['speed'].toString()} m/s'),
                      AdditionalInformation(
                          icon: Icons.air,
                          iconColor: Colors.grey[350],
                          title: 'Pressure',
                          value:
                              '${currentWeatherData['main']['pressure'].toString()} mBar'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AdditionalInformation(
                        title: 'Sunrise',
                        iconColor: Colors.yellow,
                        value: sunrise,
                        icon: WeatherIcons.sunInv,
                      ),
                      AdditionalInformation(
                        title: 'Sunset',
                        iconColor: const Color.fromARGB(255, 9, 20, 82),
                        value: sunset,
                        icon: WeatherIcons.moonInv,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
