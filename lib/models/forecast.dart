class ForeCastItem {
  final DateTime dateTime;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String icon;
  final String description;
  ForeCastItem({
    required this.dateTime,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.icon,
    required this.description,
  });
  factory ForeCastItem.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather0 = (json['weather'] as List).first as Map<String, dynamic>;
    return ForeCastItem(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temp: (main['temp'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      icon: weather0['icon'] as String,
      description: weather0['description'] as String,
    );
  }
}