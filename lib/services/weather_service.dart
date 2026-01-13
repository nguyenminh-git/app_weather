import 'package:app_weather/models/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final String api_key='e591268c6e7d6100b21567e5ae3ce3e6';
  Future<Weather> fechWeather(String cityName) async{
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$api_key&units=metric&lang=vi');
    final response = await http.get(url);
    if(response.statusCode ==200){
      final data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('không lấy được dữ liệu');
    }
  }
}