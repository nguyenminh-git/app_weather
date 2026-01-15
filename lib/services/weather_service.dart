import 'package:app_weather/models/forecast.dart';
import 'package:app_weather/models/weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final String api_key= dotenv.env['api_key']!;
  Future<Weather> fetchWeather(String cityName) async{
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$api_key&units=metric&lang=vi');
    final response = await http.get(url); //response: phan hoi
    if(response.statusCode ==200){
      final data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('không lấy được dữ liệu');
    }
  }
  Future<List<ForeCastItem>> fetchForeCast5Day(String cityName) async{
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$api_key&units=metric&lang=vi');
    final res = await http.get(url);
    if(res.statusCode!=200){
      throw Exception('Forecast error: ${res.body}');
    }
    final data = jsonDecode(res.body) as Map<String,dynamic>;
    final list=(data['list'] as List).map((e)=>ForeCastItem.fromJson(e as Map<String,dynamic>)).toList();
    return list;
  }
}