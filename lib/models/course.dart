import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;

  final String time;
  final String venue;
  final String? instructor;

  const Course({
    required this.code,
    required this.name,
    required this.creditHours,
    required this.day,
    required this.icon,
    required this.time,
    required this.venue,
    this.instructor,
  });
}