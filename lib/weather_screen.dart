import 'dart:convert';
import 'dart:ui';
//°
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/additional_info.dart';
import 'package:weather/secrets.dart';
import 'package:weather/weather_Forecst.dart';
import 'package:http/http.dart' as http;

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
      String cityName = 'Kathmandu';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$weatherApiKey',
        ),
      );
      final data = jsonDecode(res.body);
      // ignore: unrelated_type_equality_checks
      if (data['cod'] != '200') {
        throw 'an unexpected error occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentWeather = data['list'][0];
          final currentTemp = currentWeather['main']['temp'];
          final currentSky = currentWeather['weather'][0]['main'];
          final pressure = currentWeather['main']['pressure'];
          final windSpeed = currentWeather['wind']['speed'];
          final humidity = currentWeather['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(14.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: ClipRRect(
                    borderRadius: BorderRadiusDirectional.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              '$currentTemp K',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              currentSky == 'Clouds' || currentSky == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 70,
                            ),
                            Text(
                              currentSky,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Hourley Forecast',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      final hourly = data['list'][index + 1];
                      final hourleySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hourleyTemp = hourly['main']['temp'].toString();
                      final time = DateTime.parse(hourly['dt_txt']);
                      return Hourly(
                          icons: hourleySky == 'Clouds' || hourleySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          time: DateFormat.jmv().format(time),
                          value: hourleyTemp);
                    }),
              ),
              const SizedBox(height: 20),
              const Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Additional(
                    icon: Icons.water_drop,
                    text: 'Humidity',
                    value: humidity.toString(),
                  ),
                  Additional(
                    icon: Icons.air_sharp,
                    text: 'Wind Speed',
                    value: windSpeed.toString(),
                  ),
                  Additional(
                    icon: Icons.beach_access_sharp,
                    text: 'Pressure',
                    value: pressure.toString(),
                  ),
                ],
              )
            ]),
          );
        },
      ),
    );
  }
}
