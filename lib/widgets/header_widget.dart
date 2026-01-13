import 'package:flutter/material.dart';

Widget buildDateHeader(bool isNight) {
  final now = DateTime.now();
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
      /* gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isNight
            ? [const Color(0xFF0B1D3A), const Color(0xFF1B3B6F)]
            : [Colors.blue.shade100, Colors.blue.shade50],
      ), */
      borderRadius: BorderRadius.circular(26),
      boxShadow: [
        BoxShadow(
          blurRadius: 18,
          offset: const Offset(0, 8),
          color: Colors.black.withOpacity(0.08),
        ),
      ],
    ),
    child: Column(
      children: [
        Text(
          'TODAY',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: isNight ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _formatDate(now),
          style: TextStyle(
            fontSize: 12,
            color: isNight ? Colors.white : Colors.black.withOpacity(0.55),
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

String _formatDate(DateTime date) {
  // VD: SATURDAY 19 MARCH 2016
  return '${_weekday(date.weekday)} ${date.day} ${_month(date.month)} ${date.year}';
}

String _weekday(int d) => const [
  'MONDAY',
  'TUESDAY',
  'WEDNESDAY',
  'THURSDAY',
  'FRIDAY',
  'SATURDAY',
  'SUNDAY',
][d - 1];

String _month(int m) => const [
  'JANUARY',
  'FEBRUARY',
  'MARCH',
  'APRIL',
  'MAY',
  'JUNE',
  'JULY',
  'AUGUST',
  'SEPTEMBER',
  'OCTOBER',
  'NOVEMBER',
  'DECEMBER',
][m - 1];
