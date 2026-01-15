import 'package:flutter/material.dart';
import 'package:app_weather/models/weather.dart';
import 'package:app_weather/services/weather_service.dart';

class WeatherProvider extends ChangeNotifier{
  final _weatherservice = WeatherService();
  Weather? _weather; //luu tru du lieu thoi tiet 
  bool _isLoading = false;
  String _error = '';
  // getter
  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String get error => _error;

  bool get isNight => _weather != null && _weather!.icon.endsWith('n'); // "!" khang dinh la no khong bi null

  Future<void> fectWeatherData (String cityName) async{
    _isLoading = true;
    _error = '';
    notifyListeners(); //bao cho ui hien loading
    try{
      _weather = await _weatherservice.fetchWeather(cityName);
    } catch( e){
      _error = e.toString();
      _weather = null;
    } finally{
      _isLoading = false;
      notifyListeners();
    }
  }
}