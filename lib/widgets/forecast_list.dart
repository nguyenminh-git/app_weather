import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/forecast.dart';

class ForecastList extends StatelessWidget {
  final List<ForeCastItem> forecast;
  final bool isNight;
  // 1. Thêm callback để báo cho màn hình cha biết ngày nào được nhấn
  final Function(DateTime) onDaySelected; 

  const ForecastList({
    super.key,
    required this.forecast,
    required this.isNight,
    required this.onDaySelected, // 2. Yêu cầu truyền hàm này vào
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isNight ? Colors.white : Colors.black87;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      physics: const BouncingScrollPhysics(),
      // Giữ nguyên logic bỏ qua ngày đầu tiên (Today) của bạn
      itemCount: forecast.length > 1 ? forecast.length - 1 : 0,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final f = forecast[i + 1];

        // 3. Bọc toàn bộ item trong GestureDetector để bắt sự kiện nhấn
        return GestureDetector(
          onTap: () {
            // Khi nhấn, gửi ngày của item này ra ngoài
            onDaySelected(f.dateTime);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isNight
                        ? [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)]
                        : [Colors.white.withOpacity(0.6), Colors.white.withOpacity(0.3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(isNight ? 0.1 : 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Image.network(
                            'https://openweathermap.org/img/wn/${f.icon}@2x.png',
                            width: 40,
                            height: 40,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.cloud, color: textColor),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getDisplayDay(f.dateTime),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${f.dateTime.day}/${f.dateTime.month}',
                              style: TextStyle(
                                color: textColor.withOpacity(0.6),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${f.temp.round()}°',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getDisplayDay(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    const names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return names[date.weekday - 1];
  }
}