import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final double creditHours; // double because some courses are 0.5 CH
  final String day;
  final String time;
  final String venue;
  final String? instructor; // null = not known yet
  final IconData icon;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.time,
    this.venue,
    this.icon, {
    this.instructor,
  });

  // 3.0 -> "3", 0.5 -> "0.5"
  String get chText =>
      creditHours % 1 == 0 ? creditHours.toInt().toString() : creditHours.toString();
}
