class Weather {
  final String cityName;
  final double temp;
  final String description;
  final String icon;

  Weather({
    required this.cityName,
    required this.temp,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name']?.toString() ?? 'Không xác định',
      temp: (json['main']?['temp'] as num?)?.toDouble() ?? 0.0,
      description: json['weather']?[0]?['description'] ?? '',
      icon: json['weather']?[0]?['icon'] ?? '',
    );
  }
}
