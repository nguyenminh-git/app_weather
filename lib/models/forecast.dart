class ForeCastItem {
  final DateTime dateTime;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String icon;
  final String description;
  final int humidity;     // Độ ẩm
  final double windSpeed; // Tốc độ gió
  final double pop;       // Khả năng mưa (0 -> 1)

  ForeCastItem({
    required this.dateTime,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.icon,
    required this.description,
    //required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
  });

  factory ForeCastItem.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather0 = (json['weather'] as List).first as Map<String, dynamic>;
    
    // Lấy object 'wind' để lấy tốc độ gió
    final wind = json['wind'] as Map<String, dynamic>;

    return ForeCastItem(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temp: (main['temp'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      icon: weather0['icon'] as String,
      description: weather0['description'] as String,
      //feelsLike: (main['feels_like'] as num).toDouble(), // Cảm giác thực
      humidity: main['humidity'] as int,                // Độ ẩm (thường là int)
      windSpeed: (wind['speed'] as num).toDouble(),     // Gió nằm trong object 'wind'
      pop: (json['pop'] as num?)?.toDouble() ?? 0.0,  // 'pop' nằm ngay bên ngoài, giá trị từ 0 đến 1 (vd: 0.5 là 50%)
    );
  }
}