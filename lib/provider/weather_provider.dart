import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:weather_flutter_project/models/current_weather.dart';
import 'package:weather_flutter_project/models/forecast_weather.dart';
import 'package:weather_flutter_project/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';

import 'package:http/http.dart' as http;

class WeatherProvider extends ChangeNotifier {
  final _weatherBox = Hive.box('weather');
  double _latitude = 0.0;
  double _longitude = 0.0;
  String unit = metric;
  CurrentWeather? currentWeather;
  ForecastWeather? forecastWeather;

  bool get hasDataLoaded => currentWeather != null &&
      forecastWeather != null;

  setNewLocation(double lat, double lng) {
    _latitude = lat;
    _longitude = lng;
  }

  setTempUnit(bool tag) {
    unit = tag ? imperial : metric;
  }

  String get tempUnitSymbol => unit == metric ? celsius : fahrenheit;

  Future<String> convertCityToCoord(String city) async {
    try {
      final locationList = await locationFromAddress(city);
      if(locationList.isNotEmpty) {
        final location = locationList.first;
        setNewLocation(location.latitude, location.longitude);
        getData();
        return 'Fetching data for $city';
      } else {
        return 'Could not found location';
      }
    } catch (_) {


      return 'No Internet Connection';
    }
  }

  getData() {
    _getCurrentData();
    _getForecastData();
  }

  Future<void> _getCurrentData() async {
    final uri = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$_latitude&lon=$_longitude&units=$unit&appid=$weatherApiKey');
    try {
      final response = await http.get(uri);
      if(response.statusCode == 200) {
        final map = json.decode(response.body) as Map<String, dynamic>;
        await _weatherBox.put('currentData', map);


        currentWeather = CurrentWeather.fromJson(map);
        // Cache the data
      // await _weatherBox.put('${currentWeather!.name ?? 'null'}currentData', map);
        print(currentWeather?.main?.temp);
        notifyListeners();
      } else {
        final map = json.decode(response.body);
        print(map['message']);
      }
    } catch(error) {
      final map = _weatherBox.get('currentData');
      currentWeather = CurrentWeather.fromJson(map);

      notifyListeners();
      if (currentWeather == null) throw Exception('No internet connection and no cached data available');

      print(error.toString());
    }
  }

  Future<void> _getForecastData() async {
    final uri = Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=$_latitude&lon=$_longitude&units=$unit&appid=$weatherApiKey');
    try {
      final response = await http.get(uri);
      if(response.statusCode == 200) {
        final map = json.decode(response.body) as Map<String, dynamic>;
        await _weatherBox.put('forecastData', map);
        forecastWeather = ForecastWeather.fromJson(map);
      //await _weatherBox.put('${currentWeather!.name ?? 'null'}forecastData', map);
        print(forecastWeather?.list?.length);
        notifyListeners();
      } else {
        final map = json.decode(response.body);
        print(map['message']);
      }
    } catch(error) {

      // If API fails retrieve data from cachedData

      final map = _weatherBox.get('forecastData');
      forecastWeather = ForecastWeather.fromJson(map);
      notifyListeners();

      if (forecastWeather == null) {
        throw Exception('No internet connection and no cached data available');
      }


      print(error.toString());
    }
  }


}