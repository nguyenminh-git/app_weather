import 'package:app_weather/models/forecast.dart';
import 'package:flutter/material.dart';
import 'package:app_weather/models/weather.dart';
import 'package:app_weather/services/weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherProvider extends ChangeNotifier{
  final _weatherservice = WeatherService();
  Weather? _weather; //luu tru du lieu thoi tiet 
  bool _isLoading = false;
  String _error = '';
  List<ForeCastItem> _forecast = [];
  // getter
  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String get error => _error;
  List<ForeCastItem> get forecast => _forecast;
  bool get isNight => _weather != null && _weather!.icon.endsWith('n'); // "!" khang dinh la no khong bi null

  Future<void> fetchWeatherData (String cityName) async{
    _isLoading = true;
    _error = '';
    notifyListeners(); //bao cho ui hien loading
    try{
      _weather = await _weatherservice.fetchWeather(cityName);
      _forecast = await _weatherservice.fetchForeCast5Day(cityName);
    } catch( e){
      _error = e.toString();
      _weather = null;
      _forecast = [];
    } finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByCurrentLocation() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Dịch vụ vị trí bị vô hiệu hóa.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Quyền truy cập vị trí bị từ chối.');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Quyền truy cập vị trí bị từ chối vĩnh viễn.');
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        String city = placemarks[0].administrativeArea ?? placemarks[0].locality ?? placemarks[0].subAdministrativeArea ?? 'Hanoi';
        
        // Loại bỏ các từ thừa như Tỉnh, Thành phố (nếu có) để call API OpenWeather dễ hơn
        city = city.replaceAll('Tỉnh ', '').replaceAll('Thành phố ', '').replaceAll('City', '').trim();

        _weather = await _weatherservice.fetchWeather(city);
        _forecast = await _weatherservice.fetchForeCast5Day(city);
      } else {
        throw Exception('Không xác định được vị trí của bạn.');
      }
    } catch (e) {
      _error = e.toString();
      _weather = null;
      _forecast = [];
      rethrow; // Bắn lỗi ra để bên màn hình intro xử lý fallback
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}